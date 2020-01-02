//
//  TestOC.swift
//  SA
//
//  Created by ming on 2019/11/18.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class TestOC: Test {
    
    public func testWorkspace() {
        
        let allNodes = ParseOC.ocNodes(workspacePath: Config.workPath.rawValue)
  
        var saveStr = ""
        for aNode in allNodes {
            saveStr += "//\(aNode.identifier)\n---\n\(aNode.source)\n\n"
        }
        FileHandle.writeToDownload(fileName: "methodSource", content: saveStr)
        
    }
    
    public func parseOC(groups:[[String]],index:Int) {
        
        guard index < groups.count else {
            return
        }
        
    }
    
    public static func testM(filePath:String) {
        let mContent = FileHandle.fileContent(path: filePath)
        let node = ParseOCNodes(input: mContent, filePath: filePath).parse()
        var saveStr = ""
        for aNode in node.subNodes {
            saveStr += "//\(aNode.identifier)\n---\n\(aNode.source)\n\n"
        }
        FileHandle.writeToDownload(fileName: "oneFileMethodSource", content: saveStr)
    }
    
    public static func testUnUsedClass(filePath:String) {
        let allNodes = ParseOC.ocNodes(workspacePath: Config.workPath.rawValue)
//        var classSet:Set = ["NSObject"]
        var classSet:Set<String> = Set()
        for aNode in allNodes {
            //
            if aNode.type == .class {
                let classValue = aNode.value as! OCNodeClass
                classSet.insert(classValue.className)
            }
        }
//        for a in classSet {
//            print(a)
//        }
        var allUsedClassSet:Set<String> = Set()
        for aNode in allNodes {
            if aNode.type == .method {
                //
                let usedSet = ParseOCMethodContent.parseAMethodUsedClass(node: aNode, allClass: classSet)
                if usedSet.count > 0 {
                    for aSet in usedSet {
                        allUsedClassSet.insert(aSet)
                    }
                }
            }
        }
        var unUsedClass:Set<String> = Set()
        for a in classSet {
            if !allUsedClassSet.contains(a) {
                unUsedClass.insert(a)
            }
        }
        for aSet in unUsedClass {
            print(aSet)
        }
        
    }
    
    // MARK:TODO:方法调用
    public static func testMethodCall(filePath:String) {
        
        let mContent = FileHandle.fileContent(path: filePath)
        let node = ParseOCNodes(input: mContent, filePath: filePath).parse()
        for aNode in node.subNodes {
            if aNode.type == .method {
                //
            }
        }
    }
    
    public static func testOC() {
        
        let ocPath = Bundle.main.path(forResource: "AppDelegate", ofType: "txt") ?? ""
        let ocContent = FileHandle.fileContent(path: ocPath)
        
        let node = ParseOCNodes(input: ocContent, filePath: ocPath).parse()
        
        print(node)
    }
}
