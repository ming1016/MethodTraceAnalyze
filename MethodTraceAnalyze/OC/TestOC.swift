//
//  TestOC.swift
//  SA
//
//  Created by ming on 2019/11/18.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class TestOC: Test {
    public static func testWorkspace() {
        let allPath = XcodeProjectParse.allSourceFileInWorkspace(path: "")
//        print(allPath)
        var allNodes = [OCNode]()
        for aPath in allPath {
            //
            print(aPath)
            let ocContent = FileHandle.fileContent(path: aPath)
            let node = ParseOCNodes(input: ocContent).parse()
            for aNode in node.subNodes {
                allNodes.append(aNode)
            }
//            print(node)
        }
        var saveStr = ""
        for aNode in allNodes {
            saveStr += "//\(aNode.identifier)\n---\n\(aNode.source)\n\n"
        }
        FileHandle.writeToDownload(fileName: "methodSource", content: saveStr)
    }
    
    public static func testM() {
        let mContent = FileHandle.fileContent(path: "")
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
