//
//  ParseXcodeproj.swift
//  SA
//
//  Created by ming on 2019/9/2.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public enum XcodeprojTokensType {
    case codeComment
    case string
    case id
    
    case leftBrace // {
    case rightBrace // }
    case leftParenthesis // (
    case rightParenthesis // )
    case equal // =
    case semicolon // ;
    case comma // ,
}

// 一组 Token
public struct XcodeprojTokens {
    public let type: XcodeprojTokensType
    public let tokens: [Token]
}

public class ParseXcodeprojTokens {
    
    private enum State {
        case normal
        case codeCommentStart
        case codeCommentStarStart
        case stringStart
    }
    
    private var inputTokens: [Token]
    private var allTokens: [XcodeprojTokens]
    
    // 基础属性
    private var currentIndex: Int
    private var currentToken: Token
    private var currentState: State
    private var currentTokens: [Token]
    
    
    public init(input: String) {
        inputTokens = Lexer(input: input, type: .plain).allTkFast(operaters: "/*={};\",()")
        allTokens = [XcodeprojTokens]()
        
        currentIndex = 0
        currentToken = inputTokens[currentIndex]
        currentState = .normal
        currentTokens = [Token]()
    }
    
    // 解析
    public func parse() -> [XcodeprojTokens] {
        parseNext()
        while currentToken != .eof {
            parseNext()
        }
        return allTokens
    }
    
    private func parseNext() {
        
        if currentState == .normal {
            if currentToken == .id("{") {
                addTokens(type: .leftBrace)
                advanceTk()
                return
            }
            if currentToken == .id("}") {
                addTokens(type: .rightBrace)
                advanceTk()
                return
            }
            if currentToken == .id("(") {
                addTokens(type: .leftParenthesis)
                advanceTk()
                return
            }
            if currentToken == .id(")") {
                addTokens(type: .rightParenthesis)
                advanceTk()
                return
            }
            if currentToken == .id("=") {
                addTokens(type: .equal)
                advanceTk()
                return
            }
            if currentToken == .id(";") {
                addTokens(type: .semicolon)
                advanceTk()
                return
            }
            if currentToken == .id(",") {
                addTokens(type: .comma)
                advanceTk()
                return
            }
            
            // 字符串 "
            if currentToken == .id("\"") {
                currentState = .stringStart
                advanceTk()
                return
            }
            // //这样的代码注释
            if currentToken == .id("/") && peekTk() == .id("/") {
                currentState = .codeCommentStart
                advanceTk()
                advanceTk()
                return
            }
            // /*
            if currentToken == .id("/") && peekTk() == .id("*") {
                currentState = .codeCommentStarStart
                advanceTk()
                advanceTk()
                return
            }
            if currentToken == .space {
                advanceTk()
                return
            }
            if currentToken == .newLine {
                advanceTk()
                return
            }
            
            currentTokens = [Token]()
            currentTokens.append(currentToken)
            addTokens(type: .id)
            advanceTk()
            return
        }
        if currentState == .stringStart {
            if currentToken == .id("\"") {
                addTokens(type: .string)
                currentState = .normal
            } else {
                currentTokens.append(currentToken)
            }
            advanceTk()
            return
        }
        
        if currentState == .codeCommentStart {
            if currentToken == .newLine {
                addTokens(type: .codeComment)
                currentState = .normal
            } else {
                currentTokens.append(currentToken)
            }
            advanceTk()
            return
        }
        
        if currentState == .codeCommentStarStart {
            if currentToken == .id("*") && peekTk() == .id("/") {
                addTokens(type: .codeComment)
                advanceTk()
                advanceTk()
                currentState = .normal
                return
            } else {
                currentTokens.append(currentToken)
                advanceTk()
                return
            }
            
        }
        
        advanceTk()
        
    }
    
    private func addTokens(type:XcodeprojTokensType) {
        allTokens.append(XcodeprojTokens(type: type, tokens: currentTokens))
        currentTokens = [Token]()
    }
    
    // MARK: 辅助
    private func peekTk() -> Token? {
        return peekTkStep(step: 1)
    }
    
    private func peekTkStep(step: Int) -> Token? {
        let peekIndex = currentIndex + step
        guard peekIndex < inputTokens.count else {
            return nil
        }
        return inputTokens[peekIndex]
    }
    
    private func advanceTk() {
        currentIndex += 1
        guard currentIndex < inputTokens.count else {
            return
        }
        currentToken = inputTokens[currentIndex]
    }
}
