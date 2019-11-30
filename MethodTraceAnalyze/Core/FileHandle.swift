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
    
    // 保存文件到下载目录
    public static func writeToDownload(fileName: String, content: String) {
        try! content.write(toFile: "/Users/ming/Downloads/\(fileName)", atomically: true, encoding: String.Encoding.utf8)
    }
}

public struct File {
    public let fileName:String // 文件名
    public let path:String     // 文件路径
    public let content:String  // 文件内容
}
