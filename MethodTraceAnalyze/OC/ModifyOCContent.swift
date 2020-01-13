//
//  ModifyOCContent.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/1/3.
//  Copyright © 2020 ming. All rights reserved.
//

import Foundation

public struct commentedOutUnUsedClassStruct {
    var filePath: String
    var lineStart: Int
    var lineEnd: Int
    var lineCount: Int          // 有多少行
    var source: String          // 代码
    var className: String       // 类名
    var classIdentifier: String // 编号，
}

public class ModifyOCContent {
    private var filePath: String
    private var lineContent: [String]
    private var tokenNodes: [OCTokenNode]
    
    public init(inputFilePath: String) {
        filePath = inputFilePath
        let content = FileHandle.fileContent(path: inputFilePath)
        let formatInput = content.replacingOccurrences(of: "\r\n", with: "\n")
        lineContent = formatInput.components(separatedBy: .newlines)
        tokenNodes = ParseOCTokens(input: formatInput).parse()
    }
    
    // 注释掉无用的类
    public func commentedOutUnUsedClass(unUsedClasses:Set<String>) -> [commentedOutUnUsedClassStruct] {
        enum State:String {
            case normal
            case at
            case atInterface
            case atImplementation
            case atProtocol
            
            case atContent // 在 @ + 名字后到 @end 之间的内容
        }
        
        var reClasses = [commentedOutUnUsedClassStruct]()
        
        var currentState:State = .normal
        var currentLineStart = 0
        var currentClassName = ""
        var currentClassIdentifier = ""
        
        var index = 0
        for aNode in tokenNodes {
            index += 1
            if currentState == .atContent {
                if index < tokenNodes.count {
                    let nextNode = tokenNodes[index]
                    if "\(aNode.value)\(nextNode.value)" == "@end" {
                        //
                        var sourceContent = ""
                        for i in currentLineStart..<aNode.line + 1 {
                            if i < lineContent.count {
                                sourceContent += "\(lineContent[i])\n"
                            }
                        }
                        
                        if unUsedClasses.contains(currentClassName) {
                            reClasses.append(commentedOutUnUsedClassStruct(filePath: filePath, lineStart: currentLineStart, lineEnd: aNode.line, lineCount: aNode.line - currentLineStart, source: sourceContent, className: currentClassName, classIdentifier: currentClassIdentifier))
                        }
                        
                        // 重置
                        currentState = .normal
                        currentLineStart = 0
                        currentClassName = ""
                        currentClassIdentifier = ""
                    }
                }
                
                continue
            }
            
            if currentState == .atInterface || currentState == .atImplementation || currentState == .atProtocol {
                currentLineStart = aNode.line
                currentClassName = aNode.value
                currentClassIdentifier = "\(aNode.value)-\(currentState.rawValue)-\(nowTimeInterval())"
                currentState = .atContent
                continue
            }
            
            if currentState == .at {
                if aNode.value == "interface" {
                    currentState = .atInterface
                } else if aNode.value == "implementation" {
                    currentState = .atImplementation
                } else if aNode.value == "protocol" {
                    currentState = .atProtocol
                } else if aNode.value == "end" {
                    
                }
                continue
            }
            
            if currentState == .normal {
                if aNode.value == "@" {
                    currentState = .at
                }
                continue
            }
        }
        
        return reClasses
        
    } // end func
} // end class
