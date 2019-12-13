//
//  ParseOCNodes.swift
//  SA
//
//  Created by ming on 2019/11/21.
//  Copyright © 2019 ming. All rights reserved.
//

// http://clang.llvm.org/docs/IntroductionToTheClangAST.html
// http://clang.llvm.org/doxygen/classclang_1_1Parser.html

import Foundation

// 节点类型
public enum OCNodeType {
    case `default`
    case root
    case `import`
    case `class`
    case method
}

// OC 语法树节点
public struct OCNode {
    public var type: OCNodeType
    public var subNodes: [OCNode]
    public var identifier: String   // 标识
    public var lineRange: (Int,Int) // 行范围
    public var source: String       // 对应代码
}

public class ParseOCNodes {
    
    private var linesContent: [String]
    private var tokenNodes: [OCTokenNode]
    
    // MARK: 初始化
    public init(input: String) {
        linesContent = input.components(separatedBy: .newlines)
        tokenNodes = ParseOCTokens(input: input).parse()
    }
    
    public func parse() -> OCNode {
        var pNode = defaultOCNode()
        pNode.type = .root
        let rootNode = recusiveParseNode(parentNode: pNode, nodes: tokenNodes)
        return rootNode
    }
    
    // MARK: 递归解析状态
    private enum RState {
        case normal
        case eod                   // 换行
        case methodStart           // 方法开始
        case methodReturnEnd       // 方法返回类型结束
        case methodNameEnd         // 方法名结束
        case methodParamStart      // 方法参数开始
        case methodContentStart    // 方法内容开始
        case methodParamTypeStart  // 方法参数类型开始
        case methodParamTypeEnd    // 方法参数类型结束
        case methodParamEnd        // 方法参数结束
        case methodParamNameEnd    // 方法参数名结束
        
        case at                    // @
        case atImplementation      // @implementation
        case atProtocol            // @protocol
        case atInterface           // @interface
        
        case normalBlock           // oc方法外部的 block {}，用于 c方法
    }
    
    // MARK: 递归解析
    public func recusiveParseNode(parentNode:OCNode, nodes:[OCTokenNode]) -> OCNode {
        var pNode = parentNode
        var currentState: RState = .normal
        //var currentLevel = 0
        //var recusiveNodeArr = [OCTokenNode]()
        var currentStartLine = 0
        var currentPairCount = 0
        
        // method
        var currentMethodName = ""
        var currentClassName = ""
        
        for tkNode in nodes {
            
            if currentState == .methodContentStart {
                //
                if tkNode.value == "{" {
                    currentPairCount += 1
                    continue
                }
                if tkNode.value == "}" {
                    currentPairCount -= 1
                    if currentPairCount == 0 {
                        // method 的内容结束
                        // 获取 method 代码
                        var sourceContent = ""
                        for i in currentStartLine..<tkNode.line + 1 {
                            if i < linesContent.count {
                                sourceContent += "\(linesContent[i])\n"
                            }
                        }
                        pNode.subNodes.append(OCNode(type: .method, subNodes: [OCNode](), identifier:"[\(currentClassName)]\(currentMethodName)", lineRange: (currentStartLine, tkNode.line), source: sourceContent))
                        // 重置 current
                        currentState = .normal
                        currentMethodName = ""
                        currentStartLine = 0
                        currentPairCount = 0
                    }
                    continue
                }
                continue
            }
            
            if currentState == .methodParamEnd {
                if tkNode.value == "{" {
                    currentState = .methodContentStart
                    currentPairCount += 1
                    continue
                } else if (tkNode.type == .eod || tkNode.value == ";") {
                    continue
                } else {
                    // -(Bool)foo:(Bool)p p2:(Bool)p2
                    currentMethodName += tkNode.value
                    currentState = .methodParamStart // 可以重用第一个参数状态
                    continue
                }
                
            }
            
            
            if currentState == .methodParamTypeEnd {
                // -(Bool)foo:(Bool)p
                currentMethodName += ":"
                currentState = .methodParamEnd
                continue
            }
            
            if currentState == .methodParamStart {
                // -(Bool)foo:(Bool)
                if tkNode.value == "(" {
                    currentPairCount += 1
                    continue
                }
                if tkNode.value == ")" {
                    currentPairCount -= 1
                    if currentPairCount == 0 {
                        currentState = .methodParamTypeEnd
                        continue
                    }
                }
                continue
            }
            
            if currentState == .methodNameEnd {
                // -(Bool)foo:
                if tkNode.value == ":" {
                    currentState = .methodParamStart
                    continue
                }
                // -(Bool)foo {
                if tkNode.value == "{" {
                    currentState = .methodContentStart
                    currentPairCount += 1
                    continue
                }
                if tkNode.type == .eod || tkNode.value == ";" {
                    continue
                }
                continue
            }
            
            // -(Bool)foo
            if currentState == .methodReturnEnd {
                if tkNode.type == .identifier {
                    currentMethodName = tkNode.value
                    currentState = .methodNameEnd
                    continue
                }
                continue
            }
            
            if currentState == .methodStart {
                if tkNode.value == "(" {
                    currentPairCount += 1
                    continue
                }
                if tkNode.value == ")" {
                    currentPairCount -= 1
                    if currentPairCount == 0 {
                        currentState = .methodReturnEnd
                    }
                    continue
                }
                continue
            }
            
            // @implementation
            if currentState == .atImplementation {
                currentClassName = tkNode.value
                currentState = .normal
                continue
            }
            
            // @protocol || @interface
            if currentState == .atProtocol || currentState == .atInterface {
                if tkNode.value == "@" {
                    currentState = .at
                }
                continue
            }
            
            // @符号的处理
            if currentState == .at {
                if tkNode.value == "implementation" {
                    currentState = .atImplementation
                    continue
                } else if tkNode.value == "protocol" {
                    currentState = .atProtocol
                    continue
                } else if tkNode.value == "interface" {
                    currentState = .atInterface
                    continue
                } else {
                    // 其它情况比如 @synthesize 的处理
                    currentState = .normal
                }
                continue
            }
            
            // oc方法外部的 block {}
            if currentState == .normalBlock {
                if tkNode.value == "{" {
                    currentPairCount += 1
                    continue
                }
                if tkNode.value == "}" {
                    currentPairCount -= 1
                    if currentPairCount == 0 {
                        currentState = .normal
                        continue
                    }
                }
                continue
            }
            
            // normal 情况的处理
            if currentState == .normal || currentState == .eod {
                if tkNode.type == .identifier && (tkNode.value == "-" || tkNode.value == "+") && currentState == .eod {
                    currentState = .methodStart
                    currentStartLine = tkNode.line
                    continue
                }
                if tkNode.value == "@" {
                    currentState = .at
                    continue
                }
                if tkNode.type == .eod {
                    currentState = .eod
                    continue
                }
                if tkNode.value == "{" {
                    currentPairCount += 1
                    currentState = .normalBlock
                    continue
                }
                
                continue
            }
            
            
        }
        
        return pNode
    }
    
    private func defaultOCNode() -> OCNode {
        return OCNode(type: .default, subNodes: [OCNode](), identifier: "", lineRange: (0, 0), source: "")
    }
    
}
