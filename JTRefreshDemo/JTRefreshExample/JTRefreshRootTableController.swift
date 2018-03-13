//
//  JTRefreshRootTableController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

enum refreshType: Int {
    case Normal = 0
    case GIF = 1
    case DIY = 2
}

import UIKit

class JTRefreshRootTableController: UITableViewController {

    let refreshModels = [["UIScrollView", "UITableView", "UICollection", "UIWebView"], ["GIF-UIScrollView", "GIF-UITableView", "GIF-UICollection", "GIF-UIWebView"], ["DIY-UIScrollView", "DIY-UITableView", "DIY-UICollection", "DIY-UIWebView"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JTRefresh"
        self.tableView.tableFooterView = UIView(frame: .zero)
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Normal"
        }
        if section == 1 {
            return "GIF"
        }
        if section == 2 {
            return "DIY"
        }
        return nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return refreshModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refreshModels[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JTBaseCell.cell(tableview: tableView)
        cell.textLabel?.text = refreshModels[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let scrollVC = JTScrollRefreshController(nibName: nil, bundle: nil, type: refreshType(rawValue: indexPath.section)!)
            self.navigationController?.pushViewController(scrollVC, animated: true)
            
        case 1:
            let tableVC = JTTableRefreshController(nibName: nil, bundle: nil, type: refreshType(rawValue: indexPath.section)!)
            self.show(tableVC, sender: nil)
            
        case 2:
            let collectionVC = JTCollectionRefreshController(nibName: nil, bundle: nil, type: refreshType(rawValue: indexPath.section)!)
            self.show(collectionVC, sender: nil)
            
        case 3:
            let webVC = JTWebRefreshController(nibName: nil, bundle: nil, type: refreshType(rawValue: indexPath.section)!)
            self.navigationController?.pushViewController(webVC, animated: true)
            
        default:
            break
        }
        
    }


}


