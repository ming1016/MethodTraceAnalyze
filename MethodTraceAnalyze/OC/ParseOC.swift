//
//  ParseOC.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/12/6.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class ParseOC {
    public static func ocNodes(workspacePath:String) -> [OCNode] {
        var allPath = XcodeProjectParse.allSourceFileInWorkspace(path: workspacePath)
//        for path in allPath {
//            //
//            print(path)
//        }
        var allNodes = [OCNode]()
        
        let groupCount = 60 // 一组容纳个数
        let groupTotal = allPath.count/groupCount + 1

        var groups = [[String]]()
        for i in 0..<groupTotal {
            var group = [String]()
            for j in i*groupCount..<(i+1)*groupCount {
                if j < allPath.count {
                    group.append(allPath[j])
                }
            }
            if group.count > 0 {
                groups.append(group)
            }
        }

        for group in groups {
            let dispatchGroup = DispatchGroup()

            for node in group {
                dispatchGroup.enter()
                let queue = DispatchQueue.global()
                queue.async {
                    let ocContent = FileHandle.fileContent(path: node)
                    let node = ParseOCNodes(input: ocContent, filePath: node).parse()
                    for aNode in node.subNodes {
                        allNodes.append(aNode)
                    }
                    dispatchGroup.leave()

                } // end queue async
            } // end for
            dispatchGroup.wait()
        } // end for
        
        
        return allNodes
    }
}
