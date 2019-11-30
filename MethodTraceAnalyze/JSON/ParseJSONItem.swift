//
//  ParseJSONItem.swift
//  SA
//
//  Created by ming on 2019/11/4.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public enum JSONItemType {
    case keyValue
    case value
    case array
}

public struct JSONItemKv {
    public var key: String
    public var value: JSONItem
}

public struct JSONItem {
    public var type: JSONItemType
    public var value: String
    public var kvs: [JSONItemKv]
    public var array: [JSONItem]
}

public class ParseJSONItem {
    private var tks: [JSONToken]
    
    
    
    public init(input:String) {
        tks = ParseJSONTokens(input: input).parse()
        
    }
    
    public func parse() -> JSONItem {
        let rootItem = recursiveTk(parentItem: defaultJSONItem(), Tks: tks)
        return rootItem
    }
    
    private func defaultJSONItem() -> JSONItem {
        return JSONItem(type: .value, value: "", kvs: [JSONItemKv](), array: [JSONItem]())
    }
    
    public func recursiveTk(parentItem:JSONItem, Tks:[JSONToken]) -> JSONItem {
        enum rState {
            case normal
            case startDic
            case startArr
            case startKey
        }
        var pItem = parentItem
        var currentState:rState = .normal
        var currentDicLevel = 0
        var currentArrLevel = 0
        var recursiveTkArr = [JSONToken]()
        
        var currentItemType:JSONItemType = .value
        var currentKey = ""
        var currentValue = defaultJSONItem()
        var currentArr = [String]()
        
        func resetCurrent() {
            currentItemType = .value
            currentKey = ""
            currentValue = defaultJSONItem()
        }
        
        func appendKvItem() {
            let kv = JSONItemKv(key: currentKey, value: currentValue)
            pItem.kvs.append(kv)
            pItem.type = .keyValue
            resetCurrent()
        }
        
        func appendVItem() {
            pItem.type = .array
            pItem.array.append(currentValue)
            resetCurrent()
        }
        
        for tk in Tks {
            // 如果是字典情况
            if tk.type == .startDic && currentState != .startArr {
                currentDicLevel += 1
                currentState = .startDic
                if currentDicLevel == 1 {
                    continue
                }
                
            } // end if tk.type == .startDic
            
            if tk.type == .endDic && currentState != .startArr {
                currentDicLevel -= 1
                if currentDicLevel == 0 {
                    currentState = .normal
                    // 将下一级收集完
                    currentValue = recursiveTk(parentItem: defaultJSONItem(), Tks: recursiveTkArr)
                    if currentKey.count > 0 {
                        appendKvItem()
                    } else {
                        appendVItem()
                    }
                    
                    recursiveTkArr = [JSONToken]()
                    continue
                }
            } // if tk.type == .endDic
            
            if currentState == .startDic {
                recursiveTkArr.append(tk)
                continue
            }
            
            if tk.type == .startArray && currentState != .startDic {
                currentArrLevel += 1
                currentState = .startArr
                if currentArrLevel == 1 {
                    continue
                }
            }
            
            if tk.type == .endArray && currentState != .startDic {
                currentArrLevel -= 1
                if currentArrLevel == 0 {
                    currentState = .normal
                    // 收集下一级
                    currentValue = recursiveTk(parentItem: defaultJSONItem(), Tks: recursiveTkArr)
                    if currentKey.count > 0 {
                        appendKvItem()
                    } else {
                        appendVItem()
                    }
                    
                    recursiveTkArr = [JSONToken]()
                    continue
                }
            } // end if tk.type == .endArray
            
            // 下列顺序不可改
            // 收集递归所需 item 集
            if currentState == .startArr {
                recursiveTkArr.append(tk)
                continue
            }
            
            if currentState == .startKey {
                if tk.type == .value {
                    currentValue = defaultJSONItem()
                    currentValue.value = tk.value
                    appendKvItem()
                    currentState = .normal
                    continue
                }
            }
            
            if tk.type == .value {
                currentValue = defaultJSONItem()
                currentValue.value = tk.value
                appendVItem()
                continue
            }
            
            // 如果是数组 arr 的情况
            if tk.type == .key {
                if pItem.type == .array {
                    currentValue = defaultJSONItem()
                    currentValue.value = tk.value
                    appendVItem()
                    continue
                }
                
                currentState = .startKey
                currentKey = tk.value
                continue
            }
            
        } // end for tk in Tks
        return pItem
    }
    
}
