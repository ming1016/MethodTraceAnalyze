//
//  Handy.swift
//  SA
//
//  Created by ming on 2019/11/1.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

func delay(interval: TimeInterval, closure: @escaping () -> Void) {
     DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
          closure()
     }
}
