//
//  ParseOCTokens.swift
//  SA
//
//  Created by ming on 2019/11/11.
//  Copyright © 2019 ming. All rights reserved.
//

// 分词：http://clang.llvm.org/doxygen/Lexer_8cpp_source.html

import Foundation

// MARK: OCTokenNode
public struct OCTokenNode {
    public let type: OCTK
    public let line: Int
    public let value: String
}

public class ParseOCTokens {
    // MARK: 状态定义
    private enum State {
        case normal
        case commentStart
        case commentStarStart
        case stringStart
        case stringWideStart
        case stringAngleStart
        case charStart
    }
    // MARK: 属性：集合
    
    private var tokens: [Token]
    private var ocTkNodes: [OCTokenNode]
    
    // MARK: 属性：当前
    private var currentIndex: Int
    private var currentToken: Token     // 当前处理的 token
    private var currentState: State     // 当前解析状态
    private var currentTokens: [Token]  // 当前 token 集
    private var currentLine: Int        // 当前行数
    private var currentValue: String    // 当前值
    
    // 输入源码内容
    public init(input: String) {
        
        tokens = Lexer(input: input, type: .plain).allTkFast(operaters: "[](){}.&=*+-<>~!/%^|?:;,#\\\"@$'")
        ocTkNodes = [OCTokenNode]()
        
        currentIndex = 0
        currentToken = tokens[currentIndex]
        currentState = .normal
        currentTokens = [Token]()
        currentLine = 0
        currentValue = ""
    }
    
    public func parse() -> [OCTokenNode] {
        while currentToken != .eof {
            parseNext()
        }
//        for node in ocTkNodes {
//            print(node.line)
//            print(node.value)
//        }
        return ocTkNodes
    }
    
    private func addToken(type:OCTK) {
        ocTkNodes.append(OCTokenNode(type: type, line: currentLine, value: currentValue))
        currentValue = ""
        currentState = .normal
    }
    
    private func parseNext() {
        
        
        // MARK: 一般状态的处理
        if currentState == .normal {
            if currentToken == .newLine {
                currentLine += 1
                addToken(type: .eod)
                advanceTk()
                return
            }
            // MARK: 处理注释情况
            if currentToken == .id("#") && peekTk() == .id("pragma") && peekTkStep(step: 2) == .space && peekTkStep(step: 3) == .id("mark") {
                currentState = .commentStart
                advanceTk()
                advanceTk()
                advanceTk()
                return
            }
            if currentToken == .id("/") {
                if peekTk() == .id("/") {
                    currentState = .commentStart
                    advanceTk()
                    advanceTk()
                    return
                }
                if peekTk() == .id("*") {
                    currentState = .commentStarStart
                    advanceTk()
                    advanceTk()
                    return
                }
            }
            // MARK: 处理字符串
            if currentToken == .id("@") && peekTk() == .id("\"") {
                currentState = .stringWideStart
                advanceTk()
                advanceTk()
                return
            }
            if currentToken == .id("\"") {
                currentState = .stringStart
                advanceTk()
                return
            }
            if currentToken == .id("'") {
                currentState = .charStart
                advanceTk()
                return
            }
            // MARK: 空格、换行
            if currentToken == .space {
                advanceTk()
                return
            }
            
            // normal 时默认处理
            currentValue = currentToken.des()
            addToken(type: .identifier)
            advanceTk()
            return
        } // end if currentState == .normal
        
        // MARK: 注释
        if currentState == .commentStart {
            while true {
                if currentToken == .newLine || currentToken == .eof {
                    currentLine += 1
                    advanceTk()
                    break
                } else {
                    currentValue += currentToken.des()
                    advanceTk()
                }
            } // end while
            addToken(type: .comment)
            return
        }
        
        if currentState == .commentStarStart {
            
            while true {
                if currentToken.des() == "*" && peekTk()?.des() == "/" {
                    advanceTk()
                    advanceTk()
                    break
                } else {
                    if currentToken == .newLine {
                        currentLine += 1
                    }
                    currentValue += currentToken.des()
                    advanceTk()
                }
            }
            addToken(type: .comment)
            return
        }
        
        // MARK: 字符串
        if currentState == .charStart {
            while true {
                if currentToken.des() == "\\" && peekTk()?.des() == "\\" {
                    advanceTk()
                    advanceTk()
                    currentValue += "\\"
                } else if currentToken.des() == "\\" && peekTk()?.des() == "'" {
                    advanceTk()
                    advanceTk()
                    currentValue += "'"
                } else if currentToken.des() == "'" {
                    advanceTk()
                    break
                } else {
                    currentValue += currentToken.des()
                    advanceTk()
                }
            } // end while
            addToken(type: .charConstant)
            return
        }
        if currentState == .stringStart || currentState == .stringWideStart {
            while true {
                if currentToken.des() == "\\" && peekTk()?.des() == "\\" {
                    advanceTk()
                    advanceTk()
                    currentValue += "\\"
                } else if currentToken.des() == "\\" && peekTk()?.des() == "\"" {
                    advanceTk()
                    advanceTk()
                    currentValue += "\""
                } else if currentToken.des() == "\"" {
                    advanceTk()
                    break
                } else {
                    currentValue += currentToken.des()
                    advanceTk()
                }
            } // end while

            if currentState == .stringStart {
                addToken(type: .stringLiteral)
            }
            if currentState == .stringWideStart {
                addToken(type: .wideStringLiteral)
            }
            return
        }// end if currentState == .stringStart || currentState == .stringWideStart
        
        currentValue = currentToken.des()
        addToken(type: .identifier)
        advanceTk()
        return
        
    } // end func
    
    // MARK: 辅助
    private func peekTk() -> Token? {
        return peekTkStep(step: 1)
    }
    
    private func peekTkStep(step: Int) -> Token? {
        let peekIndex = currentIndex + step
        guard peekIndex < tokens.count else {
            return nil
        }
        return tokens[peekIndex]
    }
    
    private func advanceTk() {
        currentIndex += 1
        guard currentIndex < tokens.count else {
            return
        }
        currentToken = tokens[currentIndex]
    }
}
