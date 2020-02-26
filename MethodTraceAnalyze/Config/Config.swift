//
//  Config.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/12/11.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public enum Config: String {
    case downloadPath = "/Users/ming/Downloads/"
    
    case aMFilePath = "/Users/ming/Downloads/GCDFetchFeed/GCDFetchFeed/GCDFetchFeed/ArtWork.h"
    
    // startTrace、trace_15s1114
    case traceJSON = "startTrace"
    
    case classBundleOwner = "/Users/ming/Downloads/data/Biz/ClassBundle1025.csv"
    case classBundleOnwerOrigin = "/Users/ming/Downloads/data/Biz/ClassAndBundle.csv"
    // /Users/ming/Downloads/data/BundleSize/Simple
    // /Users/ming/Downloads/data/BundleSize/BigProject
    case macho = "/Users/ming/Downloads/data/BundleSize/GCDFetchFeed"
    
    static func workPath() -> String {
        return FileHandle.fileContent(path: "/Users/ming/Downloads/data/Config/workpath.txt")
    }
}



