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
        let allNodes = ParseOC.ocNodes(workspacePath: workSpacePath)
        
        var allClassSet:Set<String> = Set()
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                allClassSet.insert(classValue.className)
            }
        } // end for aNode in allNodes
        
        var recursiveCount = 0
        
        func recursiveCheckUnUsedClass(unUsed:Set<String>) -> Set<String> {
            recursiveCount += 1
            print("into recursive!!!!第\(recursiveCount)次")
            for a in unUsed {
                print(a)
            }
            var unUsedClassSet = unUsed
            
            // 清理无用
            for aUnUsed in unUsedClassSet {
                if allClassSet.contains(aUnUsed) {
                    allClassSet.remove(aUnUsed)
                }
            }
            
            var allUsedClassSet:Set<String> = Set()
            for aNode in allNodes {
                if aNode.type == .method {
                    let nodeValue:OCNodeMethod = aNode.value as! OCNodeMethod
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
            for aSet in allClassSet {
                if !allUsedClassSet.contains(aSet) {
                    unUsedClassSet.insert(aSet)
                    hasUnUsed = true
                }
            }
            
            if hasUnUsed {
                return recursiveCheckUnUsedClass(unUsed: unUsedClassSet)
            }
            
            return unUsedClassSet
        }
        
        var unUsedClassFromRecursive = recursiveCheckUnUsedClass(unUsed: Set<String>())
        let unUsedClassSetCopy = unUsedClassFromRecursive
        for aSet in unUsedClassSetCopy {
            //
            let filters = ["NS","UI"]
            var shouldFilter = false
            for filter in filters {
                if aSet.hasPrefix(filter) {
                    shouldFilter = true
                }
            }
            if shouldFilter {
                unUsedClassFromRecursive.remove(aSet)
            }
        }
        
        print("所有无用类：")
        for a in unUsedClassFromRecursive {
            print(a)
        }
        
        return unUsedClassFromRecursive
    }
    
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
