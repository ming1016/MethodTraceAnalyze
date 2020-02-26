//
//  SUIText.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/2/20.
//  Copyright © 2020 ming. All rights reserved.
//
import SwiftUI

import Foundation

struct AddressView: View {
    var address: (one:String,two:String,three:String)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                Text(address.one)
                Text(address.two)
            }.font(.headline)
                .padding(3)
                .background(Color.secondary)
            
            HStack {
                Text(address.three)
                Text(address.one)
            }
            Text(address.two)
        }
    }
}

struct TitleView: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .italic()
            .foregroundColor(.blue)
    }
}


