//
//  Dictionary.swift
//  SA
//
//  Created by ming on 2019/10/28.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

extension Dictionary where Value:Comparable {
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 < $1.1}}
}
extension Dictionary where Key:Comparable {
    var sortedByKey:[(Key,Value)] {return Array(self).sorted{$0.0 < $1.0}}
}
