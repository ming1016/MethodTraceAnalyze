//
//  ParseJSON.swift
//  SA
//
//  Created by ming on 2019/10/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public enum JSONTokenType {
    case startDic   // {
    case endDic     // }
    case startArray // [
    case endArray   // ]
    case key        // key
    case value      // value
}

public struct JSONToken {
    public let type: JSONTokenType
    public let value: String
}

public class ParseJSONTokens {
    
    private enum State {
        case normal
        case keyStart
        case valueStart
    }
    
    private var tokens:[Token]
    private var allJSONTokens: [JSONToken]
    
    private var currentIndex: Int
    private var currentToken: Token
    private var currentState: State
    private var currentValue: String
    
    public init(input: String) {
        tokens = Lexer(input: input, type: .plain).allTkFastWithoutNewLineAndWhitespace(operaters: "{}[]\":,")
        
        allJSONTokens = [JSONToken]()
        
        currentIndex = 0
        currentToken = tokens[currentIndex]
        currentState = .normal
        currentValue = ""
    }
    
    
    // 解析
    public func parse() -> [JSONToken] {
        parseNext()
        while currentToken != .eof {
            parseNext()
        }
        return allJSONTokens
    }
    
    private func parseNext() {
        // key
        if currentState == .keyStart {
            if currentToken == .id("\"") {
                addToken(type: .key)
                currentState = .normal
            } else {
                currentValue.append(currentToken.des())
            }
            advanceTk()
            return
        } // end if currentState == .keyStart
        
        // value
        if currentState == .valueStart {
            if currentToken == .id("\"") {
                addToken(type: .value)
                currentState = .normal
            } else {
                currentValue.append(currentToken.des())
            }
            advanceTk()
            return
        } // end if currentState == .valueStart
        
        if currentState == .normal {
            // 当遇到:符号后面是" value 开始
            if currentToken == .id(":") {
                if peekTk() == .id("\"") {
                    currentState = .valueStart
                    advanceTk()
                    advanceTk()
                    return
                }
                
                if peekTk() == .id("{") || peekTk() == .id("[") {
                    advanceTk()
                    return
                }
                
                // 如果:后不是接{或者[，一般就是非字符串的数字，可以直接添加到 token 里
                advanceTk()
                currentValue.append(currentToken.des())
                addToken(type: .value)
                advanceTk()
                return
                
                
            }
            // 当遇到,符号 key 开始
            if currentToken == .id(",") && peekTk() == .id("\"") {
                currentState = .keyStart
                advanceTk()
                advanceTk()
                return
            }
            if currentToken == .id(",") {
                advanceTk()
                return
            }
            if currentToken == .id("{") {
                addToken(type: .startDic)
                if peekTk() == .id("\"") {
                    // 当遇到 { 符号 key 开始
                    currentState = .keyStart
                    advanceTk()
                }
                advanceTk()
                return
            }
            if currentToken == .id("}") {
                addToken(type: .endDic)
                advanceTk()
                return
            }
            if currentToken == .id("[") {
                addToken(type: .startArray)
                if peekTk() == .id("\"") {
                    // 遇到 [ key
                    currentState = .valueStart
                    advanceTk()
                }
                advanceTk()
                return
            }
            if currentToken == .id("]") {
                addToken(type: .endArray)
                advanceTk()
                return
            }
            // 默认作为值处理
            if currentValue.count == 0 {
                currentValue = currentToken.des()
            }
            addToken(type: .value)
            advanceTk()
            return
            
        } // end if currentState == .normal
        
        advanceTk()
        
    }
    
    private func addToken(type: JSONTokenType) {
        allJSONTokens.append(JSONToken(type:type,value:currentValue))
        currentValue = ""
    }
    
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


