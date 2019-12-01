//
//  ParseXcodeprojSource.swift
//  SA
//
//  Created by ming on 2019/9/19.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public struct XcodeprojSourceNode {
    let fatherValue: String
    let value: String
    let name: String
    let type: String
}

// MARK: Main
public class ParseXcodeprojSource {
    var proj: Xcodeproj
    var projPath: String
    
    
    public init(input: String) {
        let projectContent = FileHandle.fileContent(path: input)
        proj = ParseXcodeprojSection(input: projectContent).parse()
        projPath = ""
        let splitPathBySlashArr = input.components(separatedBy: "/")
        for v in splitPathBySlashArr {
            if v.hasSuffix("xcodeproj") {
                break
            }
            projPath.append("\(v)/")
        }
    }
    
    public func parseAllFiles() -> [String] {
        
        var nodes = [XcodeprojSourceNode]()
        
        // 第一次找出所有文件和文件夹
        for (k,v) in proj.pbxGroup {
            guard v.children.count > 0 else {
                continue
            }
            
            for child in v.children {
                // 如果满足条件表示是目录
                if proj.pbxGroup.keys.contains(child.value) {
//                    guard let group = proj.pbxGroup[child.value] else {
//                        continue
//                    }
//                    nodes.append(XcodeprojSourceNode(fatherValue: k, value: child.value, name: group.path, type: "folder"))
                    continue
                }
                // 满足条件是文件
                if proj.pbxFileReference.keys.contains(child.value) {
                    guard let fileRefer = proj.pbxFileReference[child.value] else {
                        continue
                    }
                
                    nodes.append(XcodeprojSourceNode(fatherValue: k, value: child.value, name: fileRefer.path, type: fileRefer.lastKnownFileType))
                }
            } // end for children
            
        } // end for group
        
        // 通过遍历，然后递归每个 node 的 fatherValue 获得完整路径
        var fullPaths = [String]()
        // 白名单
        let suffixWhitelist = [".m",".mm"]
        for node in nodes {
            let path = recusiveFatherPaths(node: node, path: node.name)
            // 处理 path 数据
            let pathArr = path.components(separatedBy: "/")
            var isAppend = false
            
            // 处理白名单
            for sw in suffixWhitelist {
                if path.hasSuffix(sw) {
                    isAppend = true
                }
            }
            // 处理无效数据
            for v in pathArr {
                if v.hasPrefix("\"") {
                    isAppend = false
                }
            }
            if isAppend {
                // 需要处理 ../ 往上级探的情况
                let projPathArr = projPath.components(separatedBy: "/")
                
                let pathArr = path.components(separatedBy: "/")
                var stepPath = ""
                var stepCount = 0
                var hasDoubleDot = false
                for pathItem in pathArr {
                    if pathItem == ".." {
                        stepCount += 1
                        hasDoubleDot = true
                        continue
                    }
                    if pathItem == "" {
                        continue
                    }
                    stepPath.append("\(pathItem)/")
                }
                // 清理最后的/符号
                if stepPath.hasSuffix("/") {
                    stepPath.removeLast()
                }
                
                // 根据 ../ 的数量往上级探
                var projNewPath = ""
                if hasDoubleDot {
                    let cutCount = projPathArr.count - stepCount - 1
                    var i = 0
                    for pjItem in projPathArr {
                        if i == cutCount {
                            break
                        }
                        projNewPath.append("\(pjItem)/")
                        i += 1
                    }
                } else {
                    projNewPath = projPath
                }
                // 拼接
                let combinePath = projNewPath + stepPath
                
                fullPaths.append(combinePath)
            } // end if
            
        }
        //print(fullPaths)
        return fullPaths
    } // end func
    
    // MARK:私有方法
    private func recusiveFatherPaths(node: XcodeprojSourceNode, path: String) -> String {
        let rootProj = proj.rootObject
        // 判断是否到了根上
        guard let pbxproj = proj.pbxProject[rootProj.value] else {
            return path
        }
        
        guard node.fatherValue != pbxproj.mainGroup else {
            return path
        }
        
        guard let fatherGroup = proj.pbxGroup[node.fatherValue] else {
            return path
        }
        
        // 拼路径
        var jointPath = path
        jointPath = "\(fatherGroup.path)/\(path)"
        
        // 查找更上一级的路径
        for (k,v) in proj.pbxGroup {
            for child in v.children {
                if child.value == node.fatherValue {
                    let rNode = XcodeprojSourceNode(fatherValue: k, value: child.value, name: "", type: "Folder")
                    return recusiveFatherPaths(node: rNode, path: jointPath)
                } // end if
            } // end for children
        } // end for group
        
        return path
        
    }
    
}
