//
//  SUITextField.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/2/20.
//  Copyright © 2020 ming. All rights reserved.
//

import SwiftUI

struct SignUpForm: View {
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Text("Sign up").font(.headline)
            TextField("Username", text: $username)
                .modifier(Validation(value: username) { name in
                    name.count > 4
                })
                .prefixedWithIcon(named: "person.circle.fill")
            TextField("Email", text: $email)
                .prefixedWithIcon(named: "envelope.circle.fill")
            Button(
                action: { print("ok ") },
                label: { Text("Continue") }
            )
        }
    }
}

// 使用扩展添加复用组件
extension View {
    func prefixedWithIcon(named name: String) -> some View {
        HStack {
            Image(name)
            self
        }
    }
}

// ViewModifier 来构建链式的视图验证
struct Validation<Value>: ViewModifier {
    var value: Value
    var validator: (Value) -> Bool

    func body(content: Content) -> some View {
        // Here we use Group to perform type erasure, to give our
        // method a single return type, as applying the 'border'
        // modifier causes a different type to be returned:
        Group {
            if validator(value) {
                content.border(Color.green)
            } else {
                content
            }
        }
    }
}

struct IconPrefixedTextField: View {
    var iconName: String
    var title: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(iconName)
            TextField(title, text: $text)
        }
    }
}
