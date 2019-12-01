//
//  ParseXcodeprojTreeNode.swift
//  SA
//
//  Created by ming on 2019/9/6.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

// TODO: 协议支持
public enum XcodeprojTreeNodeType {
    case value
    case keyValue
    case array
}

public struct XcodeprojTreeNodeKey {
    public var name: String
    public var comment: String
}

public struct XcodeprojTreeNodeArrayValue {
    public var name: String
    public var comment: String
}

public struct XcodeprojTreeNodeKv {
    public var key: XcodeprojTreeNodeKey
    public var value: XcodeprojTreeNode
}

public struct XcodeprojTreeNode {
    public var type: XcodeprojTreeNodeType
    public var value: String
    public var comment: String
    public var kvs: [XcodeprojTreeNodeKv]
    public var arr: [XcodeprojTreeNodeArrayValue]
}

public class ParseXcodeprojTreeNode {
    private var allNodes: [XcodeprojNode]
    
    // 第二轮递归
    private enum RState {
        case normal
        case startDicRecusive
        case startArr
        
    }
    
    public init(input: String) {
        allNodes = ParseXcodeprojNode(input: input).parse()
    }
    
    public func parse() -> XcodeprojTreeNode {
        //ParseXcodeprojNode.des(nodes: nodes)
        let rootNode = recusiveParseNodes(parentNode: defaultXcodeprojTreeNode(), nodes: allNodes)
        
        return rootNode
    }
    
    // 获取一个默认的 treenode
    private func defaultXcodeprojTreeNode() -> XcodeprojTreeNode {
        return XcodeprojTreeNode(type: .keyValue, value: "", comment: "", kvs: [XcodeprojTreeNodeKv](), arr: [XcodeprojTreeNodeArrayValue]())
    }
    
    
    public func recusiveParseNodes(parentNode: XcodeprojTreeNode, nodes: [XcodeprojNode]) -> XcodeprojTreeNode {
        var pNode = parentNode
        var currentState:RState = .normal
        var currentLevel = 0
        
        var recusiveNodeArr = [XcodeprojNode]()
        
        var currentTreeNodeType:XcodeprojTreeNodeType = .value
        var currentKey = XcodeprojTreeNodeKey(name: "", comment: "")
        var currentValue = defaultXcodeprojTreeNode()
        var currentArr = [XcodeprojTreeNodeArrayValue]()
        
        // 重置 key value 的解析
        func resetKvParseCurrent() {
            currentTreeNodeType = .value
            currentKey = XcodeprojTreeNodeKey(name: "", comment: "")
            currentValue = defaultXcodeprojTreeNode()
        }
        
        
        // 添加一个 key value 的 node
        func appendKvNode() {
            let kv = XcodeprojTreeNodeKv(key: currentKey, value: currentValue)
            pNode.kvs.append(kv)
            resetKvParseCurrent()
        }
        
        
        for node in nodes {
            // 如果是 Dic 的情况
            if node.type == .dicStart {
                currentLevel += 1
                if currentLevel > 1 {
                    currentState = .startDicRecusive
                }
                
            }
            
            if node.type == .dicEnd {
                currentLevel -= 1
                if currentLevel == 1 {
                    currentState = .normal
                    recusiveNodeArr.append(node)
                    // 下一级 dic 的 node 收集完毕，开始递归获取 value node 的
                    currentValue = recusiveParseNodes(parentNode: defaultXcodeprojTreeNode(), nodes: recusiveNodeArr)
                    appendKvNode()
                    recusiveNodeArr = [XcodeprojNode]()
                    continue
                }
                
            }
            
            // 以下顺序不可改
            // 收集递归所需 node 集
            if currentState == .startDicRecusive {
                recusiveNodeArr.append(node)
                continue
            }
            
            // 如果是 Arr 的情况
            if node.type == .arrStart {
                currentState = .startArr
                continue
            }
            
            if node.type == .arrValue && currentState == .startArr {
                let arrValue = XcodeprojTreeNodeArrayValue(name: node.value, comment: node.codeComment)
                currentArr.append(arrValue)
                continue
            }
            
            if node.type == .arrEnd {
                currentState = .normal
                pNode.kvs.append(XcodeprojTreeNodeKv(key: currentKey, value: XcodeprojTreeNode(type: .array, value: "", comment: "", kvs: [XcodeprojTreeNodeKv](), arr: currentArr)))
                currentArr = [XcodeprojTreeNodeArrayValue]()
                continue
            }
            
            // key value 的记录
            if node.type == .dicKey {
                currentKey.name = node.value
                currentKey.comment = node.codeComment
                pNode.type = .keyValue
                continue
            }
            if node.type == .dicValue {
                currentValue.value = node.value
                currentValue.comment = node.codeComment
                appendKvNode()
                continue
            } // end if
            
        } // end for
        
        return pNode
    } // end fun recusiveParseNodes
    

}
