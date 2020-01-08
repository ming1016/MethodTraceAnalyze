//
//  ParseOCMethodContent.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/12/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class ParseOCMethodContent {
    
    static func unUsedClass(workSpacePath:String) -> Set<String> {
        var baseClasses = Set<String>() // 过滤属于基类的类
        var cellClasses = Set<String>() // 过滤 Cell 基类
        
        let allNodes = ParseOC.ocNodes(workspacePath: workSpacePath)
        
        var allClassSet:Set<String> = Set()
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                allClassSet.insert(classValue.className)
                if classValue.baseClass.count > 0 {
                    baseClasses.insert(classValue.baseClass)
                }
                if classValue.baseClasses.contains("UITableViewCell") || classValue.className.hasSuffix("Cell") {
                    cellClasses.insert(classValue.className)
                }
                
            }
        } // end for aNode in allNodes
        
        var recursiveCount = 0
        
        func recursiveCheckUnUsedClass(unUsed:Set<String>) -> Set<String> {
            recursiveCount += 1
            print("into recursive!!!!第\(recursiveCount)次")
            print("----------------------\n")
            for a in unUsed {
                print(a)
            }
            var unUsedClassSet = unUsed
            
            // 缩小范围
            for aUnUsed in unUsedClassSet {
                if allClassSet.contains(aUnUsed) {
                    allClassSet.remove(aUnUsed)
                }
            }
            
            var allUsedClassSet:Set<String> = Set()
            for aNode in allNodes {
                if aNode.type == .method {
                    let nodeValue:OCNodeMethod = aNode.value as! OCNodeMethod
                    // 过滤已判定无用类里的方法
                    guard !unUsedClassSet.contains(nodeValue.belongClass) else {
                        continue
                    }
                    
                    let usedSet = ParseOCMethodContent.parseAMethodUsedClass(node: aNode, allClass: allClassSet)
                    if usedSet.count > 0 {
                        for aSet in usedSet {
                            allUsedClassSet.insert(aSet)
                        }
                    } // end if usedSet.count > 0
                } // end if aNode.type == .method
            } // end for aNode in allNodes
            var hasUnUsed = false
            // 找出无用类
            for aSet in allClassSet {
                if !allUsedClassSet.contains(aSet) {
                    unUsedClassSet.insert(aSet)
                    hasUnUsed = true
                }
            }
            
            if hasUnUsed {
                // 如果发现还有无用的类，需要继续递归调用进行分析
                return recursiveCheckUnUsedClass(unUsed: unUsedClassSet)
            }
            
            return unUsedClassSet
        }
        
        // 递归调用
        var unUsedClassFromRecursive = recursiveCheckUnUsedClass(unUsed: Set<String>())
        
        let unUsedClassSetCopy = unUsedClassFromRecursive
        for aSet in unUsedClassSetCopy {
            // 过滤系统控件
            let filters = ["NS","UI"]
            var shouldFilter = false
            for filter in filters {
                if aSet.hasPrefix(filter) {
                    shouldFilter = true
                }
            }
            // 过滤基类
            if baseClasses.contains(aSet) {
                shouldFilter = true
            }
            // 过滤 cell
            if cellClasses.contains(aSet) {
                shouldFilter = true
            }
            
            // 开始过滤
            if shouldFilter {
                unUsedClassFromRecursive.remove(aSet)
            }
        }
        print("\n")
        print("所有无用类：")
        for a in unUsedClassFromRecursive {
            print(a)
        }
        
        // 对无用类进行删除
        let allPath = XcodeProjectParse.allSourceFileInWorkspace(path: workSpacePath)
        var allData = [commentedOutUnUsedClassStruct]()
        var allClassInfo = [String:Int]()
        FileHandle.handlesFiles(allfilePath: allPath) { (filePath, fileContent) in
            let classStructArr = ModifyOCContent(input: fileContent, inputFilePath: filePath).commentedOutUnUsedClass(unUsedClasses: unUsedClassFromRecursive)
            if classStructArr.count > 0 {
                for classStruct in classStructArr {
                    allData.append(classStruct)
                    allClassInfo[classStruct.classIdentifier] = classStruct.lineCount
                }
            } // end if
        } // end FileHandle.handlesFiles
        
        var saveStr = ""
        for data in allData {
            saveStr += "\(data.classIdentifier)\n"
            saveStr += "\(data.lineCount)\n"
            saveStr += "\(data.source)\n"
            saveStr += "\n"
            
            // 对代码进行注释
            let content = FileHandle.fileContent(path: data.filePath)
            let contentArr = content.components(separatedBy: .newlines)
            
            var newContent = ""
            var index = 0
            for line in contentArr {
                if index >= data.lineStart && index <= data.lineEnd  {
                    newContent.append("//\(line)\n")
                } else {
                    newContent.append("\(line)\n")
                } // end if
                index += 1
            } // end for
            
            FileHandle.fileSave(content: newContent, path: "\(data.filePath)\(nowDateFormat())")
        }
        
        FileHandle.writeToDownload(fileName: "ClassContent\(nowDateFormat())", content: saveStr)
        
        let sortedClassInfo = allClassInfo.sortedByValue
        
        var saveInfoStr = ""
        var totalLine = 0
        for (k,v) in sortedClassInfo {
            //
            saveInfoStr += "name:\(k) line:\(v)\n"
            totalLine += v
        }
        saveInfoStr = "总代码行：\(totalLine)\n" + saveInfoStr
        
        FileHandle.writeToDownload(fileName: "ClassLine\(nowDateFormat())", content: saveInfoStr)
        
        return unUsedClassFromRecursive
    }
    
    // 找出单个方法内用过的类
    static func parseAMethodUsedClass(node: OCNode, allClass: Set<String>) -> Set<String> {
        var usedClassSet:Set<String> = Set()
        guard node.type == .method else {
            return usedClassSet
        }
        
        let methodValue:OCNodeMethod = node.value as! OCNodeMethod
        for aNode in methodValue.tokenNodes {
            if allClass.contains(aNode.value) {
                usedClassSet.insert(aNode.value)
            }
        }
        
        return usedClassSet
    }
    
    // MARK:TODO:需要先解决变量名所属哪个类的问题，前置条件是全局变量、属性、临时变量得解出来。
    static func parseMethodCall(node:OCNode, allMethodReturns:[String:String]) -> [String] {
        guard node.type == .method else {
            return [String]()
        }
        
        enum State {
            case normal
            case callStart
            case callClassGot
            case callNameGot
            case callParamStart
        }
        
        var allMethodCall = [String]()
        
        let methodValue:OCNodeMethod = node.value as! OCNodeMethod
        let belongClass = methodValue
        
        // 返回的是 Class
        func recursiveMethodCall(tokenNodes:[OCTokenNode], level:Int) -> String {
            var currentLevel = level
            var currentState = State.normal
            
            var nextLevelNodes = [OCTokenNode]()
            var currentClass = ""
            var currentNames = [String]()
            var currentIsNoneParam = true
            
            var currentReturnClass = ""
            
            func appendNewMethodCall() {
                var methodNames = ""
                if currentIsNoneParam && currentNames.count == 1 {
                    methodNames = currentNames[0]
                } else if currentNames.count > 0 {
                    for aName in currentNames {
                        methodNames.append("\(aName):")
                    }
                }
                let methodId = "\(currentClass):\(methodNames)"
                allMethodCall.append(methodId)
                currentReturnClass = allMethodReturns[methodId] ?? ""
                // 重置
                currentClass = ""
                currentNames = [String]()
                currentIsNoneParam = true
                
            }
            
            func endCall() {
                if nextLevelNodes.count > 0 {
                    let reClass = recursiveMethodCall(tokenNodes: nextLevelNodes, level: level)
                    if currentClass.count > 0 {
                        //
                    } else {
                        currentClass = reClass
                    }
                } else {
                    appendNewMethodCall()
                }
            }
            
            for aNode in tokenNodes {
                
                if currentState == .callNameGot {
                    
                    if aNode.value == ":" {
                        // [foo method:
                        currentState = .callParamStart
                    } else if aNode.value == "]" {
                        // [foo method]
                        currentLevel -= 1
                        if currentLevel == level {
                            endCall()
                        }
                    }
                    continue
                }
                
                // [foo method
                if currentState == .callClassGot {
                    currentNames.append(aNode.value)
                    currentState = .callNameGot
                    
                    if aNode.value == "]" {
                        currentLevel -= 1
                        if currentLevel == level {
                            endCall()
                        }
                    }
                    nextLevelNodes.append(aNode)
                    continue
                }
                
                // [foo
                if currentState == .callStart {
                    // [[foo
                    if aNode.value == "[" {
                        currentLevel += 1
                    } else {
                        currentClass = aNode.value
                        currentState = .callClassGot
                    }
                    continue
                }
                
                if aNode.value == "[" {
                    currentState = .callStart
                    currentLevel += 1
                    continue
                }
            }
            
            return currentReturnClass
        }
        
        let level = 0
        let _ = recursiveMethodCall(tokenNodes: methodValue.tokenNodes, level: level)
        
        
        return [String]()
    }
    
    
}
