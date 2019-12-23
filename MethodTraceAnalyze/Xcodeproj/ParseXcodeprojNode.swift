//
//  ParseXcodeprojNode.swift
//  SA
//
//  Created by ming on 2019/9/4.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public enum XcodeprojNodeType {
    case normal
    case root
    
    case dicStart // {
    case dicKey
    case dicValue
    case dicEnd   // }
    
    case arrStart // (
    case arrValue
    case arrEnd   // )
}

public struct XcodeprojNode {
    public let type: XcodeprojNodeType
    public let value: String
    public let codeComment: String
    public var subNodes: [XcodeprojNode]
}

public class ParseXcodeprojNode {
    private var allTokens: [XcodeprojTokens]
    private var allNodes: [XcodeprojNode]
    
    // 第一轮用
    private enum PState {
        case normal
        case startDicKey
        case startDicValue
        case startArrValue
    }
    
    
    public init(input: String) {
        allTokens = ParseXcodeprojTokens(input: input).parse()
        allNodes = [XcodeprojNode]()
    }
    
    public static func des(nodes: [XcodeprojNode]) {
        for node in nodes {
            print("type:\(node.type)")
            print("value:\(node.value)")
            print("codeComment:\(node.codeComment)")
            print(" ")
        }
    }
    
    // 第一轮：生成平铺 nodes
    public func parse() -> [XcodeprojNode] {
        var currentNodeType:XcodeprojNodeType = .normal
        var currentValue = ""
        var currentComment = ""
        var currentPState:PState = .normal
        
        // 方法内的方法能够共用方法内定义的变量
        func appendNode() {
            allNodes.append(XcodeprojNode(type: currentNodeType, value: currentValue, codeComment: currentComment, subNodes: [XcodeprojNode]()))
            currentNodeType = .normal
            currentValue = ""
            currentComment = ""
        }
        
        for tokens in allTokens {
            
            if currentPState == .normal {
                if tokens.type == .leftBrace {
                    currentPState = .startDicKey
                    currentNodeType = .dicStart
                    appendNode()
                    continue
                }
                if tokens.type == .semicolon {
                    currentPState = .startDicKey
                    continue
                }
                if tokens.type == .rightBrace {
                    currentNodeType = .dicEnd
                    appendNode()
                    continue
                }
            } // end state normal
            
            if currentPState == .startDicKey {
                if tokens.type == .id {
                    currentNodeType = .dicKey
                    currentValue.append(tokens.tokens[0].des())
                    continue
                }
                if tokens.type == .codeComment {
                    // 不能排 id 类型后
                    if currentNodeType == .dicKey {
                        currentComment.append(tokensToString(tokens: tokens.tokens))
                    }
                    continue
                }
                if tokens.type == .equal {
                    appendNode()
                    currentPState = .startDicValue
                    continue
                }
                if tokens.type == .leftBrace {
                    currentNodeType = .dicStart
                    appendNode()
                    continue
                }
                if tokens.type == .rightBrace {
                    currentNodeType = .dicEnd
                    appendNode()
                    continue
                }
                
            } // end start dic key
            
            
            // { key = value
            if currentPState == .startDicValue {
                
                if tokens.type == .id {
                    currentNodeType = .dicValue
                    currentValue.append(tokens.tokens[0].des())
                    continue
                }
                if tokens.type == .codeComment {
                    currentComment.append(tokensToString(tokens: tokens.tokens))
                    continue
                }
                if tokens.type == .string {
                    currentNodeType = .dicValue
                    if tokens.tokens.count > 0 {
                        currentValue.append("\(tokensToString(tokens: tokens.tokens))")
                    }
                    continue
                }
                if tokens.type == .semicolon {
                    if currentNodeType == .dicValue {
                        appendNode()
                    }
                    currentPState = .startDicKey
                    continue
                }
                
                // 字典情况
                if tokens.type == .leftBrace {
                    currentNodeType = .dicStart
                    currentPState = .startDicKey
                    appendNode()
                    continue
                }
                if tokens.type == .rightBrace {
                    currentNodeType = .dicEnd
                    appendNode()
                    continue
                }
                
                
                // 数组情况
                // (
                if tokens.type == .leftParenthesis {
                    currentNodeType = .arrStart
                    appendNode()
                    currentPState = .startArrValue
                    continue
                }
                
            } // end dic value
            
            if currentPState == .startArrValue {
                if tokens.type == .id {
                    currentNodeType = .arrValue
                    currentValue.append(tokens.tokens[0].des())
                    continue
                }
                if tokens.type == .string {
                    currentNodeType = .arrValue
                    currentValue.append("\(tokensToString(tokens: tokens.tokens))")
                    continue
                }
                if tokens.type == .codeComment {
                    currentComment.append(tokensToString(tokens: tokens.tokens))
                    continue
                }
                if tokens.type == .comma {
                    appendNode()
                    continue
                }
                if tokens.type == .rightParenthesis {
                    currentNodeType = .arrEnd
                    appendNode()
                    currentPState = .normal
                    continue
                }
            } // end arr value
            
        } // end for
        
        return allNodes
    }
    
    // Mark: 私有方法
    
    
    private func tokensToString(tokens:[Token]) -> String {
        var reStr = ""
        for token in tokens {
            reStr.append(token.des())
        }
        return reStr
    }
    
    
}
