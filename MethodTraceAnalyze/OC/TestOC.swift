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
        let node = ParseOCNodes(input: mContent).parse()
        var saveStr = ""
        for aNode in node.subNodes {
            saveStr += "//\(aNode.identifier)\n---\n\(aNode.source)\n\n"
        }
        FileHandle.writeToDownload(fileName: "oneFileMethodSource", content: saveStr)
    }
    
    public static func testOC() {
        
        let ocPath = Bundle.main.path(forResource: "AppDelegate", ofType: "txt") ?? ""
        
        let ocContent = FileHandle.fileContent(path: ocPath)
        
        let node = ParseOCNodes(input: ocContent).parse()
        
        print(node)
    }
}
