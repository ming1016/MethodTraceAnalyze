//
//  Test.swift
//  SA
//
//  Created by ming on 2019/9/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

protocol Test {
    static func cs(current:String, expect:String, des:String)
}

// compare string 对比两个字符串值
extension Test {
    static func cs(current:String, expect: String, des: String) {
        if current == expect {
            print("✅ \(des) ok，符合预期值：\(expect)")
        } else {
            let msg = "❌ \(des) fail，不符合预期值：\(expect)"
            print(msg)
            assertionFailure(msg)
        }
    }
}
