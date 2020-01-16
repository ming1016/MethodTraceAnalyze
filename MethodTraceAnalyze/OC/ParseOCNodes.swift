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

// OCNode 值的协议
public protocol OCNodeValueProtocol {}

// OC 语法树节点
public struct OCNode {
    public var type: OCNodeType
    public var subNodes: [OCNode]
    public var identifier: String   // 标识
    public var lineRange: (Int,Int) // 行范围
    public var source: String       // 对应代码
    public var value: OCNodeValueProtocol // 满足协议的值
}

public struct OCNodeDefaultValue: OCNodeValueProtocol {
    public var defaultValue: String
    init() {
        defaultValue = ""
    }
}

// 方法
public struct OCNodeMethod: OCNodeValueProtocol {
    public var belongClass: String
    public var methodName: String    // 方法名
    public var returnType: String    // 返回类型
    public var paramTypes: [String]  // 所有参数类型
    public var tokenNodes: [OCTokenNode]
}

// 类
public struct OCNodeClass: OCNodeValueProtocol {
    public var className: String
    public var baseClass: String
    public var hMethod: [String] // 头文件方法
    public var mMethod: [String] // 实现文件的方法
    public var baseClasses: [String]
    public var properties: [OCProperty] // 属性
}

// 属性
public struct OCProperty {
    public var type: String
}

public class ParseOCNodes {
    
    private var linesContent: [String]
    private var tokenNodes: [OCTokenNode]
    private var inputFilePath: String
    
    // MARK: 初始化
    public init(input: String, filePath: String) {
        inputFilePath = filePath
        let formatInput = input.replacingOccurrences(of: "\r\n", with: "\n")
        linesContent = formatInput.components(separatedBy: .newlines)
        // 统计文件对应行数
        OCStatistics.fileLine(filePath: filePath, lines: linesContent.count)
        tokenNodes = ParseOCTokens(input: formatInput).parse()
    }
    
    public func parse() -> OCNode {
        var pNode = defaultOCNode()
        pNode.type = .root
        let rootNode = parseNode(parentNode: pNode, nodes: tokenNodes)
        return rootNode
    }
    
    // MARK: 递归解析状态
    private enum RState {
        case normal
        case eod                   // 换行
        
        // 方法
        case methodStart           // 方法开始
        case methodReturnStart     // 方法返回类型开始
        case methodReturnEnd       // 方法返回类型结束
        case methodNameEnd         // 方法名结束
        case methodParamStart      // 方法参数开始
        case methodContentStart    // 方法内容开始
        case methodParamTypeStart  // 方法参数类型开始
        case methodParamTypeEnd    // 方法参数类型结束
        case methodParamEnd        // 方法参数结束
        case methodParamNameEnd    // 方法参数名结束
        case methodShouldEnd       // 针对方法定义的情况 比如 interface 里的 - (void)foo;
        
        // 方法调用 [[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        case methodCallStart       // 方法调用开始
        
        // @
        case at                    // @
        case atImplementation      // @implementation
        case atProtocol            // @protocol
        case atInterface           // @interface
        case atInterfaceName       // @interface name
        case atInterfaceParent     // @interface name : base
        case atInterfaceContent    // @interface 里内容
        case atProperty            // @property
        case atPropertyDesStart    // @property(
        case atPropertyDesEnd      // @property(nonatomic, weak, readonly)
        case atPropertyTypeEnd     // @property(nonatomic, weak, readonly) NSString
        
        // #
        case numberSign            // #
        
        case normalBlock           // oc方法外部的 block {}，用于 c方法
    }
    
    // MARK: 解析
    public func parseNode(parentNode:OCNode, nodes:[OCTokenNode]) -> OCNode {
        var pNode = parentNode
        var currentState: RState = .normal
        //var currentLevel = 0
        //var recusiveNodeArr = [OCTokenNode]()
        var currentStartLine = 0
        var currentPairCount = 0
        
        // interface
        var currentInterfaceName = ""
        var currentInterfaceParent = ""
        
        // property
        var currentProperties = [OCProperty]()
        
        // method
        var currentMethodName = ""
        var currentClassName = ""
        var currentMethodReturnType = ""
        var currentMethodParamTypes = [String]()
        
        // method content
        var currentMethodTokenNodes = [OCTokenNode]()
        
        for tkNode in nodes {
            // MARK:方法
            if currentState == .methodShouldEnd {
                if tkNode.value == "{" {
                    currentState = .methodContentStart
                    currentPairCount += 1
                    continue
                } else if (tkNode.type == .eod || tkNode.value == ";") {
                    // 如果文件是头文件，方法定义处理不一样
                    if inputFilePath.hasSuffix(".h") {
                        currentState = .normal
                    }
                } else {
                    currentState = .normal
                }
                continue
            }
            
            if currentState == .methodContentStart {
                //
                currentMethodTokenNodes.append(tkNode)
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
                        let identifier = "[\(currentClassName)]\(currentMethodName)"
                        let methodValue = OCNodeMethod(belongClass: currentClassName, methodName: currentMethodName, returnType: currentMethodReturnType, paramTypes: currentMethodParamTypes, tokenNodes: currentMethodTokenNodes)
                        pNode.subNodes.append(OCNode(type: .method, subNodes: [OCNode](), identifier:identifier, lineRange: (currentStartLine, tkNode.line), source: sourceContent, value: methodValue))
                        // 重置 current
                        currentState = .normal
                        currentMethodName = ""
                        currentMethodReturnType = ""
                        currentMethodParamTypes = [String]()
                        currentMethodTokenNodes = [OCTokenNode]()
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
                } else if tkNode.type == .eod {
                    continue
                } else if tkNode.value == ";" {
                    currentState = .methodShouldEnd
                    continue
                }else {
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
            
            // -(Bool)foo:(Bool
            if currentState == .methodParamTypeStart {
                currentMethodParamTypes.append(tkNode.value)
                currentState = .methodParamStart
                continue
            }
            
            if currentState == .methodParamStart {
                // -(Bool)foo:(Bool)
                if tkNode.value == "(" {
                    currentPairCount += 1
                    if currentPairCount == 1 {
                        currentState = .methodParamTypeStart
                    }
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
                if tkNode.type == .eod {
                    continue
                }
                if tkNode.value == ";" {
                    currentState = .methodShouldEnd
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
            
            // -(
            if currentState == .methodReturnStart {
                currentMethodReturnType = tkNode.value
                currentState = .methodStart
                continue
            }
            
            if currentState == .methodStart {
                if tkNode.value == "(" {
                    currentPairCount += 1
                    if currentPairCount == 1 {
                        currentState = .methodReturnStart
                    }
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
            
            // MARK: 不同@状态的
            // @implementation
            if currentState == .atImplementation {
                currentClassName = tkNode.value
                currentState = .normal
                continue
            }
            
            // @protocol || @interface
            if currentState == .atInterface {
                currentInterfaceName = tkNode.value
                currentState = .atInterfaceName
                continue
            }
            
            if currentState == .atInterfaceName {
                // @interface name : base
                currentState = .atInterfaceContent
                if tkNode.value == ":" {
                    currentState = .atInterfaceParent
                }
                
                continue
            }
            
            if currentState == .atInterfaceParent {
                currentInterfaceParent = tkNode.value
                currentState = .atInterfaceContent
                continue
            }
            
            
            if currentState == .atProtocol || currentState == .atInterfaceContent {
                
                if tkNode.value == "@" {
                    currentState = .at
                }
                continue
            }
            
            // @property 属性
            
            // @property(nonatomic, weak, readonly) NSString
            if currentState == .atPropertyTypeEnd {
                if tkNode.value == ";" {
                    currentState = .normal
                }
                continue
            }
            
            // @property(nonatomic, weak, readonly)
            if currentState == .atPropertyDesEnd {
                currentProperties.append(OCProperty(type: tkNode.value))
                currentState = .atPropertyTypeEnd
                continue
            }
            
            // @property
            if currentState == .atProperty {
                
                if tkNode.value == ")" {
                    currentState = .atPropertyDesEnd
                }
                
                continue
            }
            
            // MARK:@符号的处理
            if currentState == .at {
                
                if tkNode.value == "property" {
                    currentState = .atProperty
                    continue
                }
                
                if tkNode.value == "implementation" {
                    currentState = .atImplementation
                    continue
                }
                
                if tkNode.value == "protocol" {
                    currentState = .atProtocol
                    continue
                }
                
                if tkNode.value == "interface" {
                    currentState = .atInterface
                    continue
                }
                
                if tkNode.value == "end" {
                    if currentInterfaceName.count > 0 {
                        // 当有基类时，需要做记录
                        if currentInterfaceParent.count > 0 {
                            OCStatistics.classAndBaseClass(aClass: currentInterfaceName, baseClass: currentInterfaceParent)
                        }
                        
                        
                        let nodeClass = OCNodeClass(className: currentInterfaceName, baseClass: currentInterfaceParent, hMethod: [String](), mMethod: [String](), baseClasses: [String](), properties: currentProperties)
                        pNode.subNodes.append(OCNode(type: .class, subNodes: [OCNode](), identifier:"\(currentInterfaceName)", lineRange: (0, 0), source: "", value: nodeClass))
                        
                        currentInterfaceName = ""
                        currentInterfaceParent = ""
                        currentProperties = [OCProperty]()
                    }
                    continue
                }
                
                // 其它情况比如 @synthesize 的处理
                currentState = .normal
                continue
            }
            
            // #
            if currentState == .numberSign {
                if tkNode.type == .eod {
                    currentState = .normal
                }
                continue
            }
            
            // oc方法外部的 block {}
            if currentState == .normalBlock {
                currentMethodTokenNodes.append(tkNode)
                if tkNode.value == "{" {
                    currentPairCount += 1
                    continue
                }
                if tkNode.value == "}" {
                    currentPairCount -= 1
                    if currentPairCount == 0 {
                        currentState = .normal
                        
                        // 当作匿名方法记录
                        // 获取 block 代码
                        var sourceContent = ""
                        for i in currentStartLine..<tkNode.line + 1 {
                            if i < linesContent.count {
                                sourceContent += "\(linesContent[i])\n"
                            }
                        }
                        
                        // 拼装
                        let currentTime = Date().timeIntervalSince1970
                        let identifier = "identifier\(currentTime)"
                        let methodValue = OCNodeMethod(belongClass: "class\(currentTime)", methodName: "method\(currentTime)", returnType: currentMethodReturnType, paramTypes: currentMethodParamTypes, tokenNodes: currentMethodTokenNodes)
                        pNode.subNodes.append(OCNode(type: .method, subNodes: [OCNode](), identifier: identifier, lineRange: (currentStartLine, tkNode.line), source: sourceContent, value: methodValue))
                        // 重置
                        currentState = .normal
                        currentMethodName = ""
                        currentMethodReturnType = ""
                        currentMethodParamTypes = [String]()
                        currentMethodTokenNodes = [OCTokenNode]()
                        currentStartLine = 0
                        currentPairCount = 0
                        
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
                // 外部 block 方法
                if tkNode.value == "{" {
                    currentPairCount += 1
                    currentState = .normalBlock
                    currentStartLine = tkNode.line
                    continue
                }
                if tkNode.value == "#" {
                    currentState = .numberSign
                    continue
                }
                
                continue
            }
            
            
        }
        
        return pNode
    }
    
    private func defaultOCNode() -> OCNode {
        return OCNode(type: .default, subNodes: [OCNode](), identifier: "", lineRange: (0, 0), source: "", value: OCNodeDefaultValue())
    }
    
}
