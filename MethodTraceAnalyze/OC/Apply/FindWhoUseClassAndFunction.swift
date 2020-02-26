//
//  FindWhoUseClassAndFunction.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/2/13.
//  Copyright © 2020 ming. All rights reserved.
//

import Foundation

struct FindWhoUseClassAndFunction {
    
    static func whoUseClass(workSpacePath:String, className: String) {
        // 初始化类集合
        var classesSet = Set<String>()
        classesSet.insert(className)
        
        let allNodes = ParseOC.ocNodes(workspacePath: workSpacePath)
        var allClassesSet = Set<String>()
        
        var classAndBaseClasses = [String:String]()   // 所有类和基类的关系
        // 找出基类
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                allClassesSet.insert(classValue.className)
                if classValue.baseClass.count > 0 {
                    classAndBaseClasses[classValue.className] = classValue.baseClass
                }
                
            }
        }
        
        //MARK: 找继承了制定类的类
        for aNode in allNodes {
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                
                guard let nodeBaseClasses = classAndBaseClasses[classValue.className] else {
                    continue
                }
                
                // 基类链里如果存在所制定的类名，则加入收集的集合里
                if nodeBaseClasses.contains(className) {
                    classesSet.insert(classValue.className)
                }
            }
        } // end for
        
        //MARK: 看看哪些方法用了制定的类
        
        // 初始化调用了制定类的方法节点合集
        var classUsedInMethodsSet = Set<String>()
        
        for aNode in allNodes {
            if aNode.type == .method {
                
                // 用过的类
                let usedSet = FindWhoUseClassAndFunction.parseAMethodUsedClass(node: aNode, allClass: allClassesSet)
                if usedSet.count > 0 {
                    for aClass in classesSet {
                        if usedSet.contains(aClass) {
                            classUsedInMethodsSet.insert(aNode.identifier)
                        }
                    }
                }
                
                
            } // end if
        } // end for
        
        //MARK: 保存到 excel 里
        
        // 取出 owner 和 bundle 对应关系
        let classBundleOwner = OCApplyFeature.loadClassBundleOwner()
        
        var saveClassUsedMethodsAndBundlesStr = "方法,Bundle,Owner\n"
        for aMethod in classUsedInMethodsSet {
            let className = OCApplyFeature.bundleAndClassFromName(name: aMethod)
            guard let kClassBundleOwner = classBundleOwner[className] else {
                continue
            }
            let (bundle, owner) = kClassBundleOwner
            saveClassUsedMethodsAndBundlesStr.append("\(aMethod),\(bundle),\(owner)\n")
        }
        
        FileHandle.writeToDownload(fileName: "\(className)\(nowDateFormat())", content: saveClassUsedMethodsAndBundlesStr)
        
        
    } // end func
    
    
    
    //MARK: 找出单个方法内用过的类
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
}
