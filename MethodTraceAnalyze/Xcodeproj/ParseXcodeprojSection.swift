//
//  ParseXcodeprojSection.swift
//  SA
//
//  Created by ming on 2019/9/10.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

// project.pbxproj 结构
public struct Xcodeproj {
    var archiveVersion = ""
    var classes = [XcodeprojTreeNodeArrayValue]()
    var objectVersion = "" // 区分 xcodeproj 不同协议版本
    var rootObject = PBXValueWithComment(name: "", value: "")
    
    var pbxBuildFile = [String:PBXBuildFile]()
    var pbxContainerItemProxy = [String:PBXContainerItemProxy]()
    var pbxFileReference = [String:PBXFileReference]()
    var pbxFrameworksBuildPhase = [String:PBXFrameworksBuildPhase]()
    var pbxGroup = [String:PBXGroup]()
    var pbxNativeTarget = [String:PBXNativeTarget]()
    var pbxProject = [String:PBXProject]()
    var pbxResourcesBuildPhase = [String:PBXResourcesBuildPhase]()
    var pbxSourcesBuildPhase = [String:PBXSourcesBuildPhase]()
    var pbxTargetDependency = [String:PBXTargetDependency]()
    var pbxVariantGroup = [String:PBXVariantGroup]()
    var xcBuildConfiguration = [String:XCBuildConfiguration]()
    var xcConfigurationList = [String:XCConfigurationList]()
    
    init() {
        
    }
}

public struct PBXValueWithComment {
    let name: String
    let value: String
}

// ------- Objects ---------
// 文件，最终会关联到 PBXFileReference
public struct PBXBuildFile {
    var file = "" // 注释中文件名
    var fileRef = "" // 3AF0A7C8231E61B30080E07C
}

// 部署的元素
public struct PBXContainerItemProxy {
    var containerPortal = "" // Project object
    var proxyType = "" // 1
    var remoteGlobalIDString = "" // 3AF0A7C0231E61B30080E07C
    var remoteInfo = "" // SampleProject
}

// 各类文件，有源码、资源、库等文件
public struct PBXFileReference {
    var explicitFileType = "" // wrapper.application、wrapper.cfbundle
    var includeInIndex = "" // 0
    var path = "" // AppDelegate.h
    var sourceTree = "" // "<group>"、BUILT_PRODUCTS_DIR
    
    var lastKnownFileType = "" // sourcecode.c.objc
}

// 用于 framework 的构建
public struct PBXFrameworksBuildPhase {
    var buildActionMask = "" // 2147483647
    var files = [PBXValueWithComment]()
    var runOnlyForDeploymentPostprocessing = "" // 0
    
}

// 文件夹，可嵌套，里面包含了文件与文件夹的关系
public struct PBXGroup {
    var children = [PBXValueWithComment]() // 3AF0A7C3231E61B30080E07C /* SampleProject */
    var sourceTree = "" // "<group>"
    var name = "" // Products
    var path = "" // SampleProject
}

// Target 的设置
public struct PBXNativeTarget {
    var buildConfigurationList = PBXValueWithComment(name: "", value: "") // 3AF0A7ED231E61B50080E07C /* Build configuration list for PBXNativeTarget "SampleProject" */
    var buildPhases = [PBXValueWithComment]() // 3AF0A7BD231E61B30080E07C /* Sources */
    var buildRules = [PBXValueWithComment]()
    var dependencies = [PBXValueWithComment]()
    var name = "" // SampleProject
    var productName = "" // SampleProject
    var productReference = PBXValueWithComment(name: "", value: "") // 说明里是文件名 3AF0A7C1231E61B30080E07C /* SampleProject.app */
    var productType = "" // "com.apple.product-type.application"
}

// Project 的设置，有编译工程所需信息
public struct PBXProject {
    var attributes = [XcodeprojTreeNodeKv]() // 暂时不用
    var buildConfigurationList = PBXValueWithComment(name: "", value: "") // 3AF0A7BC231E61B30080E07C /* Build configuration list for PBXProject "SampleProject" */
    var compatibilityVersion = "" // "Xcode 9.3"
    var developmentRegion = "" // en
    var hasScannedForEncodings = "" // 0
    var knowRegions = [PBXValueWithComment]() // en
    var mainGroup = "" // 3AF0A7B8231E61B30080E07C
    var productRefGroup = PBXValueWithComment(name: "", value: "") // 3AF0A7C2231E61B30080E07C /* Products */
    var projectDirPath = ""
    var projectRoot = ""
    var targets = [PBXValueWithComment]() // 3AF0A7C0231E61B30080E07C /* SampleProject */
    
}

// 编译资源文件，有 xib、storyboard、plist以及图片等资源文件
public struct PBXResourcesBuildPhase {
    var buildActionMask = "" // 2147483647
    var files = [PBXValueWithComment]() // 3AF0A7D1231E61B50080E07C /* LaunchScreen.storyboard in Resources */
    var runOnlyForDeploymentPostprocessing = "" // 0
}

// 编译源文件（.m）
public struct PBXSourcesBuildPhase {
    var buildActionMask = "" // 2147483647
    var files = [PBXValueWithComment]() // 3AF0A7C9231E61B30080E07C /* ViewController.m in Sources */
    var runOnlyForDeploymentPostprocessing = "" // 0
}

// Taget 的依赖
public struct PBXTargetDependency {
    var target = PBXValueWithComment(name: "", value: "") // 3AF0A7C0231E61B30080E07C /* SampleProject */
    var targetProxy = PBXValueWithComment(name: "", value: "") // 3AF0A7DA231E61B50080E07C /* PBXContainerItemProxy */
}

// .storyboard 文件
public struct PBXVariantGroup {
    var children = [PBXValueWithComment]() // 3AF0A7CB231E61B30080E07C /* Base */
    var name = "" // Main.storyboard
    var sourceTree = "" // "<group>"
}

// Xcode 编译配置，对应 Xcode 的 Build Setting 面板内容
public struct XCBuildConfiguration {
    var name = "" // Debug
    
    // build settings
    var alwaysSearchUserPaths = "" // NO
    var clangAnalyzerNonnull = "" // YES
    var clangAnalyzerNumberObjectConversion = "" // YES_AGGRESSIVE
    var clangCxxLanguageStandard = "" // "gnu++14"
    var clangCxxLibrary = "" // "libc++"
    var clangEnableModules = "" // YES
    var clangEnableObjcArc = "" // YES
    var clangEnableObjcWeak = "" // YES
    var clangWarnBlockCaptureAutoreleasing = "" // YES
    var clangWarnBoolConversion = "" // YES
    var clangWarnComma = "" // YES
    var clangWarnConstantConversion = "" // YES
    var clangWarnDeprecatedObjcImplementations = "" // YES
    var clangWarnDirectObjcIsaUsage = "" // YES_ERROR
    var clangWarnDocumentationComment = "" // YES
    var clangWarnEmptyBody = "" // YES
    var clangWarnEnumConversion = "" // YES
    var clangWarnInfiniteRecursion = "" // YES
    var clangWarnIntConversion = "" // YES
    var clangWarnNonLiteralNullConversion = "" // YES
    var clangWarnObjcImplicitRetainSelf = "" // YES
    var clangWarnObjcLiteralConversion = "" // YES
    var clangWarnObjcRootClass = "" // YES
    var clangWarnRangeLoopAnalysis = "" // YES
    var clangWarnStrictPrototypes = "" // YES
    var clangWarnSuspiciousMove = "" // YES
    var clangWarnUnguardedAvailability = "" // YES
    var clangWarnUnreachableCode = "" // YES
    var clangWarnDuplicateMethodMatch = "" // YES
    
    var codeSignIdentity = "" // "iPhone Developer"
    var copyPhaseStrip = "" // NO
    var debugInformationFormat = "" // dwarf
    var enableNsAssertions = "" // NO
    var enableStrictObjcMsgsend = "" // YES
    var enableTestAbility = "" // YES
    
    var gccCLanguageStandard = "" // gnu11
    var gccDynamicNoPic = "" // NO
    var gccNoCommonBLocks = "" // YES
    var gccOptimizationLevel = "" // 0
    var gccPreprocessorDefinitions = [PBXValueWithComment]() // "DEBUG=1"
    
    var gccWarn64To32BitConversion = "" // YES
    var gccWarnAboutReturnType = "" // YES_ERROR
    var gccWarnUndeclaredSelector = "" // YES
    var gccWarnUninitializedAutos = "" // YES_AGGRESSIVE
    var gccWarnUnusedFunction = "" // YES
    var gccWarnUnusedVariable = "" // YES
    var iPhoneOSDeploymentTarget = "" // YES
    var mtlEnableDebugInfo = "" // INCLUDE_SOURCE
    var mtlFastMath = "" // YES
    var onlyActiveArch = "" // YES
    var sdkRoot = "" // iphoneos
    var validateProduct = "" // YES
    
    
    var codeSignStyle = "" // Automatic
    var infoPlistFile = "" // SampleProject/Info.plist
    var ldRunPathSearchPath = [PBXValueWithComment]() // "$(inherited)"
    var productBundleIdentifier = "" // com.starming.SampleProject
    var productName = "" //"$(TARGET_NAME)"
    var targetedDeviceFamily = "" // "1,2"
    var testTargetName = "" // SampleProject
    
    var testHost = "" // "$(BUILT_PRODUCTS_DIR)/SampleProject.app/SampleProject"
    var bundleLoader = "" // "$(TEST_HOST)"
    var assetCatalogCompilerAppiconName = "" // AppIcon
    
}

// 构建配置相关，包含项目文件和 target 文件
public struct XCConfigurationList {
    var buildConfigurations = [PBXValueWithComment]()
    var defaultConfigurationIsVisible = ""
    var defaultConfigurationName = ""
}

// MARK:Main ParseXcodeprojSection

public class ParseXcodeprojSection {
    
    private var treeNode: XcodeprojTreeNode
    private var proj: Xcodeproj
    
    public init(input: String) {
        treeNode = ParseXcodeprojTreeNode(input: input).parse()
        proj = Xcodeproj()
        //print(treeNode)
    }
    
    public func desKey(key:String) -> String {
        var reKey = "   ---------------------\n"
        reKey.append("   key: \(key)\n")
        return reKey
    }
    
    // MARK:打印 proj
    public func desProj() -> String {
        var dStr = ""
        dStr.append("archiveVersion: \(proj.archiveVersion)\n")
        dStr.append("classes:\n")
        for v in proj.classes {
            dStr.append("   name: \(v.name)\n")
            dStr.append("   comment: \(v.comment)\n")
            dStr.append("\n")
        }
        dStr.append("objectVersion: \(proj.objectVersion)\n")
        dStr.append("rootObject:\n")
        dStr.append("   name: \(proj.rootObject.name)\n")
        dStr.append("   value: \(proj.rootObject.value)\n")
        dStr.append("\n")
        
        dStr.append("pbxBuildFile:\n")
        for (k,v) in proj.pbxBuildFile {
            dStr.append(desKey(key: k))
            dStr.append("   file: \(v.file)\n")
            dStr.append("   fileRef: \(v.fileRef)\n")
            dStr.append("\n")
        }
        
        
        dStr.append("pbxContainerItemProxy:\n")
        for (k,v) in proj.pbxContainerItemProxy {
            dStr.append(desKey(key: k))
            dStr.append("   containerPortal: \(v.containerPortal)\n")
            dStr.append("   proxyType: \(v.proxyType)\n")
            dStr.append("   remoteGlobalIDString: \(v.remoteGlobalIDString)\n")
            dStr.append("   remoteInfo: \(v.remoteInfo)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxFileReference:\n")
        for (k,v) in proj.pbxFileReference {
            dStr.append(desKey(key: k))
            dStr.append("   explicitFileType: \(v.explicitFileType)\n")
            dStr.append("   includeInIndex: \(v.includeInIndex)\n")
            dStr.append("   path: \(v.path)\n")
            dStr.append("   sourceTree: \(v.sourceTree)\n")
            dStr.append("   lastKnowFileType: \(v.lastKnownFileType)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxFrameworksBuildPhase:\n")
        for (k,v) in proj.pbxFrameworksBuildPhase {
            dStr.append(desKey(key: k))
            dStr.append("   buildActionMask: \(v.buildActionMask)\n")
            dStr.append("   files:\n")
            for vv in v.files {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   runOnlyForDeploymentPostprocessing: \(v.runOnlyForDeploymentPostprocessing)\n")
            dStr.append("\n")
        }
        dStr.append("\n")
        
        dStr.append("pbxGroup:\n")
        for (k,v) in proj.pbxGroup {
            dStr.append(desKey(key: k))
            dStr.append("   children:\n")
            for vv in v.children {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   sourceTree: \(v.sourceTree)\n")
            dStr.append("   name: \(v.name)\n")
            dStr.append("   path: \(v.path)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxNativeTarget:\n")
        for (k,v) in proj.pbxNativeTarget {
            dStr.append(desKey(key: k))
            dStr.append("   buildConfigurationList:\n")
            dStr.append("       name:\(v.buildConfigurationList.name)\n")
            dStr.append("       value:\(v.buildConfigurationList.value)\n")
            dStr.append("   buildPhases:\n")
            for vv in v.buildPhases {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   buildRules:\n")
            for vv in v.buildRules {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   dependencies:\n")
            for vv in v.dependencies {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   name: \(v.name)\n")
            dStr.append("   productName: \(v.productName)\n")
            dStr.append("   productReference:\n")
            dStr.append("       name:\(v.productReference.name)\n")
            dStr.append("       value:\(v.productReference.value)\n")
            dStr.append("   productType: \(v.productType)\n")
            
            dStr.append("\n")
        }
        
        dStr.append("pbxProject:\n")
        for (k,v) in proj.pbxProject {
            dStr.append(desKey(key: k))
            dStr.append("   attributes: put away\n")
            dStr.append("   buildConfigurationList:\n")
            dStr.append("       name:\(v.buildConfigurationList.name)\n")
            dStr.append("       value:\(v.buildConfigurationList.value)\n")
            dStr.append("   compatibilityVersion: \(v.compatibilityVersion)\n")
            dStr.append("   developmentRegion: \(v.developmentRegion)\n")
            dStr.append("   hasScannedForEncodings: \(v.hasScannedForEncodings)\n")
            dStr.append("   knowRegions:\n")
            for vv in v.knowRegions {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   productRefGroup:\n")
            dStr.append("       name:\(v.buildConfigurationList.name)\n")
            dStr.append("       value:\(v.buildConfigurationList.value)\n")
            dStr.append("   projectDirPath: \(v.projectDirPath)\n")
            dStr.append("   projectRoot: \(v.projectRoot)\n")
            dStr.append("   targets:\n")
            for vv in v.targets {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
        }
        
        dStr.append("pbxResourcesBuildPhase:\n")
        for (k,v) in proj.pbxResourcesBuildPhase {
            dStr.append(desKey(key: k))
            dStr.append("   buildActionMask: \(v.buildActionMask)\n")
            dStr.append("   files:\n")
            for vv in v.files {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   runOnlyForDeploymentPostprocessing: \(v.runOnlyForDeploymentPostprocessing)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxSourcesBuildPhase:\n")
        for (k,v) in proj.pbxSourcesBuildPhase {
            dStr.append(desKey(key: k))
            dStr.append("   buildActionMask: \(v.buildActionMask)\n")
            dStr.append("   files:\n")
            for vv in v.files {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   runOnlyForDeploymentPostprocessing: \(v.runOnlyForDeploymentPostprocessing)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxTargetDependency:\n")
        for (k,v) in proj.pbxTargetDependency {
            dStr.append(desKey(key: k))
            dStr.append("   target:\n")
            dStr.append("       name:\(v.target.name)\n")
            dStr.append("       value:\(v.target.value)\n")
            dStr.append("   targetProxy:\n")
            dStr.append("       name:\(v.targetProxy.name)\n")
            dStr.append("       value:\(v.targetProxy.value)\n")
            dStr.append("\n")
        }
        
        dStr.append("pbxVariantGroup:\n")
        for (k,v) in proj.pbxVariantGroup {
            dStr.append(desKey(key: k))
            dStr.append("   children:\n")
            for vv in v.children {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   name: \(v.name)\n")
            dStr.append("   sourceTree: \(v.sourceTree)\n")
            dStr.append("\n")
        }
        
        dStr.append("xcBuildConfiguration:\n")
        for (k,v) in proj.xcBuildConfiguration {
            dStr.append(desKey(key: k))
            dStr.append("   name: \(v.name)\n")
            dStr.append("   alwaysSearchUserPaths: \(v.alwaysSearchUserPaths)\n")
            dStr.append("   clangAnalyzerNonnull: \(v.clangAnalyzerNonnull)\n")
            dStr.append("   clangAnalyzerNumberObjectConversion: \(v.clangAnalyzerNumberObjectConversion)\n")
            dStr.append("   clangCxxLanguageStandard: \(v.clangCxxLanguageStandard)\n")
            dStr.append("   clangCxxLibrary: \(v.clangCxxLibrary)\n")
            dStr.append("   clangEnableModules: \(v.clangEnableModules)\n")
            dStr.append("   clangEnableObjcArc: \(v.clangEnableObjcArc)\n")
            dStr.append("   clangEnableObjcWeak: \(v.clangEnableObjcWeak)\n")
            dStr.append("   clangWarnBlockCaptureAutoreleasing: \(v.clangWarnBlockCaptureAutoreleasing)\n")
            dStr.append("   clangWarnBoolConversion: \(v.clangWarnBoolConversion)\n")
            dStr.append("   clangWarnComma: \(v.clangWarnComma)\n")
            dStr.append("   clangWarnConstantConversion: \(v.clangWarnConstantConversion)\n")
            dStr.append("   clangWarnDeprecatedObjcImplementations: \(v.clangWarnDeprecatedObjcImplementations)\n")
            dStr.append("   clangWarnDirectObjcIsaUsage: \(v.clangWarnDirectObjcIsaUsage)\n")
            dStr.append("   clangWarnDocumentationComment: \(v.clangWarnDocumentationComment)\n")
            dStr.append("   clangWarnEmptyBody: \(v.clangWarnEmptyBody)\n")
            dStr.append("   clangWarnEnumConversion: \(v.clangWarnEnumConversion)\n")
            dStr.append("   clangWarnInfiniteRecursion: \(v.clangWarnInfiniteRecursion)\n")
            dStr.append("   clangWarnIntConversion: \(v.clangWarnIntConversion)\n")
            dStr.append("   clangWarnNonLiteralNullConversion: \(v.clangWarnNonLiteralNullConversion)\n")
            dStr.append("   clangWarnObjcImplicitRetainSelf: \(v.clangWarnObjcImplicitRetainSelf)\n")
            dStr.append("   clangWarnObjcLiteralConversion: \(v.clangWarnObjcLiteralConversion)\n")
            dStr.append("   clangWarnObjcRootClass: \(v.clangWarnObjcRootClass)\n")
            dStr.append("   clangWarnRangeLoopAnalysis: \(v.clangWarnRangeLoopAnalysis)\n")
            dStr.append("   clangWarnStrictPrototypes: \(v.clangWarnStrictPrototypes)\n")
            dStr.append("   clangWarnSuspiciousMove: \(v.clangWarnSuspiciousMove)\n")
            dStr.append("   clangWarnUnguardedAvailability: \(v.clangWarnUnguardedAvailability)\n")
            dStr.append("   clangWarnUnreachableCode: \(v.clangWarnUnreachableCode)\n")
            dStr.append("   clangWarnDuplicateMethodMatch: \(v.clangWarnDuplicateMethodMatch)\n")
            dStr.append("   codeSignIdentity: \(v.codeSignIdentity)\n")
            dStr.append("   copyPhaseStrip: \(v.copyPhaseStrip)\n")
            dStr.append("   debugInformationFormat: \(v.debugInformationFormat)\n")
            dStr.append("   enableNsAssertions: \(v.enableNsAssertions)\n")
            dStr.append("   enableStrictObjcMsgsend: \(v.enableStrictObjcMsgsend)\n")
            dStr.append("   enableTestAbility: \(v.enableTestAbility)\n")
            dStr.append("   gccCLanguageStandard: \(v.gccCLanguageStandard)\n")
            dStr.append("   gccDynamicNoPic: \(v.gccDynamicNoPic)\n")
            dStr.append("   gccNoCommonBLocks: \(v.gccNoCommonBLocks)\n")
            dStr.append("   gccOptimizationLevel: \(v.gccOptimizationLevel)\n")
            dStr.append("   gccPreprocessorDefinitions:\n")
            for vv in v.gccPreprocessorDefinitions {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   gccWarn64To32BitConversion: \(v.gccWarn64To32BitConversion)\n")
            dStr.append("   gccWarnAboutReturnType: \(v.gccWarnAboutReturnType)\n")
            dStr.append("   gccWarnUndeclaredSelector: \(v.gccWarnUndeclaredSelector)\n")
            dStr.append("   gccWarnUninitializedAutos: \(v.gccWarnUninitializedAutos)\n")
            dStr.append("   gccWarnUnusedFunction: \(v.gccWarnUnusedFunction)\n")
            dStr.append("   gccWarnUnusedVariable: \(v.gccWarnUnusedVariable)\n")
            dStr.append("   iPhoneOSDeploymentTarget: \(v.iPhoneOSDeploymentTarget)\n")
            dStr.append("   mtlEnableDebugInfo: \(v.mtlEnableDebugInfo)\n")
            dStr.append("   mtlFastMath: \(v.mtlFastMath)\n")
            dStr.append("   onlyActiveArch: \(v.onlyActiveArch)\n")
            dStr.append("   sdkRoot: \(v.sdkRoot)\n")
            dStr.append("   validateProduct: \(v.validateProduct)\n")
            dStr.append("   codeSignStyle: \(v.codeSignStyle)\n")
            dStr.append("   infoPlistFile: \(v.infoPlistFile)\n")
            dStr.append("   ldRunPathSearchPath:\n")
            for vv in v.ldRunPathSearchPath {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   productBundleIdentifier: \(v.productBundleIdentifier)\n")
            dStr.append("   productName: \(v.productName)\n")
            dStr.append("   targetedDeviceFamily: \(v.targetedDeviceFamily)\n")
            dStr.append("   testTargetName: \(v.testTargetName)\n")
            dStr.append("   testHost: \(v.testHost)\n")
            dStr.append("   bundleLoader: \(v.bundleLoader)\n")
            dStr.append("   assetCatalogCompilerAppiconName: \(v.assetCatalogCompilerAppiconName)\n")
            dStr.append("\n")
        }
        
        dStr.append("xcConfigurationList:\n")
        for (k,v) in proj.xcConfigurationList {
            dStr.append(desKey(key: k))
            dStr.append("   buildConfigurations:\n")
            for vv in v.buildConfigurations {
                dStr.append("       name: \(vv.name)\n")
                dStr.append("       value: \(vv.value)\n")
                dStr.append("\n")
            }
            dStr.append("   defaultConfigurationIsVisible: \(v.defaultConfigurationIsVisible)\n")
            dStr.append("   defaultConfigurationName: \(v.defaultConfigurationName)\n")
            dStr.append("\n")
        }
        
        return dStr
        
    }
    
    // MARK:Main Parse
    public func parse() -> Xcodeproj {
        for kv in treeNode.kvs {
            let keyName = kv.key.name
            let value = kv.value.value
            switch keyName {
            case "archiveVersion":
                proj.archiveVersion = value
            case "classes":
                proj.classes = kv.value.arr
            case "objectVersion":
                proj.objectVersion = value
            case "rootObject":
                proj.rootObject = PBXValueWithComment(name: kv.value.comment, value: value)
            case "objects":
                parseObjects(kvs: kv.value.kvs)
            default:
                continue
            } // end switch
        } // end for
        
        return proj
    } // end func
    
    // MARK:Parse Objects
    
    private func parseObjects(kvs: [XcodeprojTreeNodeKv]) {
        enum stepType {
            case Default
            case PBXBuildFile
            case PBXContainerItemProxy
            case PBXFileReference
            case PBXFrameworksBuildPhase
            case PBXGroup
            case PBXNativeTarget
            case PBXProject
            case PBXResourcesBuildPhase
            case PBXSourcesBuildPhase
            case PBXTargetDependency
            case PBXVariantGroup
            case XCBuildConfiguration
            case XCConfigurationList
        }
        
        var currentStepType:stepType = .Default
        
        
        
        for kv in kvs {
            guard kv.value.kvs.count > 0 else {
                continue
            }
            
            // MARK:初始化结构体
            var buildFile = PBXBuildFile()
            var containerItemProxy = PBXContainerItemProxy()
            var fileReference = PBXFileReference()
            var frameworksBuildPhase = PBXFrameworksBuildPhase()
            var group = PBXGroup()
            var nativeTarget = PBXNativeTarget()
            var project = PBXProject()
            var resourcesBuildPhase = PBXResourcesBuildPhase()
            var sourcesBuildPhase = PBXSourcesBuildPhase()
            var targetDependency = PBXTargetDependency()
            var variantGroup = PBXVariantGroup()
            var xcBuildConfiguration = XCBuildConfiguration()
            var xcConfigurationList = XCConfigurationList()
            
            for kv in kv.value.kvs {
                let key = kv.key
                let value = kv.value
                // MARK:根据 isa 设置状态
                if key.name == "isa" {
                    switch value.value {
                    case "PBXBuildFile":
                        currentStepType = .PBXBuildFile
                    case "PBXContainerItemProxy":
                        currentStepType = .PBXContainerItemProxy
                    case "PBXFileReference":
                        currentStepType = .PBXFileReference
                    case "PBXFrameworksBuildPhase":
                        currentStepType = .PBXFrameworksBuildPhase
                    case "PBXGroup":
                        currentStepType = .PBXGroup
                    case "PBXNativeTarget":
                        currentStepType = .PBXNativeTarget
                    case "PBXProject":
                        currentStepType = .PBXProject
                    case "PBXResourcesBuildPhase":
                        currentStepType = .PBXResourcesBuildPhase
                    case "PBXSourcesBuildPhase":
                        currentStepType = .PBXSourcesBuildPhase
                    case "PBXTargetDependency":
                        currentStepType = .PBXTargetDependency
                    case "PBXVariantGroup":
                        currentStepType = .PBXVariantGroup
                    case "XCBuildConfiguration":
                        currentStepType = .XCBuildConfiguration
                    case "XCConfigurationList":
                        currentStepType = .XCConfigurationList
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:状态区分
                if currentStepType == .XCConfigurationList {
                    switch key.name {
                    case "buildConfigurations":
                        xcConfigurationList.buildConfigurations = valueToValueWithCommentArray(treeNode: value)
                    case "defaultConfigurationIsVisible":
                        xcConfigurationList.defaultConfigurationIsVisible = value.value
                    case "defaultConfigurationName":
                        xcConfigurationList.defaultConfigurationName = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:XCBuildConfiguration
                if currentStepType == .XCBuildConfiguration {
                    switch key.name {
                    case "name":
                        xcBuildConfiguration.name = value.value
                    case "buildSettings":
                        for kv in value.kvs {
                            switch kv.key.name {
                            case "ALWAYS_SEARCH_USER_PATHS":
                                xcBuildConfiguration.alwaysSearchUserPaths = kv.value.value
                            case "CLANG_ANALYZER_NONNULL":
                                xcBuildConfiguration.clangAnalyzerNonnull = kv.value.value
                            case "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION":
                                xcBuildConfiguration.clangAnalyzerNumberObjectConversion = kv.value.value
                            case "CLANG_CXX_LANGUAGE_STANDARD":
                                xcBuildConfiguration.clangCxxLanguageStandard = kv.value.value
                            case "CLANG_CXX_LIBRARY":
                                xcBuildConfiguration.clangCxxLibrary = kv.value.value
                            case "CLANG_ENABLE_MODULES":
                                xcBuildConfiguration.clangEnableModules = kv.value.value
                            case "CLANG_ENABLE_OBJC_ARC":
                                xcBuildConfiguration.clangEnableObjcArc = kv.value.value
                            case "CLANG_ENABLE_OBJC_WEAK":
                                xcBuildConfiguration.clangEnableObjcWeak = kv.value.value
                            case "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING":
                                xcBuildConfiguration.clangWarnBlockCaptureAutoreleasing = kv.value.value
                            case "CLANG_WARN_BOOL_CONVERSION":
                                xcBuildConfiguration.clangWarnBoolConversion = kv.value.value
                            case "CLANG_WARN_COMMA":
                                xcBuildConfiguration.clangWarnComma = kv.value.value
                            case "CLANG_WARN_CONSTANT_CONVERSION":
                                xcBuildConfiguration.clangWarnConstantConversion = kv.value.value
                            case "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS":
                                xcBuildConfiguration.clangWarnDeprecatedObjcImplementations = kv.value.value
                            case "CLANG_WARN_DIRECT_OBJC_ISA_USAGE":
                                xcBuildConfiguration.clangWarnDirectObjcIsaUsage = kv.value.value
                            case "CLANG_WARN_DOCUMENTATION_COMMENTS":
                                xcBuildConfiguration.clangWarnDocumentationComment = kv.value.value
                            case "CLANG_WARN_EMPTY_BODY":
                                xcBuildConfiguration.clangWarnEmptyBody = kv.value.value
                            case "CLANG_WARN_ENUM_CONVERSION":
                                xcBuildConfiguration.clangWarnEnumConversion = kv.value.value
                            case "CLANG_WARN_INFINITE_RECURSION":
                                xcBuildConfiguration.clangWarnInfiniteRecursion = kv.value.value
                            case "CLANG_WARN_INT_CONVERSION":
                                xcBuildConfiguration.clangWarnIntConversion = kv.value.value
                            case "CLANG_WARN_NON_LITERAL_NULL_CONVERSION":
                                xcBuildConfiguration.clangWarnNonLiteralNullConversion = kv.value.value
                            case "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF":
                                xcBuildConfiguration.clangWarnObjcImplicitRetainSelf = kv.value.value
                            case "CLANG_WARN_OBJC_LITERAL_CONVERSION":
                                xcBuildConfiguration.clangWarnObjcLiteralConversion = kv.value.value
                            case "CLANG_WARN_OBJC_ROOT_CLASS":
                                xcBuildConfiguration.clangWarnObjcRootClass = kv.value.value
                            case "CLANG_WARN_RANGE_LOOP_ANALYSIS":
                                xcBuildConfiguration.clangWarnRangeLoopAnalysis = kv.value.value
                            case "CLANG_WARN_STRICT_PROTOTYPES":
                                xcBuildConfiguration.clangWarnStrictPrototypes = kv.value.value
                            case "CLANG_WARN_SUSPICIOUS_MOVE":
                                xcBuildConfiguration.clangWarnSuspiciousMove = kv.value.value
                            case "CLANG_WARN_UNGUARDED_AVAILABILITY":
                                xcBuildConfiguration.clangWarnUnguardedAvailability = kv.value.value
                            case "CLANG_WARN_UNREACHABLE_CODE":
                                xcBuildConfiguration.clangWarnUnreachableCode = kv.value.value
                            case "CLANG_WARN__DUPLICATE_METHOD_MATCH":
                                xcBuildConfiguration.clangWarnDuplicateMethodMatch = kv.value.value
                            case "CODE_SIGN_IDENTITY":
                                xcBuildConfiguration.codeSignIdentity = kv.value.value
                            case "COPY_PHASE_STRIP":
                                xcBuildConfiguration.copyPhaseStrip = kv.value.value
                            case "DEBUG_INFORMATION_FORMAT":
                                xcBuildConfiguration.debugInformationFormat = kv.value.value
                            case "ENABLE_NS_ASSERTIONS":
                                xcBuildConfiguration.enableNsAssertions = kv.value.value
                            case "ENABLE_STRICT_OBJC_MSGSEND":
                                xcBuildConfiguration.enableStrictObjcMsgsend = kv.value.value
                            case "ENABLE_TESTABILITY":
                                xcBuildConfiguration.enableTestAbility = kv.value.value
                            case "GCC_C_LANGUAGE_STANDARD":
                                xcBuildConfiguration.gccCLanguageStandard = kv.value.value
                            case "GCC_DYNAMIC_NO_PIC":
                                xcBuildConfiguration.gccDynamicNoPic = kv.value.value
                            case "GCC_NO_COMMON_BLOCKS":
                                xcBuildConfiguration.gccNoCommonBLocks = kv.value.value
                            case "GCC_OPTIMIZATION_LEVEL":
                                xcBuildConfiguration.gccOptimizationLevel = kv.value.value
                            case "GCC_PREPROCESSOR_DEFINITIONS":
                                xcBuildConfiguration.gccPreprocessorDefinitions = valueToValueWithCommentArray(treeNode: kv.value)
                            case "GCC_WARN_64_TO_32_BIT_CONVERSION":
                                xcBuildConfiguration.gccWarn64To32BitConversion = kv.value.value
                            case "GCC_WARN_ABOUT_RETURN_TYPE":
                                xcBuildConfiguration.gccWarnAboutReturnType = kv.value.value
                            case "GCC_WARN_UNDECLARED_SELECTOR":
                                xcBuildConfiguration.gccWarnUndeclaredSelector = kv.value.value
                            case "GCC_WARN_UNINITIALIZED_AUTOS":
                                xcBuildConfiguration.gccWarnUninitializedAutos = kv.value.value
                            case "GCC_WARN_UNUSED_FUNCTION":
                                xcBuildConfiguration.gccWarnUnusedFunction = kv.value.value
                            case "GCC_WARN_UNUSED_VARIABLE":
                                xcBuildConfiguration.gccWarnUnusedVariable = kv.value.value
                            case "IPHONEOS_DEPLOYMENT_TARGET":
                                xcBuildConfiguration.iPhoneOSDeploymentTarget = kv.value.value
                            case "MTL_ENABLE_DEBUG_INFO":
                                xcBuildConfiguration.mtlEnableDebugInfo = kv.value.value
                            case "MTL_FAST_MATH":
                                xcBuildConfiguration.mtlFastMath = kv.value.value
                            case "ONLY_ACTIVE_ARCH":
                                xcBuildConfiguration.onlyActiveArch = kv.value.value
                            case "SDKROOT":
                                xcBuildConfiguration.sdkRoot = kv.value.value
                            case "VALIDATE_PRODUCT":
                                xcBuildConfiguration.validateProduct = kv.value.value
                            case "CODE_SIGN_STYLE":
                                xcBuildConfiguration.codeSignStyle = kv.value.value
                            case "INFOPLIST_FILE":
                                xcBuildConfiguration.infoPlistFile = kv.value.value
                            case "LD_RUNPATH_SEARCH_PATHS":
                                xcBuildConfiguration.ldRunPathSearchPath = valueToValueWithCommentArray(treeNode: kv.value)
                            case "PRODUCT_BUNDLE_IDENTIFIER":
                                xcBuildConfiguration.productBundleIdentifier = kv.value.value
                            case "PRODUCT_NAME":
                                xcBuildConfiguration.productName = kv.value.value
                            case "TARGETED_DEVICE_FAMILY":
                                xcBuildConfiguration.targetedDeviceFamily = kv.value.value
                            case "TEST_TARGET_NAME":
                                xcBuildConfiguration.testTargetName = kv.value.value
                            case "TEST_HOST":
                                xcBuildConfiguration.testHost = kv.value.value
                            case "BUNDLE_LOADER":
                                xcBuildConfiguration.bundleLoader = kv.value.value
                            case "ASSETCATALOG_COMPILER_APPICON_NAME":
                                xcBuildConfiguration.assetCatalogCompilerAppiconName = kv.value.value
                            default:
                                continue
                            } // end switch
                            continue
                        } // end for
                    default:
                        continue
                    } // end switch
                    continue
                } // end if
                
                // MARK:PBXVariantGroup
                if currentStepType == .PBXVariantGroup {
                    switch key.name {
                    case "children":
                        variantGroup.children = valueToValueWithCommentArray(treeNode: value)
                    case "name":
                        variantGroup.name = value.value
                    case "sourceTree":
                        variantGroup.sourceTree = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXTargetDependency
                if currentStepType == .PBXTargetDependency {
                    switch key.name {
                    case "target":
                        targetDependency.target = PBXValueWithComment(name: value.comment, value: value.value)
                    case "targetProxy":
                        targetDependency.targetProxy = PBXValueWithComment(name: value.comment, value: value.value)
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXSourcesBuildPhase
                if currentStepType == .PBXSourcesBuildPhase {
                    switch key.name {
                    case "buildActionMask":
                        sourcesBuildPhase.buildActionMask = value.value
                    case "files":
                        sourcesBuildPhase.files = valueToValueWithCommentArray(treeNode: value)
                    case "runOnlyForDeploymentPostprocessing":
                        sourcesBuildPhase.runOnlyForDeploymentPostprocessing = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXResourcesBuildPhase
                if currentStepType == .PBXResourcesBuildPhase {
                    switch key.name {
                    case "buildActionMask":
                        resourcesBuildPhase.buildActionMask = value.value
                    case "files":
                        resourcesBuildPhase.files = valueToValueWithCommentArray(treeNode: value)
                    case "runOnlyForDeploymentPostprocessing":
                        resourcesBuildPhase.runOnlyForDeploymentPostprocessing = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXProject
                if currentStepType == .PBXProject {
                    switch key.name {
                    case "attributes":
                        project.attributes = value.kvs
                    case "buildConfigurationList":
                        project.buildConfigurationList = PBXValueWithComment(name: value.comment, value: value.value)
                    case "compatibilityVersion":
                        project.compatibilityVersion = value.value
                    case "developmentRegion":
                        project.developmentRegion = value.value
                    case "hasScannedForEncodings":
                        project.hasScannedForEncodings = value.value
                    case "knownRegions":
                        project.knowRegions = valueToValueWithCommentArray(treeNode: value)
                    case "mainGroup":
                        project.mainGroup = value.value
                    case "productRefGroup":
                        project.productRefGroup = PBXValueWithComment(name: value.comment, value: value.value)
                    case "projectDirPath":
                        project.projectDirPath = value.value
                    case "projectRoot":
                        project.projectRoot = value.value
                    case "targets":
                        project.targets = valueToValueWithCommentArray(treeNode: value)
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXNativeTarget
                if currentStepType == .PBXNativeTarget {
                    switch key.name {
                    case "buildConfigurationList":
                        nativeTarget.buildConfigurationList = PBXValueWithComment(name: value.comment, value: value.value)
                    case "buildPhases":
                        nativeTarget.buildPhases = valueToValueWithCommentArray(treeNode: value)
                    case "buildRules":
                        nativeTarget.buildRules = valueToValueWithCommentArray(treeNode: value)
                    case "dependencies":
                        nativeTarget.dependencies = valueToValueWithCommentArray(treeNode: value)
                    case "name":
                        nativeTarget.name = value.value
                    case "productName":
                        nativeTarget.productName = value.value
                    case "productReference":
                        nativeTarget.productReference = PBXValueWithComment(name: value.comment, value: value.value)
                    case "productType":
                        nativeTarget.productType = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXGroup
                if currentStepType == .PBXGroup {
                    switch key.name {
                    case "children":
                        group.children = valueToValueWithCommentArray(treeNode: value)
                    case "sourceTree":
                        group.sourceTree = value.value
                    case "name":
                        group.name = value.value
                    case "path":
                        group.path = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXFrameworksBuildPhase
                if currentStepType == .PBXFrameworksBuildPhase {
                    switch key.name {
                    case "buildActionMask":
                        frameworksBuildPhase.buildActionMask = value.value
                    case "files":
                        frameworksBuildPhase.files = valueToValueWithCommentArray(treeNode: value)
                    case "runOnlyForDeploymentPostprocessing":
                        frameworksBuildPhase.runOnlyForDeploymentPostprocessing = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXFileReference
                if currentStepType == .PBXFileReference {
                    switch key.name {
                    case "explicitFileType":
                        fileReference.explicitFileType = value.value
                    case "includeInIndex":
                        fileReference.includeInIndex = value.value
                    case "path":
                        fileReference.path = value.value
                    case "sourceTree":
                        fileReference.sourceTree = value.value
                    case "lastKnownFileType":
                        fileReference.lastKnownFileType = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXContainerItemProxy
                if currentStepType == .PBXContainerItemProxy {
                    switch key.name {
                    case "containerPortal":
                        containerItemProxy.containerPortal = value.value
                    case "proxyType":
                        containerItemProxy.proxyType = value.value
                    case "remoteGlobalIDString":
                        containerItemProxy.remoteGlobalIDString = value.value
                    case "remoteInfo":
                        containerItemProxy.remoteInfo = value.value
                    default:
                        continue
                    }
                    continue
                }
                
                // MARK:PBXBuildFile
                // 设置 PBXBuildFile 数据
                if currentStepType == .PBXBuildFile {
                    switch key.name {
                    case "fileRef":
                        buildFile.file = value.comment
                        buildFile.fileRef = value.value
                    default:
                        continue
                    }
                    continue
                } // end if
                
            } // end for kv.value.kvs
            
            // MARK:添加到 Proj 里
            switch currentStepType {
            case .PBXBuildFile:
                proj.pbxBuildFile[kv.key.name] = buildFile
            case .PBXContainerItemProxy:
                proj.pbxContainerItemProxy[kv.key.name] = containerItemProxy
            case .PBXFileReference:
                proj.pbxFileReference[kv.key.name] = fileReference
            case .PBXFrameworksBuildPhase:
                proj.pbxFrameworksBuildPhase[kv.key.name] = frameworksBuildPhase
            case .PBXGroup:
                proj.pbxGroup[kv.key.name] = group
            case .PBXNativeTarget:
                proj.pbxNativeTarget[kv.key.name] = nativeTarget
            case .PBXProject:
                proj.pbxProject[kv.key.name] = project
            case .PBXResourcesBuildPhase:
                proj.pbxResourcesBuildPhase[kv.key.name] = resourcesBuildPhase
            case .PBXSourcesBuildPhase:
                proj.pbxSourcesBuildPhase[kv.key.name] = sourcesBuildPhase
            case .PBXTargetDependency:
                proj.pbxTargetDependency[kv.key.name] = targetDependency
            case .PBXVariantGroup:
                proj.pbxVariantGroup[kv.key.name] = variantGroup
            case .XCBuildConfiguration:
                proj.xcBuildConfiguration[kv.key.name] = xcBuildConfiguration
            case .XCConfigurationList:
                proj.xcConfigurationList[kv.key.name] = xcConfigurationList
            default:
                continue
            } // end switch
        } // end for kvs
        
    } // end func parseObjects
    
    // Private
    // MARK:value 转数组
    private func valueToValueWithCommentArray(treeNode:XcodeprojTreeNode) -> [PBXValueWithComment] {
        var valueWithComments = [PBXValueWithComment]()
        for v in treeNode.arr {
            valueWithComments.append(PBXValueWithComment(name: v.comment, value: v.name))
        }
        return valueWithComments
    }
    
} // end class ParseXcodeprojSection





