//
//  TestXcodeWorkspace.swift
//  SA
//
//  Created by ming on 2019/9/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class TestXML: Test {
    
    // MARK: Subscription
    public static func testSubscription() {
        let sPath = Bundle.main.path(forResource: "subscriptionSimple", ofType: "xml")
        let subscriptionPath = sPath ?? ""
        
        let sContent = FileHandle.fileContent(path: subscriptionPath)
        let root = ParseStandXML(input: sContent).parse()
        
        // check list 用来检查是否完整
        var checkList = [
            "title": false,
            "link1": false,
            "link2": false,
            "updated": false,
            "id": false,
            "author": false,
            "generator": false,
            "entry_title": false,
            "entry_link": false,
            "entry_id": false,
            "entry_published": false,
            "entry_updated": false,
            "entry_content": false,
            "entry_summary": false,
            "entry_category1": false,
            "entry_category2": false,
            "entry_category3": false,
        ] as [String : Bool]
        
        // root 检查具体项是否准确
        cs(current: "\(root.subNodes.count)", expect: "2", des: "root.subNodes.count")
        for rootNode in root.subNodes {
            // feed
            if rootNode.name == "feed" {
                cs(current: "\(rootNode.subNodes.count)", expect: "8", des: "feed subNodes.count")
                var linkCount = 0
                for feedNode in rootNode.subNodes {
                    
                    if feedNode.name == "title" {
                        cs(current: feedNode.value, expect: "星光社 - 戴铭的博客", des: "title")
                        checkList["title"] = true
                        continue
                    }
                    
                    if feedNode.name == "link" {
                        if linkCount == 0 {
                            for at in feedNode.attributes {
                                if at.name == "href" {
                                    cs(current: at.value, expect: "/atom.xml", des: "link 0 href value")
                                    checkList["link1"] = true
                                }
                                if at.name == "rel" {
                                    cs(current: at.value, expect: "self", des: "link 0 rel value")
                                    checkList["link1"] = true
                                }
                            }
                        } // end link count
                        if linkCount == 1 {
                            for at in feedNode.attributes {
                                if at.name == "href" {
                                    cs(current: at.value, expect: "http://ming1016.github.io/", des: "link 1 href value")
                                    checkList["link2"] = true
                                }
                            }
                        }
                        linkCount += 1
                        continue
                    } // end if link
                    
                    if feedNode.name == "updated" {
                        cs(current: feedNode.value, expect: "2019-07-28T16:52:44.082Z", des: "update")
                        checkList["updated"] = true
                        continue
                    }
                    if feedNode.name == "id" {
                        cs(current: feedNode.value, expect: "http://ming1016.github.io/", des: "id")
                        checkList["id"] = true
                        continue
                    }
                    if feedNode.name == "author" {
                        cs(current: "\(feedNode.subNodes.count)", expect: "1", des: "author subNodes.count")
                        cs(current: feedNode.subNodes[0].value, expect: "戴铭", des: "author name value")
                        checkList["author"] = true
                        continue
                    }
                    if feedNode.name == "generator" {
                        for at in feedNode.attributes {
                            if at.name == "uri" {
                                cs(current: at.value, expect: "http://hexo.io/", des: "generator uri")
                                checkList["generator"] = true
                            }
                        }
                        cs(current: feedNode.value, expect: "Hexo", des: "generator value")
                        checkList["generator"] = true
                        continue
                    }
                    if feedNode.name == "entry" {
                        for entryNode in feedNode.subNodes {
                            if entryNode.name == "title" {
                                cs(current: entryNode.value, expect: "iOS 开发舆图", des: "entry title")
                                checkList["entry_title"] = true
                                continue
                            }
                            if entryNode.name == "link" {
                                for at in entryNode.attributes {
                                    if at.name == "href" {
                                        cs(current: at.value, expect: "http://ming1016.github.io/2019/07/29/ios-map/", des: "entry link href")
                                        checkList["entry_link"] = true
                                    }
                                }
                                continue
                            }
                            if entryNode.name == "id" {
                                cs(current: entryNode.value, expect: "http://ming1016.github.io/2019/07/29/ios-map/", des: "entry id")
                                checkList["entry_id"] = true
                                continue
                            }
                            if entryNode.name == "published" {
                                cs(current: entryNode.value, expect: "2019-07-29T04:49:06.000Z", des: "entry published")
                                checkList["entry_published"] = true
                                continue
                            }
                            if entryNode.name == "updated" {
                                cs(current: entryNode.value, expect: "2019-07-28T16:52:44.082Z", des: "entry updated")
                                checkList["entry_updated"] = true
                                continue
                            }
                            if entryNode.name == "content" {
                                for at in entryNode.attributes {
                                    if at.name == "type" {
                                        cs(current: at.value, expect: "html", des: "entry content type")
                                        checkList["entry_content"] = true
                                    }
                                }
                                
                                let entryNodeContent = """
<p>43篇 <a href=\"https://time.geekbang.org/column/intro/161\" target=\"_blank\" rel=\"external\">《iOS开发高手课》</a>已完成，后面会对内容进行迭代，丰富下内容和配图。最近画了张 iOS 开发全景舆图，还有相关一些资料整理，方便我平时开发 App 时参看。舆图如下：</p><p><img src=\"/uploads/ios-map/1.png\" alt=\"\"><br><img src=\"/uploads/ios-map/2.png\" alt=\"\"><br><img src=\"/uploads/ios-map/3.png\" alt=\"\"><br><img src=\"/uploads/ios-map/4.png\" alt=\"\"><br><img src=\"/uploads/ios-map/5.png\" alt=\"\"><br><img src=\"/uploads/ios-map/6.png\" alt=\"\"></p><p>接下来，我按照 iOS 开发地图的顺序，和你推荐一些相关的学习资料。</p><h2 id=\"实例\"><a href=\"#实例\" class=\"headerlink\" title=\"实例\"></a>实例</h2><p>学习 iOS 开发最好是从学习一个完整的 App 入手，GitHub上的<a href=\"https://github.com/dkhamsing/open-source-ios-apps\" target=\"_blank\" rel=\"external\">Open-Source iOS Apps</a><br>项目，收录了大量开源的完整 App 例子，比如 <a href=\"https://github.com/Dimillian/SwiftHN\" target=\"_blank\" rel=\"external\">Hacker News Reader</a> 等已经上架了 App Store 的应用程序，所有例子都会标注是否上架 App Store的、所使用开发语言、推荐等级等信息，有利于进行选择学习。</p>
"""
                                cs(current: entryNode.value, expect: entryNodeContent, des: "entry content value")
                                checkList["entry_content"] = true
                                continue
                            }
                            if entryNode.name == "summary" {
                                for at in entryNode.attributes {
                                    if at.name == "type" {
                                        cs(current: at.value, expect: "html", des: "entry summary type")
                                    }
                                }
                                let entryNodeSummaryValue = """
&lt;p&gt;43篇 &lt;a href=&quot;https://time.geekbang.org/column/intro/161&quot; target=&quot;_blank&quot; rel=&quot;external&quot;&gt;《iOS开发高手课》&lt;/a&gt;已完成，后面会对内容进行迭代，丰富下内容和配图。最近画了张 iOS 开
"""
                                cs(current: entryNode.value, expect: entryNodeSummaryValue, des: "entry summary value")
                                checkList["entry_summary"] = true
                                continue
                            }
                            
                            if entryNode.name == "category" {
                                for at in entryNode.attributes {
                                    if at.name == "term" {
                                        if at.value == "Programming" {
                                            checkList["entry_category1"] = true
                                        }
                                        if at.value == "iOS" {
                                            checkList["entry_category2"] = true
                                        }
                                        if at.value == "Swift" {
                                            checkList["entry_category3"] = true
                                        }
                                    } // end if
                                } // end for
                            } // end if category
                            
                        } // end for entryNode in feedNode.subNodes
                        continue
                    } // end if feed
                    
                    
                    
                    
                } // end rootNode subNodes
            } // end if feed
            
        } // end root subNodes
        
        // 检查 checklist 是否完整
        for (k,v) in checkList {
            if v == false {
                fatalError("❌ \(k) checklist no pass")
            }
        }
        
    } // end func
    
    
    // MARK: XcodeWorkspace
    public static func testXcodeWorkspace() {
        let workspacePath = Bundle.main.path(forResource: "contents", ofType: "xcworkspacedata")
        let wPath = workspacePath ?? ""
        
        let wContent = FileHandle.fileContent(path: wPath)
        let root = ParseStandXML(input: wContent).parse()
        
        cs(current: "\(root.subNodes.count)", expect: "2", des: "root.subNodes.count")
        for i in 0..<root.subNodes.count {
            let node = root.subNodes[i]
            if i == 0 {
                cs(current: node.name, expect: "xml", des: "0 name")
                cs(current: "\(node.attributes.count)", expect: "2", des: "0 attributes.count")
                
                var abString = ""
                for ab in node.attributes {
                    abString.append("\(ab.name)\(ab.value)")
                }
                let expectAbString = "version1.0encodingUTF-8"
                cs(current: abString, expect: expectAbString, des: "0 attributes")
                cs(current: node.value, expect: "", des: "0 value")
                cs(current: "\(node.subNodes.count)", expect: "0", des:     "0 subNodes")
            } // end if
            
            if i == 1 {
                cs(current: node.name, expect: "Workspace", des: "1 name")
                cs(current: "\(node.attributes.count)", expect: "1", des: "1 attributes.count")
                
                var abString = ""
                for ab in node.attributes {
                    abString.append("\(ab.name)\(ab.value)")
                }
                let expectAbString = "version1.0"
                cs(current: abString, expect: expectAbString, des: "1 attributes")
                cs(current: node.value, expect: "", des: "1 value")
                cs(current: "\(node.subNodes.count)", expect: "2", des: "1 subNodes")
                for j in 0..<node.subNodes.count {
                    let jNode = node.subNodes[j]
                    if j == 0 {
                        cs(current: jNode.name, expect: "FileRef", des: "j0 name")
                        cs(current: "\(jNode.attributes.count)", expect: "1", des: "j0 attributes.count")
                        var jAbString = ""
                        for jAb in jNode.attributes {
                            jAbString.append("\(jAb.name)\(jAb.value)")
                        }
                        print(jAbString)
                        let expectJAbString = "locationgroup:GCDFetchFeed.xcodeproj"
                        cs(current: jAbString, expect: expectJAbString, des: "j0 attributes")
                        cs(current: "\(jNode.subNodes.count)", expect: "0", des: "j0 subNodes.count")
                    }
                    if j == 1 {
                        cs(current: jNode.name, expect: "FileRef", des: "j1 name")
                        cs(current: "\(jNode.attributes.count)", expect: "1", des: "j1 attributes.count")
                        var jAbString = ""
                        for jAb in jNode.attributes {
                            jAbString.append("\(jAb.name)\(jAb.value)")
                        }
                        print(jAbString)
                        let expectJAbString = "locationgroup:Pods/Pods.xcodeproj"
                        cs(current: jAbString, expect: expectJAbString, des: "j1 attributes")
                        cs(current: jNode.value, expect: "testValue", des: "j1 value")
                        cs(current: "\(jNode.subNodes.count)", expect: "0", des: "j1 subNodes.count")
                    }
                }
                
            }
            
        } // end for

    }

}
