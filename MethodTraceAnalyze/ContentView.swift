//
//  ContentView.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/11/30.
//  Copyright © 2019 ming. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue]
    
    var body: some View {
        VStack {
            Text("text")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            TitleView(title: "title view")
//            AddressView(address: (one: "one", two: "two", three: "three"))
//            SignUpForm()
            Text("which").font(.custom("AmericanTypewriter", size: 72))

//            Divider()
            Text("which").font(.custom("AmericanTypewriter", size: 72))
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .zIndex(1)

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                ForEach((1...10).reversed(), id: \.self) {
                    Text("\($0)…")
                }

                Text("Ready or not, here I come!")
            }
            ForEach(colors, id: \.self) { color in
                Text(color.description.capitalized)
                    .padding()
                    .background(color)
            }
        }
    }
}


