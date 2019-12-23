//
//  TestXcodeproj.swift
//  SA
//
//  Created by ming on 2019/9/19.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class TestXcodeproj:Test {
    
    // 测试用例，使用 project.pbxproj 原始数据和 生成的 projectSection.txt 结果对比是否一致
    public static func testSection() {
        let projectOPath = Bundle.main.path(forResource: "project", ofType: "pbxproj")
        let pOrgPath = projectOPath ?? ""
        
        let projectOContent = FileHandle.fileContent(path: pOrgPath)
        let pSection = ParseXcodeprojSection(input: projectOContent)
        print(pSection.desProj())
        
        let proj = pSection.parse()
        
        cs(current: proj.archiveVersion, expect: "1", des: "archiveVersion")
        cs(current: proj.objectVersion, expect: "50", des: "objectVersion")
        cs(current: proj.rootObject.value, expect: "3AF0A7B9231E61B30080E07C", des: "rootObject.value")
        
        cs(current: "\(proj.pbxBuildFile.count)", expect: "8", des: "pbxBuildFile.count")
        // 渲染判断下首尾
        for (k,v) in proj.pbxBuildFile {
            if k == "3AF0A7C6231E61B30080E07C" {
                cs(current: v.file, expect: " AppDelegate.m ", des: "3AF0A7C6231E61B30080E07C file")
                cs(current: v.fileRef, expect: "3AF0A7C5231E61B30080E07C", des: "3AF0A7C6231E61B30080E07C fileRef")
            }
            if k == "3AF0A7E9231E61B50080E07C" {
                cs(current: v.file, expect: " SampleProjectUITests.m ", des: "3AF0A7E9231E61B50080E07C file")
                cs(current: v.fileRef, expect: "3AF0A7E8231E61B50080E07C", des: "3AF0A7E9231E61B50080E07C fileRef")
            }
        }
        
        cs(current: "\(proj.pbxContainerItemProxy.count)", expect: "2", des: "pbxContainerItemProxy.count")
        for (k,v) in proj.pbxContainerItemProxy {
            if k == "3AF0A7DA231E61B50080E07C" {
                cs(current: v.containerPortal, expect: "3AF0A7B9231E61B30080E07C", des: "3AF0A7DA231E61B50080E07C containerPortal")
                cs(current: v.proxyType, expect: "1", des: "3AF0A7DA231E61B50080E07C proxyType")
                cs(current: v.remoteGlobalIDString, expect: "3AF0A7C0231E61B30080E07C", des: "3AF0A7DA231E61B50080E07C remoteGlobalIDString")
                cs(current: v.remoteInfo, expect: "SampleProject", des: "3AF0A7DA231E61B50080E07C remoteInfo")
            }
            if k == "3AF0A7E5231E61B50080E07C" {
                cs(current: v.containerPortal, expect: "3AF0A7B9231E61B30080E07C", des: "3AF0A7E5231E61B50080E07C containerPortal")
                cs(current: v.proxyType, expect: "1", des: "3AF0A7E5231E61B50080E07C proxyType")
                cs(current: v.remoteGlobalIDString, expect: "3AF0A7C0231E61B30080E07C", des: "3AF0A7E5231E61B50080E07C remoteGlobalIDString")
                cs(current: v.remoteInfo, expect: "SampleProject", des: "3AF0A7E5231E61B50080E07C remoteInfo")
            }
        } // end for
        
        cs(current: "\(proj.pbxFileReference.count)", expect: "16", des: "pbxFileReference.count")
        for (k,v) in proj.pbxFileReference {
            if k == "3AF0A7C1231E61B30080E07C" {
                cs(current: v.explicitFileType, expect: "wrapper.application", des: "3AF0A7C1231E61B30080E07C explicitFileType")
                cs(current: v.includeInIndex, expect: "0", des: "3AF0A7C1231E61B30080E07C includeInIndex")
                cs(current: v.path, expect: "SampleProject.app", des: "3AF0A7C1231E61B30080E07C path")
                cs(current: v.sourceTree, expect: "BUILT_PRODUCTS_DIR", des: "3AF0A7C1231E61B30080E07C sourceTree")
            }
            if k == "3AF0A7EA231E61B50080E07C" {
                cs(current: v.lastKnownFileType, expect: "text.plist.xml", des: "3AF0A7EA231E61B50080E07C lastKnownFileType")
                cs(current: v.path, expect: "Info.plist", des: "3AF0A7EA231E61B50080E07C path")
                cs(current: v.sourceTree, expect: "<group>", des: "3AF0A7EA231E61B50080E07C sourceTree")
            }
        } // end for
        
        cs(current: "\(proj.pbxFrameworksBuildPhase.count)", expect: "3", des: "pbxFrameworksBuildPhase.count")
        for (k,v) in proj.pbxFrameworksBuildPhase {
            if k == "3AF0A7BE231E61B30080E07C" {
                cs(current: v.buildActionMask, expect: "2147483647", des: "3AF0A7BE231E61B30080E07C buildActionMask")
                cs(current: v.runOnlyForDeploymentPostprocessing, expect: "0", des: "3AF0A7BE231E61B30080E07C runOnlyForDeploymentPostprocessing")
            }
            if k == "3AF0A7E1231E61B50080E07C" {
                cs(current: v.buildActionMask, expect: "2147483647", des: "3AF0A7E1231E61B50080E07C buildActionMask")
                cs(current: v.runOnlyForDeploymentPostprocessing, expect: "0", des: "3AF0A7E1231E61B50080E07C runOnlyForDeploymentPostprocessing")
            }
        } // end for
        
        cs(current: "\(proj.pbxGroup.count)", expect: "5", des: "pbxGroup.count")
        for (k,v) in proj.pbxGroup {
            if k == "3AF0A7B8231E61B30080E07C" {
                var childrenString = ""
                for child in v.children {
                    childrenString.append("\(child.name)\(child.value)")
                }
                let expectString = """
 SampleProject 3AF0A7C3231E61B30080E07C SampleProjectTests 3AF0A7DC231E61B50080E07C SampleProjectUITests 3AF0A7E7231E61B50080E07C Products 3AF0A7C2231E61B30080E07C
"""
                cs(current: childrenString, expect: expectString, des: "3AF0A7B8231E61B30080E07C children")
                cs(current: v.sourceTree, expect: "<group>", des: "3AF0A7B8231E61B30080E07C sourceTree")
            }
            if k == "3AF0A7E7231E61B50080E07C" {
                var childrenString = ""
                for child in v.children {
                    childrenString.append("\(child.name)\(child.value)")
                }
                let expectString = """
 SampleProjectUITests.m 3AF0A7E8231E61B50080E07C Info.plist 3AF0A7EA231E61B50080E07C
"""
                cs(current: childrenString, expect: expectString, des: "3AF0A7E7231E61B50080E07C children")
                cs(current: v.sourceTree, expect: "<group>", des: "3AF0A7E7231E61B50080E07C sourceTree")
                print(childrenString)
            } // end if
        } // end for
        
        cs(current: "\(proj.pbxNativeTarget.count)", expect: "3", des: "pbxNativeTarget.count")
        for (k,v) in proj.pbxNativeTarget {
            if k == "3AF0A7C0231E61B30080E07C" {
                cs(current: v.buildConfigurationList.value, expect: "3AF0A7ED231E61B50080E07C", des: "3AF0A7C0231E61B30080E07C buildConfigurationList.value")
                var bpString = ""
                for bp in v.buildPhases {
                    bpString.append("\(bp.name)\(bp.value)")
                }
                let bpExpect = """
 Sources 3AF0A7BD231E61B30080E07C Frameworks 3AF0A7BE231E61B30080E07C Resources 3AF0A7BF231E61B30080E07C
"""
                cs(current: bpString, expect: bpExpect, des: "3AF0A7C0231E61B30080E07C buildPhases")
                cs(current: v.name, expect: "SampleProject", des: "3AF0A7C0231E61B30080E07C name")
                cs(current: v.productName, expect: "SampleProject", des: "3AF0A7C0231E61B30080E07C productName")
                cs(current: v.productReference.value, expect: "3AF0A7C1231E61B30080E07C", des: "3AF0A7C0231E61B30080E07C productReference.value")
                cs(current: v.productType, expect: "com.apple.product-type.application", des: "3AF0A7C0231E61B30080E07C productType")
            } // end if
        } // end for
        
        cs(current: "\(proj.pbxProject.count)", expect: "1", des: "pbxProject.count")
        for (k,v) in proj.pbxProject {
            if k == "3AF0A7B9231E61B30080E07C" {
                cs(current: v.buildConfigurationList.value, expect: "3AF0A7BC231E61B30080E07C", des: "3AF0A7B9231E61B30080E07C buildConfigurationList.value")
                cs(current: v.compatibilityVersion, expect: "Xcode 9.3", des: "3AF0A7B9231E61B30080E07C compatibilityVersion")
                cs(current: v.developmentRegion, expect: "en", des: "3AF0A7B9231E61B30080E07C developmentRegion")
                cs(current: v.hasScannedForEncodings, expect: "0", des: "3AF0A7B9231E61B30080E07C hasScannedForEncodings")
                
                var krString = ""
                for kr in v.knowRegions {
                    krString.append("\(kr.name)\(kr.value)")
                }
                let expectString = "enBase"
                cs(current: krString, expect: expectString, des: "3AF0A7B9231E61B30080E07C knowRegions")
                
                cs(current: v.mainGroup, expect: "3AF0A7B8231E61B30080E07C", des: "3AF0A7B9231E61B30080E07C mainGroup")
                cs(current: v.productRefGroup.value, expect: "3AF0A7C2231E61B30080E07C", des: "3AF0A7B9231E61B30080E07C productRefGroup.value")
                
                var tgString = ""
                for tg in v.targets {
                    tgString.append("\(tg.name)\(tg.value)")
                }
                let expectTgString = """
 SampleProject 3AF0A7C0231E61B30080E07C SampleProjectTests 3AF0A7D8231E61B50080E07C SampleProjectUITests 3AF0A7E3231E61B50080E07C
"""
                cs(current: tgString, expect: expectTgString, des: "3AF0A7B9231E61B30080E07C targets")
            } // end if
        } // end for
        
        cs(current: "\(proj.pbxResourcesBuildPhase.count)", expect: "3", des: "pbxResourcesBuildPhase.count")
        for (k,v) in proj.pbxResourcesBuildPhase {
            if k == "3AF0A7BF231E61B30080E07C" {
                cs(current: v.buildActionMask, expect: "2147483647", des: "3AF0A7BF231E61B30080E07C buildActionMask")
                
                var fString = ""
                for f in v.files {
                    fString.append("\(f.name)\(f.value)")
                }
                let expectFString = """
 LaunchScreen.storyboard in Resources 3AF0A7D1231E61B50080E07C Assets.xcassets in Resources 3AF0A7CE231E61B50080E07C Main.storyboard in Resources 3AF0A7CC231E61B30080E07C
"""
                cs(current: fString, expect: expectFString, des: "3AF0A7BF231E61B30080E07C files")
                
                cs(current: v.runOnlyForDeploymentPostprocessing, expect: "0", des: "3AF0A7BF231E61B30080E07C runOnlyForDeploymentPostprocessing")
            } // end if
        } // end for
        
        cs(current: "\(proj.pbxSourcesBuildPhase.count)", expect: "3", des: "pbxSourcesBuildPhase.count")
        for (k,v) in proj.pbxSourcesBuildPhase {
            if k == "3AF0A7BD231E61B30080E07C" {
                cs(current: v.buildActionMask, expect: "2147483647", des: "3AF0A7BD231E61B30080E07C buildActionMask")
            }
        }
        
        cs(current: "\(proj.pbxTargetDependency.count)", expect: "2", des: "proj.pbxTargetDependency.count")
        for (k,v) in proj.pbxTargetDependency {
            if k == "3AF0A7DB231E61B50080E07C" {
                cs(current: v.target.value, expect: "3AF0A7C0231E61B30080E07C", des: "3AF0A7DB231E61B50080E07C target.value")
                cs(current: v.targetProxy.value, expect: "3AF0A7DA231E61B50080E07C", des: "3AF0A7DB231E61B50080E07C targetProxy.value")
            }
            if k == "3AF0A7E6231E61B50080E07C" {
                cs(current: v.target.value, expect: "3AF0A7C0231E61B30080E07C", des: "3AF0A7E6231E61B50080E07C target.value")
                cs(current: v.targetProxy.value, expect: "3AF0A7E5231E61B50080E07C", des: "3AF0A7E6231E61B50080E07C targetProxy.value")
            } // end if
        } // end for
        
        cs(current: "\(proj.pbxVariantGroup.count)", expect: "2", des: "pbxVariantGroup.count")
        for (k,v) in proj.pbxVariantGroup {
            if k == "3AF0A7CA231E61B30080E07C" {
                var cString = ""
                for c in v.children {
                    cString.append("\(c.value)\(c.name)")
                }
                let expectCString = "3AF0A7CB231E61B30080E07C Base "
                cs(current: cString, expect: expectCString, des: "3AF0A7CA231E61B30080E07C children")
                cs(current: v.name, expect: "Main.storyboard", des: "3AF0A7CA231E61B30080E07C name")
                cs(current: v.sourceTree, expect: "<group>", des: "3AF0A7CA231E61B30080E07C sourceTree")
            }
            if k == "3AF0A7CF231E61B50080E07C" {
                var cString = ""
                for c in v.children {
                    cString.append("\(c.value)\(c.name)")
                }
                let expectCString = "3AF0A7D0231E61B50080E07C Base "
                cs(current: cString, expect: expectCString, des: "3AF0A7CF231E61B50080E07C children")
                cs(current: v.name, expect: "LaunchScreen.storyboard", des: "3AF0A7CF231E61B50080E07C name")
                cs(current: v.sourceTree, expect: "<group>", des: "3AF0A7CF231E61B50080E07C sourceTree")
            } // end if
        } // end for
        
        cs(current: "\(proj.xcBuildConfiguration.count)", expect: "8", des: "xcBuildConfiguration.count")
        for (k,v) in proj.xcBuildConfiguration {
            if k == "3AF0A7EB231E61B50080E07C" {
                cs(current: v.alwaysSearchUserPaths, expect: "NO", des: "3AF0A7EB231E61B50080E07C alwaysSearchUserPaths")
                cs(current: v.clangAnalyzerNonnull, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangAnalyzerNonnull")
                cs(current: v.clangAnalyzerNumberObjectConversion, expect: "YES_AGGRESSIVE", des: "3AF0A7EB231E61B50080E07C clangAnalyzerNumberObjectConversion")
                cs(current: v.clangCxxLanguageStandard, expect: "gnu++14", des: "3AF0A7EB231E61B50080E07C clangCxxLanguageStandard")
                cs(current: v.clangCxxLibrary, expect: "libc++", des: "3AF0A7EB231E61B50080E07C clangCxxLibrary")
                cs(current: v.clangEnableModules, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangEnableModules")
                cs(current: v.clangEnableObjcArc, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangEnableObjcArc")
                cs(current: v.clangEnableObjcWeak, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangEnableObjcWeak")
                cs(current: v.clangWarnBlockCaptureAutoreleasing, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnBlockCaptureAutoreleasing")
                cs(current: v.clangWarnBoolConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnBoolConversion")
                cs(current: v.clangWarnComma, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnComma")
                cs(current: v.clangWarnConstantConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnConstantConversion")
                cs(current: v.clangWarnDeprecatedObjcImplementations, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnDeprecatedObjcImplementations")
                cs(current: v.clangWarnDirectObjcIsaUsage, expect: "YES_ERROR", des: "3AF0A7EB231E61B50080E07C clangWarnDirectObjcIsaUsage")
                cs(current: v.clangWarnDocumentationComment, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnDocumentationComment")
                cs(current: v.clangWarnEmptyBody, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnEmptyBody")
                cs(current: v.clangWarnEnumConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnEnumConversion")
                cs(current: v.clangWarnInfiniteRecursion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnInfiniteRecursion")
                cs(current: v.clangWarnIntConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnIntConversion")
                cs(current: v.clangWarnNonLiteralNullConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnNonLiteralNullConversion")
                cs(current: v.clangWarnObjcImplicitRetainSelf, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnObjcImplicitRetainSelf")
                cs(current: v.clangWarnObjcLiteralConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnObjcLiteralConversion")
                cs(current: v.clangWarnObjcRootClass, expect: "YES_ERROR", des: "3AF0A7EB231E61B50080E07C clangWarnObjcRootClass")
                cs(current: v.clangWarnRangeLoopAnalysis, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnRangeLoopAnalysis")
                cs(current: v.clangWarnStrictPrototypes, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnStrictPrototypes")
                cs(current: v.clangWarnSuspiciousMove, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnSuspiciousMove")
                cs(current: v.clangWarnUnguardedAvailability, expect: "YES_AGGRESSIVE", des: "3AF0A7EB231E61B50080E07C clangWarnUnguardedAvailability")
                cs(current: v.clangWarnDuplicateMethodMatch, expect: "YES", des: "3AF0A7EB231E61B50080E07C clangWarnDuplicateMethodMatch")
                cs(current: v.codeSignIdentity, expect: "iPhone Developer", des: "3AF0A7EB231E61B50080E07C codeSignIdentity")
                cs(current: v.copyPhaseStrip, expect: "NO", des: "3AF0A7EB231E61B50080E07C copyPhaseStrip")
                cs(current: v.debugInformationFormat, expect: "dwarf", des: "3AF0A7EB231E61B50080E07C debugInformationFormat")
                cs(current: v.enableStrictObjcMsgsend, expect: "YES", des: "3AF0A7EB231E61B50080E07C enableStrictObjcMsgsend")
                cs(current: v.enableTestAbility, expect: "YES", des: "3AF0A7EB231E61B50080E07C enableTestAbility")
                cs(current: v.gccCLanguageStandard, expect: "gnu11", des: "3AF0A7EB231E61B50080E07C gccCLanguageStandard")
                cs(current: v.gccDynamicNoPic, expect: "NO", des: "3AF0A7EB231E61B50080E07C gccDynamicNoPic")
                cs(current: v.gccNoCommonBLocks, expect: "YES", des: "3AF0A7EB231E61B50080E07C gccNoCommonBLocks")
                cs(current: v.gccOptimizationLevel, expect: "0", des: "3AF0A7EB231E61B50080E07C gccOptimizationLevel")
                var gpdString = ""
                for gpd in v.gccPreprocessorDefinitions {
                    gpdString.append("\(gpd.value)")
                }
                let expectGpdString = "DEBUG=1$(inherited)"
                cs(current: gpdString, expect: expectGpdString, des: "3AF0A7EB231E61B50080E07C gccPreprocessorDefinitions")
                cs(current: v.gccWarn64To32BitConversion, expect: "YES", des: "3AF0A7EB231E61B50080E07C gccWarn64To32BitConversion")
                cs(current: v.gccWarnAboutReturnType, expect: "YES_ERROR", des: "3AF0A7EB231E61B50080E07C gccWarnAboutReturnType")
                cs(current: v.gccWarnUndeclaredSelector, expect: "YES", des: "3AF0A7EB231E61B50080E07C gccWarnUndeclaredSelector")
                cs(current: v.gccWarnUninitializedAutos, expect: "YES_AGGRESSIVE", des: "3AF0A7EB231E61B50080E07C gccWarnUninitializedAutos")
                cs(current: v.gccWarnUnusedFunction, expect: "YES", des: "3AF0A7EB231E61B50080E07C gccWarnUnusedFunction")
                cs(current: v.gccWarnUnusedVariable, expect: "YES", des: "3AF0A7EB231E61B50080E07C gccWarnUnusedVariable")
                cs(current: v.iPhoneOSDeploymentTarget, expect: "12.4", des: "3AF0A7EB231E61B50080E07C iPhoneOSDeploymentTarget")
                cs(current: v.mtlEnableDebugInfo, expect: "INCLUDE_SOURCE", des: "3AF0A7EB231E61B50080E07C mtlEnableDebugInfo")
                cs(current: v.mtlFastMath, expect: "YES", des: "3AF0A7EB231E61B50080E07C mtlFastMath")
                cs(current: v.onlyActiveArch, expect: "YES", des: "3AF0A7EB231E61B50080E07C onlyActiveArch")
                cs(current: v.sdkRoot, expect: "iphoneos", des: "3AF0A7EB231E61B50080E07C sdkRoot")
                cs(current: v.name, expect: "Debug", des: "3AF0A7EB231E61B50080E07C name")
            } // end if
            if k == "3AF0A7F5231E61B50080E07C" {
                cs(current: v.codeSignStyle, expect: "Automatic", des: "3AF0A7F5231E61B50080E07C codeSignStyle")
                cs(current: v.infoPlistFile, expect: "SampleProjectUITests/Info.plist", des: "3AF0A7F5231E61B50080E07C infoPlistFile")
                var lrspString = ""
                for lrsp in v.ldRunPathSearchPath {
                    lrspString.append("\(lrsp.value)")
                }
                let expectLrspString = "$(inherited)@executable_path/Frameworks@loader_path/Frameworks"
                cs(current: lrspString, expect: expectLrspString, des: "3AF0A7F5231E61B50080E07C ldRunPathSearchPath")
                cs(current: v.productBundleIdentifier, expect: "com.starming.SampleProjectUITests", des: "3AF0A7F5231E61B50080E07C productBundleIdentifier")
                cs(current: v.productName, expect: "$(TARGET_NAME)", des: "3AF0A7F5231E61B50080E07C productName")
                cs(current: v.targetedDeviceFamily, expect: "1,2", des: "3AF0A7F5231E61B50080E07C targetedDeviceFamily")
                cs(current: v.testTargetName, expect: "SampleProject", des: "3AF0A7F5231E61B50080E07C testTargetName")
                cs(current: v.name, expect: "Release", des: "3AF0A7F5231E61B50080E07C name")
            }
        } // end for
        
        cs(current: "\(proj.xcConfigurationList.count)", expect: "4", des: "xcConfigurationList.count")
        for (k,v) in proj.xcConfigurationList {
            if k == "3AF0A7BC231E61B30080E07C" {
                var bcString = ""
                for bc in v.buildConfigurations {
                    bcString.append("\(bc.name)\(bc.value)")
                }
                let expectBcString = " Debug 3AF0A7EB231E61B50080E07C Release 3AF0A7EC231E61B50080E07C"
                cs(current: bcString, expect: expectBcString, des: "3AF0A7BC231E61B30080E07C buildConfigurations")
                cs(current: v.defaultConfigurationIsVisible, expect: "0", des: "3AF0A7BC231E61B30080E07C defaultConfigurationIsVisible")
                cs(current: v.defaultConfigurationName, expect: "Release", des: "3AF0A7BC231E61B30080E07C defaultConfigurationName")
            } // end if
            if k == "3AF0A7F3231E61B50080E07C" {
                var bcString = ""
                for bc in v.buildConfigurations {
                    bcString.append("\(bc.name)\(bc.value)")
                }
                let expectBcString = " Debug 3AF0A7F4231E61B50080E07C Release 3AF0A7F5231E61B50080E07C"
                cs(current: bcString, expect: expectBcString, des: "3AF0A7F3231E61B50080E07C buildConfigurations")
                cs(current: v.defaultConfigurationIsVisible, expect: "0", des: "3AF0A7F3231E61B50080E07C defaultConfigurationIsVisible")
                cs(current: v.defaultConfigurationName, expect: "Release", des: "3AF0A7F3231E61B50080E07C defaultConfigurationName")
            }
            
        } // end for
        
        
    } //  end func
    
    
}
