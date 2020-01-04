//
//  ModifyOCContent.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/1/3.
//  Copyright © 2020 ming. All rights reserved.
//

import Foundation

public class ModifyOCContent {
    private var filePath: String
    private var lineContent: [String]
    private var tokenNodes: [OCTokenNode]
    
    public init(input: String, inputFilePath: String) {
        filePath = inputFilePath
        let formatInput = input.replacingOccurrences(of: "\r\n", with: "\n")
        lineContent = formatInput.components(separatedBy: .newlines)
        tokenNodes = ParseOCTokens(input: formatInput).parse()
    }
    
    // 注释掉无用的类
    public func commentedOutUnUsedClass(unUsedClasses:Set<String>) {
        enum State {
            case normal
            case at
            case atClass // 包含 interface、implementation、protocol
            case atInterface
            case atImplementation
            case atProtocol
        }
        
        var currentState:State = .normal
        var currentLineStart = 0
        
        for aNode in tokenNodes {
            
            
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
        
    } // end func
} // end class
