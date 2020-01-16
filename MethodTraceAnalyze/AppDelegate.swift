//
//  AppDelegate.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2019/11/30.
//  Copyright © 2019 ming. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        export()
    }
    
    func export() {
//        TestJSON.codeLines()
//        TestJSON.testJSON()
//        TestXML.testXcodeWorkspace()
//        TestXcodeproj.testSection()
        
//        TestOC().testWorkspace()

//        TestOC.testOC()
//        TestOC.testMethodCall(filePath: Config.aMFilePath.rawValue)
//        TestOC.testUnUsedClass(filePath: Config.aMFilePath.rawValue)
//        LaunchJSON.exportAll()

//        TestOC.testM(filePath: Config.aMFilePath.rawValue)
        
        let _ = ParseOCMethodContent.unUsedClass(workSpacePath: Config.workPath.rawValue)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            OCStatistics.showAll()
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

