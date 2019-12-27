//
//  LaunchJSON.swift
//  SA
//
//  Created by ming on 2019/10/26.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

class LaunchJSON {
    
    enum State {
        case normal
        case start
    }
    
    // MARK: 整体输出
    public static func exportAll() {
        let fileName = Config.traceJSON.rawValue
        LaunchJSON.tree(preFile: fileName)
        
    }
    
    // MARK: 生成按时间的树状结构
    public static func tree(preFile: String, file: String = "") {
        // 获取工程方法
        let allNodes = ParseOC.ocNodes(workspacePath: Config.workPath.rawValue)
        
        var sourceDic = [String:String]()
        
        let classChians = OCStatistics.classChain(classAndBaseClassMap: OCStatistics.classAndBaseClass)
        // 每个类里有哪些方法个方法
        var classHaveMethods = [String:[String:String]]()
        
        for aNode in allNodes {
            if aNode.type == .method {
                let nodeSource = aNode.source.replacingOccurrences(of: "\n", with: "</br>").replacingOccurrences(of: " ", with: "&nbsp;")
                sourceDic[aNode.identifier] = nodeSource
                let methodValue:OCNodeMethod = aNode.value as! OCNodeMethod
                var dic = [String:String]()
                dic[methodValue.methodName] = aNode.source
                classHaveMethods[methodValue.belongClass] = dic
                
                // TODO: 处理所有方法的 tokenNode
                let tokenNodes = methodValue.tokenNodes
                
                
            }
        }
        
        for aNode in allNodes {
            // 取方法
            if aNode.type == .method {
                var nodeSourceOrign = aNode.source
                
                let nodeSource = nodeSourceOrign.replacingOccurrences(of: "\n", with: "</br>").replacingOccurrences(of: " ", with: "&nbsp;")
                sourceDic[aNode.identifier] = nodeSource
                OCStatistics.methodContent[aNode.identifier] = nodeSource
            }
        }
        
        // 获取启动时的方法
        
//        let bundleOwner = LaunchJSON.parseBundleOwner()
        let bundleOwner = [String:(String,String)]()
        // 取前版本全部的
        let preAllItem = LaunchJSON.launchJSON(fileName: preFile)
        var currentT = 0
        
        // 取全部
        let preAllMergeItem = LaunchJSON.allMethodAndSubMethods(fileName: preFile)
        // 转字典
        var preMergeItemDic = [String:LaunchItem]()
        for mItem in preAllMergeItem {
            let (bundleName,className,methodName) = LaunchJSON.bundleAndClassFromName(name: mItem.name)
            preMergeItemDic["\(bundleName+className+methodName)"] = mItem
        }
        var callTimes = 0
        var level = 0
        var tableStr = ""
        // 生成 html
        func recusiveItemTree(item:LaunchItem, level:Int, isFilterByCostTime:Bool = false) {
            for aItem in item.subItem {
                callTimes += 1
                var isOutput = true
                if aItem.cost/1000 < 10 {
                    isOutput = false
                }
                
                var treeSymbol = ""
                for i in 0..<level + 1 {
                    if i>0 {
                        treeSymbol.append("-")
                    }
                }
                
                // 获取 bundle、类名、方法名信息
                let (bundleName,className,methodName) = LaunchJSON.bundleAndClassFromName(name: aItem.name)
                
                // 获取 T1 到 T5 阶段信息，其中 updateLauncherState 函数名需要替换成自己阶段切换的函数名，最多5个阶段
                if methodName == "updateLauncherState:" {
                    currentT += 1
                    if currentT > 5 {
                        currentT = 5
                    }
                }
                
                // 获取外部耗时
                var sysCost = 0
                if aItem.subItem.count > 0 {
                    for aSubItem in aItem.subItem {
                        sysCost += aSubItem.cost
                    }
                }
                sysCost = (aItem.cost - sysCost) / 1000
                
                var tdStyle = ""
                var levelStr = ""
                if level == 0 {
                    tdStyle = "color:#7F1515;font-weight:bold;background-color:#F7F2F2;"
                    levelStr = "①"
                }
                if level == 1 {
                    tdStyle = "color:#B24545;"
                    levelStr = "②"
                }
                if level == 2 {
                    tdStyle = "color:gray;"
                    levelStr = "③"
                }
                if level > 2 {
                    tdStyle = "color:silver;"
                    levelStr = "\(level+1)"
                }
                let aItemCost = aItem.cost/1000
                
                var costColor = "dddddd"
                if aItemCost > 200 {
                    costColor = "B24545"
                } else if aItemCost > 100 {
                    costColor = "D68A55"
                } else if aItemCost > 50 {
                    costColor = "FFA533"
                } else if aItemCost > 30 {
                    costColor = "808080"
                }
                
                var sysCostColor = "dddddd"
                if sysCost > 200 {
                    sysCostColor = "B24545"
                } else if sysCost > 100 {
                    sysCostColor = "D68A55"
                } else if sysCost > 50 {
                    sysCostColor = "FFA533"
                } else if sysCost > 30 {
                    sysCostColor = "808080"
                }
                
                let (owner,bizName) = bundleOwner[bundleName] ?? ("暂无","暂无")
                
                // 加上 merge 信息
                var mergeStr = ""
                if preMergeItemDic.keys.contains("\(bundleName+className+methodName)") {
                    //
                    let mItem = preMergeItemDic["\(bundleName+className+methodName)"]
                    if mItem?.times ?? 0 > 1 && (mItem?.cost ?? 0) / 1000 > 0 {
                        mergeStr = "(总次数\(mItem?.times ?? 0)、总耗时\((mItem?.cost ?? 0) / 1000))"
                    }
                }
                
                let methodId = "[\(className)]\(methodName)"
                
                // 判断是否有代码内容
                var sourceContent = sourceDic[methodId] ?? ""
                
                if sourceContent.count > 0 {
                    //
                } else {
                    if methodId == "[NMLayersManager]initForbiddenSource" {
                        //
                    }
                    OCStatistics.noSourceMethod(methodId: methodId)
                    let chains = classChians[className] ?? [String]()
                    for pClass in chains {
                        guard let methods = classHaveMethods[pClass] else {
                            continue
                        }
                        guard let pSource = methods[methodName] else {
                            continue
                        }
                        OCStatistics.useBaseClassMethod(methodId: "\(methodId)")
                        sourceContent = pSource
                        break
                    }
                }
                
                
                var methodContentClickable = ""
                var methodClickable = "\(treeSymbol) \(methodId) \(mergeStr)"
                if sourceContent.count > 0 {
                    methodContentClickable = "class=\"canClick\""
                    methodClickable = """
                    \(treeSymbol)<a onclick="sourceShowHidden('\(methodId)\(callTimes)');"\(methodContentClickable)> \(methodId) \(mergeStr)</a>
                    """
                }
                
                
                if isOutput {
                    tableStr.append("""
                        <tr style=\"\(tdStyle)\">
                        <td style="color:black;background-color:white;">T\(currentT)</td>
                        <td style="color:#\(costColor);background-color:white;">\(aItemCost) </td>
                        <td>\(levelStr) \(methodClickable)<p class="sourceCode" id="\(methodId)\(callTimes)">\(sourceDic[methodId] ?? "")</p></td>
                        <td style="color:#\(sysCostColor);">\(sysCost)</td>
                        <td>\(bundleName)</td>
                        <td>\(owner)</td>
                        <td>\(bizName)</td>
                        </tr>
                        """)
                }
                
                if aItem.subItem.count > 0 {
                    //判断是否按照过滤
                    recusiveItemTree(item: aItem, level: level + 1, isFilterByCostTime: false)
                }
            } // end for
        } // end func
        
        recusiveItemTree(item: preAllItem, level: level)
        
        
        let htmlStr = """
<!doctype html>
<html>
<head>
<style>
table {
    width: 100%;
}
table,
td {
    border: 1px solid #dddddd;
    font-size: 13px;
}
thead,
tfoot {
    background-color: #333;
    color: #fff;
}
.sourceCode {
    color: #5499C7;
    display: none;
}
.canClick {
    text-decoration: underline;
}
</style>
</head>
<body>
<table>
    <thead>
        <tr>
            <th colspan="7">iOS 15秒内T1到T5阶段大于10毫秒耗时方法</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>阶段</td>
            <td>耗时(ms)</td>
            <td>方法</td>
            <td>外部耗时</td>
            <td>Bundle</td>
            <td>Owner</td>
            <td>业务线</td>
        </tr>
        \(tableStr)
    </tbody>
</table>
<script>
function sourceShowHidden(sourceIdName) {

    var sourceCode = document.getElementById(sourceIdName);
    if (sourceCode.style.display == "block") {
        sourceCode.style.display = "none";
    } else {
        sourceCode.style.display = "block";
    }
    
}
</script>
</body>
</html>
"""
        writeToCsv(content: htmlStr, fileName: preFile, suffix: "html")
        
    }
    

    
    public static func allMethodAndSubMethods(fileName:String) -> [LaunchItem] {
        let allItems = LaunchJSON.leaf(fileName: fileName, isGetAllItem: true)
        
        var mergeDic = [String:LaunchItem]()
        for item in allItems {
            let mergeKey = item.name // 方法名为标识
            if mergeDic[mergeKey] != nil {
                var newItem = mergeDic[mergeKey]
                newItem?.cost += item.cost // 累加耗时
                newItem?.times += 1 // 累加次数
                mergeDic[mergeKey] = newItem
            } else {
                mergeDic[mergeKey] = item
            }
        }
        
        var nameCostDic = [String:Int]()
        for (k,v) in mergeDic {
            nameCostDic[k] = v.cost
        }
        let sortArr = nameCostDic.sortedByValue
        var sortMergeArr = [LaunchItem]()
        for aSet in sortArr {
            let (name,_) = aSet
            guard let item = mergeDic[name] else {
                continue
            }
            sortMergeArr.append(item)
        }
        
        return sortMergeArr.reversed()
        
    }
    
   
    
    public static func writeToCsv(content:String, fileName:String, suffix:String = "csv") {
        try! content.write(toFile: "\(Config.downloadPath.rawValue)\(fileName).\(suffix)", atomically: true, encoding: String.Encoding.utf8)
    }
    
 
    
    public static func launchJSON(fileName:String) -> LaunchItem {
        
        let jsonOPath = Bundle.main.path(forResource: fileName, ofType: "json")
        let jOrgPath = jsonOPath ?? ""
        
        let jsonOContent = FileHandle.fileContent(path: jOrgPath)
        let items = ParseLaunchJSON(input: jsonOContent).parse()
        
        func recusiveMethodTree(parentItem: LaunchItem, items:[LaunchItem]) -> LaunchItem {
            
            var pItem = parentItem
            var currentState:State = .normal
            var itemArrs = [[LaunchItem]]() // 一级记录一组
            var currentItemArr = [LaunchItem]() // 二级 array
            var currentItemName = ""
            
            for item in items {
                // 顺序
                if item.ph == "E" && item.name == currentItemName {
                    currentState = .normal
                    currentItemArr.append(item)
                    itemArrs.append(currentItemArr)
                    currentItemArr = [LaunchItem]()
                    continue
                }
                
                if currentState == .start {
                    currentItemArr.append(item)
                    continue
                }
                
                if item.ph == "B" {
                    currentState = .start
                    currentItemArr.append(item)
                    currentItemName = item.name
                    continue
                }
            } // end for item in items
            
            for itemArr in itemArrs {
                if itemArr.count == 2 {
                    // 只有两个 B 和 E 配对的情况
                    let b = itemArr[0]
                    let e = itemArr[1]
                    let cost = Int(e.ts)! - Int(b.ts)!
                    let addItem = LaunchItem(name: b.name, ph: "BE", ts: b.ts, cost: cost, times: 1, subItem: [LaunchItem](), parentItem: [LaunchItem]())
                    pItem.subItem.append(addItem)
                } else if itemArr.count > 2 {
                    // 大于2个的情况
                    let b = itemArr[0]
                    let e = itemArr[itemArr.count - 1]
                    let cost = Int(e.ts)! - Int(b.ts)!
                    let rPItem = LaunchItem(name: b.name, ph: "BE", ts: b.ts, cost: cost, times: 1, subItem: [LaunchItem](), parentItem: [LaunchItem]())
                    var newItemArr = itemArr
                    newItemArr.remove(at: itemArr.count - 1)
                    newItemArr.remove(at: 0)
                    
                    pItem.subItem.append(recusiveMethodTree(parentItem: rPItem, items: newItemArr))
                }
            } // end for itemArr in itemArrs
            
            return pItem
        } // end func
        
        // 递归出父子树
        let rootItem = recusiveMethodTree(parentItem: LaunchItem(name: "root", ph: "root", ts: "", cost: 0, times: 1, subItem: [LaunchItem](), parentItem: [LaunchItem]()), items: items)
        
        return rootItem
        
    }
    
    
    // MARK:末端叶子列表
    public static func leaf(fileName:String, isGetAllItem:Bool = false) -> [LaunchItem] {
        let rootItem = LaunchJSON.launchJSON(fileName: fileName)
        var leafArr = [LaunchItem]()
        var allArr = [LaunchItem]()
        
        func recusiveItemTree(item:LaunchItem) {
            for var aItem in item.subItem {
                // 添加父 item
                aItem.parentItem.append(item)
                if item.ph == "root" {
                    aItem.ph = ""
                } else {
                    aItem.ph = "\(item.ph) \(item.name)"
                }
                allArr.append(aItem)
                if aItem.subItem.count > 0 {
                    recusiveItemTree(item: aItem)
                } else {
                    // 增加叶子
                    leafArr.append(aItem)
                }
            }
        }
        recusiveItemTree(item: rootItem)
        
        if isGetAllItem {
            return allArr
        }
        
        return leafArr
    }
    
 
    
 
    
    // MARK: 从 Name 里取出 Bundle 和 Class
    public static func bundleAndClassFromName(name:String) -> (String,String,String) {
        let s1Arr = name.components(separatedBy: "[")
        let bundleName = s1Arr[1].components(separatedBy: "]")[0]
        let className = s1Arr[2].components(separatedBy: "]")[0]
        let methodName = s1Arr[2].components(separatedBy: "]")[1]
        return (bundleName,className,methodName)
    }
    
    public static func parseBundleOwner() -> [String:(String,String)]{
        let jsonOPath = Bundle.main.path(forResource: "BundleOwner", ofType: "json")
        let jOrgPath = jsonOPath ?? ""
        
        let jsonOContent = FileHandle.fileContent(path: jOrgPath)
        
        //let tks = ParseJSONTokens(input: jsonOContent).parse()
        let item = ParseJSONItem(input: jsonOContent).parse()
        let arr = item.array[0].kvs[2].value.kvs
        
        var bundleOwner = [String:(String,String)]() //[bundle名:(owner,业务线)]
        
        for value in arr {
            let bizName = value.key
            var bundleName = ""
            var ownerName = ""
            for b in value.value.array {
                for bv in b.kvs {
                    if bv.key == "repo" {
                        bundleName = bv.value.value.components(separatedBy: "/")[1]
                    }
                    if bv.key == "admins" {
                        let adminDic = bv.value.array[0].kvs
                        for ad in adminDic {
                            if ad.key == "realNameCn" {
                                ownerName = ad.value.value
                            }
                        }
                    }
                } // end for bv in b.kvs
                bundleOwner[bundleName] = (ownerName,bizName)
                
            } // end for b in value.value.array
        }
        return bundleOwner
    }
    
    public static func loadSimpleKeyValueDicWithCsv(fileName:String) -> [String:String] {
        let path = Bundle.main.path(forResource: fileName, ofType: "csv")
        let oPath = path ?? ""
        
        let content = FileHandle.fileContent(path: oPath)
        
        let tokens = Lexer(input: content, type: .plain).allTkFast(operaters: ",")
        var allTks = [[Token]]()
        var currentTks = [Token]()
        for tk in tokens {
            if tk == .newLine {
                allTks.append(currentTks)
                currentTks = [Token]()
                continue
            }
            if tk == .id(",") {
                continue
            }
            currentTks.append(tk)
        }
        
        var classBundleDic = [String:String]()
        for tks in allTks {
            var i = 0
            var currentKey = ""
            for tk in tks {
                if i == 0 {
                    currentKey = tk.des()
                }
                if i == 1 {
                    classBundleDic[currentKey] = tk.des()
                }
                i += 1
            }
        }
        return classBundleDic
    }
    
}




