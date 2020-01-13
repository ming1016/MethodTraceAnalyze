//
//  XcodeProjectParse.swift
//  SA
//
//  Created by ming on 2019/8/20.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class XcodeProjectParse {
    
    
    // MARK: 获取 Workspace 里所有的源文件。
    public static func allSourceFileInWorkspace(path: String) -> [String] {
        var pathArr = path.split(separator: "/")
        pathArr.removeLast()
        let pathStr = pathArr.joined(separator: "/")
        
        let allFiles = FileHandle.allFilePath(path: path)
        if allFiles.count == 0 {
            return [String]()
        }
        
        var allSourceFile = [String]() // 获取的所有源文件路径
        
        for aFile in allFiles {
            if aFile.fileName == "contents.xcworkspacedata" {
                let root = ParseStandXML(input: aFile.content).parse()
                let workspace = root.subNodes[1]
                
                for fileRef in workspace.subNodes {
                    var fileRefPath = fileRef.attributes[0].value
                    fileRefPath.removeFirst(6)
                    
                    // 判断是相对路径还是绝对路径
                    let arr = fileRefPath.split(separator: "/")
                    var projectPath = ""
                    if arr.count > 2 {
                        projectPath = "\(fileRefPath)/project.pbxproj"
                    } else {
                        projectPath = "/\(pathStr)/\(fileRefPath)/project.pbxproj"
                    }
                    // 读取 project 文件内容分析
                    
                    allSourceFile += ParseXcodeprojSource(input: projectPath).parseAllFiles()
                    
                } // end for fileRef in workspace.subNodes
                
            } // end for
        } // end for
        
        return allSourceFile

    } // end for
    
    
}
