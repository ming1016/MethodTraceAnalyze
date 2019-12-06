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
//        let allPath = XcodeProjectParse.allSourceFileInWorkspace(path: "/Users/ming/Downloads/GCDFetchFeed/GCDFetchFeed/GCDFetchFeed.xcworkspace")
        
        let allNodes = ParseOC.ocNodes(workspacePath: "/Users/ming/Downloads/GCDFetchFeed/GCDFetchFeed/GCDFetchFeed.xcworkspace")
        
//        let allPath = XcodeProjectParse.allSourceFileInWorkspace(path: "")
//
//        var allNodes = [OCNode]()
//
//        let groupCount = 64 // 一组容纳个数
//        let groupTotal = allPath.count/groupCount + 1
//
//        var groups = [[String]]()
//        for i in 0..<groupTotal {
//            var group = [String]()
//            for j in i*groupCount..<(i+1)*groupCount {
//                if j < allPath.count {
//                    group.append(allPath[j])
//                }
//            }
//            if group.count > 0 {
//                groups.append(group)
//            }
//        }
//
//        for group in groups {
//            let dispatchGroup = DispatchGroup()
//
//            for node in group {
//                dispatchGroup.enter()
//                let queue = DispatchQueue.global()
//                queue.async {
//                    let ocContent = FileHandle.fileContent(path: node)
//                    let node = ParseOCNodes(input: ocContent).parse()
//                    for aNode in node.subNodes {
//                        allNodes.append(aNode)
//                    }
//                    dispatchGroup.leave()
//
//                } // end queue async
//            } // end for
//            dispatchGroup.wait()
//        }
//
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
