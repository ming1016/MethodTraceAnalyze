//
//  SeekOCWarning.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/12/23.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class OCStatistics {
    
    // MARK: 执行完后的统计
    // 调用过的方法和调用次数
    static var calledMethodAndCount = [String:Int]()
    static func calledMethodAndCount(methodId:String) {
        if calledMethodAndCount[methodId] != nil {
//            calledMethodAndCount
        }
    }
    
    // 每个类对应父类栈
    static func classChain(classAndBaseClassMap: [String:String]) -> [String:[String]] {
        var chainMap = [String:[String]]()
        
        func recusiveParent(container:[String], parent:String) -> [String] {
            // 三种情况可能会跳不出
            if classAndBaseClassMap.keys.contains(parent) && parent != "NSObject" && classAndBaseClassMap[parent] != parent {
                let grandpa = classAndBaseClassMap[parent] ?? ""
                var mContainer = container
                mContainer.append(grandpa)
                return recusiveParent(container: mContainer, parent: grandpa)
            }
            
            return container
        }

        for (k,v) in classAndBaseClassMap {
            var vArr = [String]()
            vArr.append(v)
            chainMap[k] = recusiveParent(container: vArr, parent: v)
            
        }
        return chainMap
    }
    
    // MARK: 进行中的统计
    
    // 有哪些运行时方法调用，没有源码
    static var noSourceMethod = [String]()
    static func noSourceMethod(methodId:String) {
        runSerial {
            noSourceMethod.append(methodId)
        }
    }
    
    // 哪些方法是直接用的父类的方法
    static var useBaseClassMethod = [String]()
    static func useBaseClassMethod(methodId:String) {
        runSerial {
            useBaseClassMethod.append(methodId)
        }
        
    }
    
    // 方法
    static var methodContent = [String:String]()
    static func methodContent(method:String, content:String) {
        runSerial {
            methodContent[method] = content
        }
    }
    
    // 类和基类对应表
    static var classAndBaseClass = [String:String]()
    static func classAndBaseClass(aClass: String, baseClass: String) {
        runSerial {
            classAndBaseClass[aClass] = baseClass
//            print("aClass:\(aClass) baseClass:\(baseClass)")
        }
    }
    
    // 每个文件的行数
    static var fileLines = [String:Int]()
    static var fileLinesTotal = 0
    static func fileLine(filePath:String, lines:Int) {
        runSerial {
            fileLines[filePath] = lines
            fileLinesTotal += lines
//            print("filePath: \(filePath) lines: \(lines)")
            print("lines total: \(fileLinesTotal)")
        }
    }
    
    // 没有使用 group path 的文件
    static var noUseGroupPathes = [String]()
    static func noUseGroupPath(fileName:String) {
        runSerial {
            noUseGroupPathes.append(fileName)
//            print("no use group path:\(fileName)")
        }
    }
    
    // MARK: 基本工具
    typealias WorkQueueClosure = ()->Void
    static let workQueue = DispatchQueue(label: "com.MethodTraceAnalyze.statisticsQueue",qos: DispatchQoS.background)
    static func runSerial(closure:@escaping WorkQueueClosure) {
        workQueue.async(execute: closure)
    }
    
    static func showAll() {
        print("方法总数: \(OCStatistics.methodContent.keys.count)")
        print("有基类的方法总数: \(OCStatistics.classAndBaseClass.keys.count)")
        print("行总数: \(OCStatistics.fileLinesTotal)")
        // 按行排序
        let sortFileLines = fileLines.sortedByValue
        for (k,v) in sortFileLines {
            print("\(k) \(v)")
        }
//        print("没有源码的方法总数：\(OCStatistics.noSourceMethod.count)")
//        print("没有源码的方法：")
//        for method in OCStatistics.noSourceMethod {
//            print(method)
//        }
//        print("使用父类方法的方法总数：\(OCStatistics.useBaseClassMethod.count)")
//        for method in OCStatistics.useBaseClassMethod {
//            print(method)
//        }
    }
}
