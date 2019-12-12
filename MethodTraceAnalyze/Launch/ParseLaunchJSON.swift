//
//  ParseLaunchJSON.swift
//  SA
//
//  Created by ming on 2019/10/26.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public struct LaunchItem {
    public let name: String  // 调用方法
    public var ph: String    // B 代表开始、E 代表结束、BE 代表合并后的 Item、其它代表描述
    public var ts: String    // 时间戳，开始时间
    public var cost: Int     // 耗时 ms
    public var times: Int    // 执行次数
    public var subItem: [LaunchItem]   // 子 item
    public var parentItem:[LaunchItem] // 父 item
}

public class ParseLaunchJSON {
    
    private enum State {
        case normal
        case startName
        case startPh
        case startTs
    }
    
    private var tks: [JSONToken]
    private var allLaunchItem: [LaunchItem]
    private var state: State
    private var classBundle: [String:String]
    
    public init(input: String) {
        
        tks = ParseJSONTokens(input: input).parse()
        allLaunchItem = [LaunchItem]()
        state = .normal
        classBundle = [String:String]()
        
    }
    
    public func parse() -> [LaunchItem] {
        // 获取类和 bundle 的映射表
        classBundle = loadClassBundle()
        
        // 开始解析
        var currentName = ""
        var currentPh = ""
        var currentTs = ""
        
        func addItem() {
            allLaunchItem.append(LaunchItem(name: currentName, ph: currentPh, ts: currentTs, cost: 0, times: 1, subItem: [LaunchItem](), parentItem: [LaunchItem]()))
            currentName = ""
            currentPh = ""
            currentTs = ""
            state = .normal
        }
        
        for tk in tks {
            // 结束一个 item
            if tk.type == .endDic {
                addItem()
                continue
            }
            
            // key
            if tk.type == .key {
                if tk.value == "name" {
                    state = .startName
                }
                if tk.value == "ph" {
                    state = .startPh
                }
                if tk.value == "ts" {
                    state = .startTs
                }
                
                continue
            }
            
            if tk.type == .value {
                if state == .startName {
                    currentName = tk.value
                    let s1 = currentName.components(separatedBy: "[")[1]
                    let s2 = s1.components(separatedBy: "]")[0]
                    
                    currentName = "[\(classBundle[s2] ?? "other")]\(currentName)"
                    state = .normal
                }
                if state == .startPh {
                    currentPh = tk.value
                    state = .normal
                }
                if state == .startTs {
                    currentTs = tk.value
                    state = .normal
                }
                continue
            }
            
            
        }
        
        return allLaunchItem
    }
    
    private func loadClassBundle() -> [String:String] {
        let path = Bundle.main.path(forResource: "ClassBundle1015", ofType: "csv")
        let oPath = path ?? ""
        
        let content = FileHandle.fileContent(path: oPath)
        
        let tokens = Lexer(input: content, type: .plain).allTkFast(operaters: ",")
        var allTks = [[Token]]()
        var currentTks = [Token]()
        for tk in tokens {
            if tk == .newLine {
                allTks.append(currentTks)
                currentTks = [Token]()
                continue
            }
            if tk == .id(",") {
                continue
            }
            currentTks.append(tk)
        }
        
        var classBundleDic = [String:String]()
        for tks in allTks {
            var i = 0
            var currentKey = ""
            for tk in tks {
                if i == 0 {
                    currentKey = tk.des()
                }
                if i == 1 {
                    classBundleDic[currentKey] = tk.des()
                }
                i += 1
            }
        }
        return classBundleDic
    }
    
    private func parseClassAndBundle() {
        let path = Bundle.main.path(forResource: "ClassAndBundle", ofType: "csv")
        let oPath = path ?? ""
        
        let content = FileHandle.fileContent(path: oPath)
        let contentWithoutWhiteSpace = content.replacingOccurrences(of: " ", with: "")
        let tokens = Lexer(input: contentWithoutWhiteSpace, type: .plain).allTkFast(operaters: ",")
        var allTks = [[Token]]()
        var currentTks = [Token]()
        for tk in tokens {
            if tk == .newLine {
                allTks.append(currentTks)
                currentTks = [Token]()
                continue
            }
            if tk == .id(",") {
                continue
            }
            currentTks.append(tk)
        }
        //print(allTks)
        allTks.remove(at: 0)
        var classBundleDic = [String:String]()
        for tks in allTks {
            var i = 0
            var currentKey = ""
            for tk in tks {
                if i == 2 {
                    let className = tk.des()
                    let classNameS1 = className.replacingOccurrences(of: "\"[\"\"", with: "")
                    let classNameS2 = classNameS1.replacingOccurrences(of: "\"\"]\"", with: "")
                    currentKey = classNameS2
                }
                if i == 4 {
                    classBundleDic[currentKey] = tk.des()
                }
                i += 1
            }
        }
        var str = ""
        for (k,v) in classBundleDic {
            str.append("\(k),\(v)\n")
        }
        try! str.write(toFile: "\(Config.downloadPath.rawValue)classBundle1015.csv", atomically: true, encoding: String.Encoding.utf8)
    }
    
}









