//
//  RunOtool.swift
//  MethodTraceAnalyze
//
//  Created by ming on 2020/2/25.
//  Copyright © 2020 ming. All rights reserved.
//



import Foundation

struct ParseMachO {
    static let otool = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/otool"
    static let nm = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/nm"
    
    static func run() {
        print(terminalCommand(path: otool, args: ["-lV",Config.macho.rawValue]))
        
    }
    
    // MARK: 所有类
    // __DATA __objc_classlist
    static func classes() -> String {
        return terminalCommand(path: otool, args: ["-oV",Config.macho.rawValue])
    }
    
    // MARK: 使用到的方法
    // __DATA __objc_selrefs
    static func sel() -> String {
        return terminalCommand(path: otool, args: ["-v","-s","__DATA","__objc_selrefs",Config.macho.rawValue])
    }
    
    // MARK: load commands
    static func loadCommands() -> String {
        return terminalCommand(path: otool, args: ["-lV",Config.macho.rawValue])
    }
    
    // MARK: Mach header
    static func machHeader() -> String {
        return terminalCommand(path: otool, args: ["-hV",Config.macho.rawValue])
    }
    
    // MARK: 共享库 shared libraries
    static func sharedLibraries() -> String {
        return terminalCommand(path: otool, args: ["L",Config.macho.rawValue])
    }
    
    // MARK: 汇编
    // print the text section
    static func assemble() -> String {
        return terminalCommand(path: otool, args: ["-t","-v",Config.macho.rawValue])
    }
    
    // MARK: 汇编
    // print all text sections
    static func assembleAllSections() -> String {
        return terminalCommand(path: otool, args: ["-x","-v",Config.macho.rawValue])
    }
    
    // MARK: 显示程序符号表
    static func symbol() -> String {
        return terminalCommand(path: nm, args: ["-g",Config.macho.rawValue])
    }
    
    /* otool 命令参数说明
    -f print the fat headers
    -a print the archive header
    -h print the mach header
    -l print the load commands
    -L print shared libraries used
    -D print shared library id name
    -t print the text section (disassemble with -v)
    -x print all text sections (disassemble with -v)
    -p <routine name>  start dissassemble from routine name
    -s <segname> <sectname> print contents of section
    -d print the data section
    -o print the Objective-C segment
    -r print the relocation entries
    -S print the table of contents of a library (obsolete)
    -T print the table of contents of a dynamic shared library (obsolete)
    -M print the module table of a dynamic shared library (obsolete)
    -R print the reference table of a dynamic shared library (obsolete)
    -I print the indirect symbol table
    -H print the two-level hints table (obsolete)
    -G print the data in code table
    -v print verbosely (symbolically) when possible
    -V print disassembled operands symbolically
    -c print argument strings of a core file
    -X print no leading addresses or headers
    -m don't use archive(member) syntax
    -B force Thumb disassembly (ARM objects only)
    -q use llvm's disassembler (the default)
    -Q use otool(1)'s disassembler
    -mcpu=arg use `arg' as the cpu for disassembly
    -j print opcode bytes
    -P print the info plist section as strings
    -C print linker optimization hints
    */
    
    // 执行命令行
    static func terminalCommand(path:String, args:[String]) -> String {
        let pipe = Pipe()
        let file = pipe.fileHandleForReading
        
        let task = Process()
        task.launchPath = path
        task.arguments = args
        task.standardOutput = pipe
        task.launch()
        
        let data = file.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}
