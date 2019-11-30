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
    
}
