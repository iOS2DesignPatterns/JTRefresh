//
//  BaseCell.swift
//  Summary01_LoginManager
//
//  Created by jintao on 2017/8/13.
//  Copyright © 2017年 jintao. All rights reserved.
//

import UIKit

class JTBaseCell: UITableViewCell {

    // 重用获取cell
   class func cell(tableview:UITableView)-> JTBaseCell {
    
        // 重用名字
        let reuseIdentifier = NSStringFromClass(self).components(separatedBy: ".").last
        // 获取cell
        var cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier!) as? JTBaseCell
        if cell == nil {
            tableview.register(self, forCellReuseIdentifier: reuseIdentifier!)
            cell = (tableview.dequeueReusableCell(withIdentifier: reuseIdentifier!) as! JTBaseCell)
        }
        
        return cell!
    }

    // XIb获取cell
    class func xibCell(tableview:UITableView)-> JTBaseCell {
        
        // XIB名字
        let xibIDArr = NSStringFromClass(self).components(separatedBy: ".")
        let reuseIdentifier = xibIDArr.last
        // 获取cell
        var cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier!) as? JTBaseCell
        if cell == nil {
            tableview.register(UINib(nibName: reuseIdentifier!, bundle: nil), forCellReuseIdentifier: reuseIdentifier!)
            cell = (tableview.dequeueReusableCell(withIdentifier: reuseIdentifier!) as! JTBaseCell)
        }
        
        return cell!
    }
    
    // 获取空白Cell
    class func blackCell(tableview:UITableView)-> UITableViewCell {
        
        // 重用名
        let reuseIdentifier = "BaseBlackCell"
        // 获取cell
        var cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            tableview.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        }
        
        return cell!
    }

}




