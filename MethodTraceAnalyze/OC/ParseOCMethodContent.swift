//
//  ParseOCMethodContent.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/12/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class ParseOCMethodContent {
    
    private var tkNodes: [OCTokenNode]
    
    public init(tokenNodes:[OCTokenNode]) {
        tkNodes = tokenNodes
    }
    
    static func parseMethodCall() -> [String] {
        
        return [String]()
    }
}
