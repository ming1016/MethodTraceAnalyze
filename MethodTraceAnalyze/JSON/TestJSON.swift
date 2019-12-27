//
//  TestJSON.swift
//  SA
//
//  Created by ming on 2019/10/25.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

public class TestJSON:Test {
    
    public static func testJSON() {
        let jsonOPath = Bundle.main.path(forResource: "test", ofType: "json")
        let jOrgPath = jsonOPath ?? ""
        
        let jsonOContent = FileHandle.fileContent(path: jOrgPath)
        
        let item = ParseJSONItem(input: jsonOContent).parse()
        
        let arr = item.array[0].kvs
        
        cs(current: "\(arr.count)", expect: "3", des: "all dic count")
        
        cs(current: "\(arr[0].key)", expect: "key1", des: "key1")
        cs(current: "\(arr[0].value.value)", expect: "value1", des: "value1")
        cs(current: "\(arr[1].key)", expect: "key2", des: "key2")
        cs(current: "\(arr[1].value.value)", expect: "22", des: "value2")
        cs(current: "\(arr[2].key)", expect: "key3", des: "key3")
        let arr2kvs = arr[2].value.kvs
        cs(current: "\(arr2kvs.count)", expect: "5", des: "arr2kvs count")
        cs(current: "\(arr2kvs[0].key)", expect: "subKey1", des: "subKey1")
        cs(current: "\(arr2kvs[0].value.value)", expect: "subValue1", des: "subValue1")
        cs(current: "\(arr2kvs[1].key)", expect: "subKey2", des: "subKey2")
        cs(current: "\(arr2kvs[1].value.value)", expect: "40", des: "subValue2")
        cs(current: "\(arr2kvs[2].key)", expect: "subKey3", des: "subKey3")
        let subValue3 = arr2kvs[2].value.array
        cs(current: "\(subValue3.count)", expect: "2", des: "subValue3 count")
        cs(current: "\(subValue3[0].kvs.count)", expect: "2", des: "subValue3 kvs count")
        let subValue30Kvs = subValue3[0].kvs
        cs(current: "\(subValue30Kvs[0].key)", expect: "sub1Key1", des: "sub1Key1")
        cs(current: "\(subValue30Kvs[0].value.value)", expect: "10", des: "sub1Key1 value")
        cs(current: "\(subValue30Kvs[1].key)", expect: "sub1Key2", des: "sub1Key2")
        let subValue30Kvs1ValueKvs = subValue30Kvs[1].value.kvs
        cs(current: "\(subValue30Kvs1ValueKvs.count)", expect: "2", des: "sub1Key2 value kvs count")
        cs(current: "\(subValue30Kvs1ValueKvs[0].key)", expect: "sub3Key1", des: "sub3Key1")
        cs(current: "\(subValue30Kvs1ValueKvs[0].value.value)", expect: "sub3Value1", des: "sub3Value1")
        cs(current: "\(subValue30Kvs1ValueKvs[1].key)", expect: "sub3Key2", des: "sub3Key2")
        cs(current: "\(subValue30Kvs1ValueKvs[1].value.value)", expect: "sub3Value2", des: "sub3Value2")
        
        let subValue31Kvs = subValue3[1].kvs
        cs(current: "\(subValue31Kvs[0].key)", expect: "sub1Key1", des: "subValue31Kvs sub1Key1")
        cs(current: "\(subValue31Kvs[0].value.value)", expect: "11", des: "subValue31Kvs sub1Key1 value")
        cs(current: "\(subValue31Kvs[1].key)", expect: "sub1Key2", des: "subValue31Kvs sub1Key2")
        cs(current: "\(subValue31Kvs[1].value.value)", expect: "15", des: "subValue31Kvs sub1Key2 value")
        
        cs(current: "\(arr2kvs[3].key)", expect: "subKey4", des: "subKey4")
        cs(current: "\(arr2kvs[3].value.array.count)", expect: "3", des: "subKey4 value array count")
        cs(current: "\(arr2kvs[3].value.array[0].value)", expect: "value1", des: "subKey4 value array 0 value")
        cs(current: "\(arr2kvs[3].value.array[1].value)", expect: "23", des: "subKey4 value array 1 value")
        cs(current: "\(arr2kvs[3].value.array[2].value)", expect: "value2", des: "subKey4 value array 2 value")
        
        cs(current: "\(arr2kvs[4].key)", expect: "subKey5", des: "subKey5")
        cs(current: "\(arr2kvs[4].value.value)", expect: "2", des: "subKey5 value")
        
    }
    
    public static func codeLines() {
        let jsonOld = FileHandle.fileContent(path: "/Users/ming/Downloads/data/CodeLines/1020_codelines.json")
        let jsonNew = FileHandle.fileContent(path: "/Users/ming/Downloads/data/CodeLines/1025_codelines.json")
        
        let itemOld = ParseJSONItem(input: jsonOld).parse()
        let itemNew = ParseJSONItem(input: jsonNew).parse()
        
        let oldBundles = itemOld.array[0].kvs[3].value.array
        let newBundles = itemNew.array[0].kvs[3].value.array
        
        var bizDic = [String:String]()
        
        func dicData(arr:[JSONItem]) -> [String:Int] {
            let filterTech = ["Java","ObjectiveC","ObjectiveC++","C/C++Header","C","C++","XML"]
            var dic = [String:Int]()
            
            for aBundle in arr {
                let bundleName = aBundle.kvs[0].value.value
                
                let biz = aBundle.kvs[1].value.value
                bizDic[bundleName] = biz
//                let bizDetail = aBundle.kvs[3].value.value
                let platform = aBundle.kvs[4].value.value
                
                if platform == "ios" || platform == "android" {
                    //
                } else {
                    continue
                }
//                print(bundleName)
                let classifys = aBundle.kvs[5].value.array
                for aClassify in classifys {
                    let kvs = aClassify.kvs
                    var code = 0
                    var name = ""
                    for akv in kvs {
                        if akv.key == "code" {
                            code = Int(akv.value.value) ?? 0
                        } else if akv.key == "name" {
                            name = akv.value.value
                        }
                        
                    }
//                    print("code:\(code) name:\(name)")
                    if filterTech.contains(name) {
                        if dic[bundleName] != nil {
                            dic[bundleName]! += code
                        } else {
                            dic[bundleName] = code
                        }
                    } // end if filterTech.contains(name)
                    
                } // end for aClassify in classifys
            } // end for aBundle in oldBundles
            return dic
        }
        
        let oldDic = dicData(arr: oldBundles)
        let newDic = dicData(arr: newBundles)
        
        var totalOld = 0
        for (_,v) in oldDic {
            totalOld += v
        }
        var totalNew = 0
        
        var moreBundle = ""
        var moreCode = [String:Int]()
        var lessCode = [String:Int]()
        var moreTotal = 0
        var lessTotal = 0
        for (k,v) in newDic {
            let kBiz = bizDic[k]
            let kDes = "\(k)[\(kBiz ?? "")]"
            totalNew += v
            if oldDic[k] == nil {
                moreBundle.append("新增：\(kDes) \(v)\r\n")
            } else {
                let oldValue = oldDic[k] ?? 0
                let diff = v - oldValue
                if diff > 0 {
                    moreCode["\(kDes)多了\(diff)"] = diff
                    moreTotal += diff
                } else if diff < 0 {
                    lessCode["\(kDes)少了\(diff)"] = diff
                    lessTotal += diff
                }
            } // end if
            
        } // end for
        
        print(moreBundle)
        let sortMoreCode = moreCode.sortedByValue
        let sortLessCode = lessCode.sortedByValue
        for (k,_) in sortMoreCode {
            print(k)
        }
        print(" ")
        for (k,_) in sortLessCode {
            print(k)
        }
        print(" ")
//        print(moreCode)
//        print(lessCode)
        print("共多了：\(moreTotal)")
        print("共少了：\(lessTotal)")
        print("旧总量：\(totalOld)")
        print("新总量：\(totalNew)")
    }
    
}
