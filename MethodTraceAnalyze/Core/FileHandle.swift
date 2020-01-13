//
//  FileHandle.swift
//  SA
//
//  Created by ming on 2019/8/2.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class FileHandle {
    
    public static func allFilePath(path: String) -> [File] {
        let fileManager = FileManager.default
        let allPath = fileManager.enumerator(atPath: path)
        guard let allfiles = allPath?.allObjects else {
            print("path no found")
            return []
        }
        var reAllFiles = [File]()
        for afilePath in allfiles {
            let aFileFullPath = "\(path)/\(afilePath)"
            do {
                let content = try String(contentsOfFile: aFileFullPath, encoding: String.Encoding.utf8)
                reAllFiles.append(File(fileName: "\(afilePath)", path: aFileFullPath, content: content))
            } catch {
                continue
            }
        }
        return reAllFiles
    }
    
    // 根据文件路径返回文件内容
    public static func fileContent(path: String) -> String {
        do {
            return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        } catch {
            return ""
        }
    }
    
    public static func fileSave(content:String, path:String) {
        do {
            try content.write(to: URL(fileURLWithPath: path), atomically: false, encoding: String.Encoding.utf8)
        } catch {
            //
        }
    }
    
    // 保存文件到下载目录
    public static func writeToDownload(fileName: String, content: String) {
        try! content.write(toFile: "\(Config.downloadPath.rawValue)\(fileName)", atomically: true, encoding: String.Encoding.utf8)
    }
    
    public static func handlesFiles(allfilePath:[String], handle:@escaping(String,String)->Void) {
        let handleBlock = handle
        let groupCount = 60
        let groupTotal = allfilePath.count / groupCount + 1
        
        var groups = [[String]]()
        for i in 0..<groupTotal {
            var group = [String]()
            for j in i * groupCount..<(i+1) * groupCount {
                if j < allfilePath.count {
                    group.append(allfilePath[j])
                }
            }
            if group.count > 0 {
                groups.append(group)
            }
        } // end for
        
        for group in groups {
            let dispatchGroup = DispatchGroup()
            
            for node in group {
                dispatchGroup.enter()
                let queue = DispatchQueue.global()
                
                queue.async {
                    let content = FileHandle.fileContent(path: node)
                    handleBlock(node, content)
                    dispatchGroup.leave()
                } // end queue async
            } // end for
            dispatchGroup.wait()
        } // end for
    } // end func handlesFiles
}


public struct File {
    public let fileName:String // 文件名
    public let path:String     // 文件路径
    public let content:String  // 文件内容
}
