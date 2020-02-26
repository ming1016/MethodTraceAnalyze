//
//  OCApplyFeature.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/2/14.
//  Copyright © 2020 ming. All rights reserved.
//

import Foundation

struct OCApplyFeature {
    
    //MARK: Bundle 和 Class 的关系
    static func loadClassBundleOwner() -> [String:(String,String)] {
        
        let content = FileHandle.fileContent(path: Config.classBundleOwner.rawValue)
        
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
        
        var classBundleOwnerDic = [String:(String,String)]()
        for tks in allTks {
            var i = 0
            var currentClass = ""
            var currentBundle = ""
            var currentOwner = ""
            for tk in tks {
                if i == 0 {
                    // class
                    currentClass = tk.des()
                }
                if i == 1 {
                    // bundle
                    currentBundle = tk.des()
                }
                if i == 2 {
                    // owner
                    currentOwner = tk.des()
                }
                i += 1
            }
            classBundleOwnerDic[currentClass] = (currentBundle,currentOwner)
        }
        return classBundleOwnerDic
    }
    
    // MARK: 从 Name 里取出 Class
    public static func bundleAndClassFromName(name:String) -> String {
        let s1Arr = name.components(separatedBy: "[")
        let className = s1Arr[1].components(separatedBy: "]")[0]
        return className
    }
}
