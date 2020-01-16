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
        var allBaseClasses = Set<String>() // 过滤属于基类的类
        var cellClasses = Set<String>() // 过滤 Cell 基类
        var methodDefineUseClasses = Set<String>() // 过滤方法定义时用过的类
        var propertyTypes = Set<String>() // 过滤属性使用的类
        
        let allNodes = ParseOC.ocNodes(workspacePath: workSpacePath)
        
        // 所有类
        var allClassSet:Set<String> = Set()
        // 所有类和基类的关系
        var classAndBaseClass = [String:String]()
        
        
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass

                allClassSet.insert(classValue.className)
                if classValue.baseClass.count > 0 {
                    allBaseClasses.insert(classValue.baseClass)
                    classAndBaseClass[classValue.className] = classValue.baseClass
                }
                if classValue.properties.count > 0 {
                    //
                    for aProperty in classValue.properties {
                        propertyTypes.insert(aProperty.type)
                    }
                }
                
            } // end if aNode.type == .class
            
            if aNode.type == .method {
                let methodValue = aNode.value as! OCNodeMethod
                methodDefineUseClasses.insert(methodValue.returnType)
                if methodValue.paramTypes.count > 0 {
                    for aPType in methodValue.paramTypes {
                        methodDefineUseClasses.insert(aPType)
                    }
                }
            }
            
        } // end for aNode in allNodes
        
        print("过滤方法定义时用过的类")
        print(methodDefineUseClasses)
        
        print("过滤属性使用的类")
        print(propertyTypes)
        
        // 找出类的继承链
        
        func recursiveBaseClass(className:String,baseClasses:Set<String>) -> Set<String> {
            var reBaseClasses = baseClasses
            guard let baseClass = classAndBaseClass[className] else {
                return Set<String>()
            }
            
            if baseClass != "NSObject" && classAndBaseClass[baseClass] != baseClass {
                
            } else {
                return Set<String>()
            }
            
            if className.hasPrefix("NS") || className.hasPrefix("UI") {
                return Set<String>()
            }
            
            // 以上是跳出递归的条件
            reBaseClasses.insert(baseClass)
            
            let recursiveClasses = recursiveBaseClass(className: baseClass, baseClasses: baseClasses)
            for aClass in recursiveClasses {
                reBaseClasses.insert(aClass)
            }
            
            return reBaseClasses
        }
        
        var classWithBaseClasses = [String:Set<String>]() // 类的继承链
        
        for aClass in allClassSet {
            //
            let baseClasses = Set<String>()
            guard let baseClass = classAndBaseClass[aClass] else {
                continue
            }
            let reRecur = recursiveBaseClass(className: aClass, baseClasses: baseClasses)
            if reRecur.count > 0 {
                classWithBaseClasses[aClass] = reRecur
            }
        }
        
        // 通过类的继承链找出基类是 Cell 的，还有类名后缀是 Cell 的
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                
                guard let nodeBaseClasses = classWithBaseClasses[classValue.className] else {
                    continue
                }
                
                if nodeBaseClasses.contains("UITableViewCell") {
                    cellClasses.insert(classValue.className)
                }
                
//                if classValue.className.hasSuffix("Cell") {
//                    cellClasses.insert(classValue.className)
//                }
            }
            
        }
        
        // 开始递归检查无用类
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
            } // end for
            
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
            if allBaseClasses.contains(aSet) {
                shouldFilter = true
            }
            // 过滤 cell
            if cellClasses.contains(aSet) {
                shouldFilter = true
            }
            
            // 过滤方法定义时用的类
            if methodDefineUseClasses.contains(aSet) {
                shouldFilter = true
            }
            
            // 过滤属性用到的类
            if propertyTypes.contains(aSet) {
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
            let classStructArr = ModifyOCContent(inputFilePath: filePath).commentedOutUnUsedClass(unUsedClasses: unUsedClassFromRecursive)
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
            
            // 后面加上时间主要是测试用，由于在文件名中加入了时间，会出现一个文件里多处修改会相互覆盖的问题。这个问题会在去除时间后解除。
            FileHandle.fileSave(content: newContent, path: "\(data.filePath)")
            
            // 统计
            OCStatistics.unUsedClasses(className: data.className, classStruct: data)
        }
        
        FileHandle.writeToDownload(fileName: "ClassContent\(nowDateFormat())", content: saveStr)
        
        let sortedClassInfo = allClassInfo.sortedByValue
        
        // 生成Excel，内容包括类名，对应的行、bundle、owner
        let classBundleOwner = ParseOCMethodContent.loadClassBundleOwner()
        var saveInfoStr = "类名,行,Bundle,Owner\n"
        var totalLine = 0
        for (k,v) in sortedClassInfo {
            //
            let className = k.components(separatedBy: "-")[0]
            
            guard let kClassBundleOwner = classBundleOwner[className] else {
                continue
            }
            let (bundle,owner) = kClassBundleOwner
            saveInfoStr += "\(k),\(v),\(bundle),\(owner)\n"
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
    
    
    // Bundle 和 Class 的关系
    static func loadClassBundleOwner() -> [String:(String,String)] {
        
        let content = FileHandle.fileContent(path: Config.classBundleOwner.rawValue)
        
        let tokens = Lexer(input: content, type: .plain).allTkFast(operaters: ",")
        var allTks = [[Token]]()
        var currentTks = [Token]()
        for tk in tokens {
            if tk == .newLine {
                allTks.append(currentTks)
                currentTks = [Token]()
                continue
            }
            if tk == .id(",") {
                continue
            }
            currentTks.append(tk)
        }
        
        var classBundleOwnerDic = [String:(String,String)]()
        for tks in allTks {
            var i = 0
            var currentClass = ""
            var currentBundle = ""
            var currentOwner = ""
            for tk in tks {
                if i == 0 {
                    // class
                    currentClass = tk.des()
                }
                if i == 1 {
                    // bundle
                    currentBundle = tk.des()
                }
                if i == 2 {
                    // owner
                    currentOwner = tk.des()
                }
                i += 1
            }
            classBundleOwnerDic[currentClass] = (currentBundle,currentOwner)
        }
        return classBundleOwnerDic
    }
    
    static func parseClassAndBundle() {
        
        let content = FileHandle.fileContent(path: Config.classBundleOnwerOrigin.rawValue)
        let contentWithoutWhiteSpace = content.replacingOccurrences(of: " ", with: "")
        let tokens = Lexer(input: contentWithoutWhiteSpace, type: .plain).allTkFast(operaters: ",")
        var allTks = [[Token]]()
        var currentTks = [Token]()
        for tk in tokens {
            if tk == .newLine {
                allTks.append(currentTks)
                currentTks = [Token]()
                continue
            }
            if tk == .id(",") {
                continue
            }
            currentTks.append(tk)
        }
        //print(allTks)
        allTks.remove(at: 0)
        var classBundleDic = [String:String]()
        var ownerBundleDic = [String:String]()
        for tks in allTks {
            var i = 0
            var currentBundle = ""
            var currentClass = ""
            for tk in tks {
                if i == 0 {
                    currentBundle = tk.des()
                }
                if i == 1 {
                    currentClass = tk.des()
                    classBundleDic[currentClass] = currentBundle
                    
                }
                if i == 2 {
                    ownerBundleDic[currentClass] = tk.des()
                }
                i += 1
            }
        }
        var str = ""
        for (k,v) in classBundleDic {
            guard let owner = ownerBundleDic[k] else {
                continue
            }
            str.append("\(k),\(v),\(owner)\n")
        }
        try! str.write(toFile: "/Users/ming/Downloads/ClassBundle1025.csv", atomically: true, encoding: String.Encoding.utf8)
    }
    
    // MARK:辅助方法
    // 遍历所有节点
    
    struct FilterClassData {
        var allClassSet: Set<String>
        var allBaseClasses: Set<String>
        var propertyTypes: Set<String>
        var methodDefineUseClasses: Set<String>
        var classAndBaseClass: [String:String]
        
    }
    
    static func traverseAllNodes(allNodes:[OCNode]) {
        var filterClassData = FilterClassData(allClassSet: Set<String>(), allBaseClasses: Set<String>(), propertyTypes: Set<String>(), methodDefineUseClasses: Set<String>(), classAndBaseClass: [String:String]())
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
    
                filterClassData.allClassSet.insert(classValue.className)
                if classValue.baseClass.count > 0 {
                    filterClassData.allBaseClasses.insert(classValue.baseClass)
                    filterClassData.classAndBaseClass[classValue.className] =   classValue.baseClass
                }
                if classValue.properties.count > 0 {
                    //
                    for aProperty in classValue.properties {
                        filterClassData.propertyTypes.insert(aProperty.type)
                    }
                }
            
            } // end if aNode.type == .class
            
            if aNode.type == .method {
                let methodValue = aNode.value as! OCNodeMethod
                    filterClassData.methodDefineUseClasses.insert(methodValue   .returnType)
                if methodValue.paramTypes.count > 0 {
                    for aPType in methodValue.paramTypes {
                        filterClassData.methodDefineUseClasses.insert(aPType)
                    }
                }
            } // end if aNode.type == .method
        } // end for aNode in allNodes
    } // end func
    
    // MARK:parseMethodCall TODO: 需要先解决变量名所属哪个类的问题，前置条件是全局变量、属性、临时变量得解出来。
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
