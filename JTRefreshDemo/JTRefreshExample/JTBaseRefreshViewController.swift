//
//  JTBaseRefreshViewController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTBaseRefreshViewController: UIViewController {
    
    var naviHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.jt_height==nil ? 0:(self.navigationController?.navigationBar.jt_height)!)
    }
    
    var type: refreshType
    
    let gifImages = [#imageLiteral(resourceName: "gif－1"), #imageLiteral(resourceName: "gif－2"), #imageLiteral(resourceName: "gif－3"), #imageLiteral(resourceName: "gif－4"), #imageLiteral(resourceName: "gif－5"), #imageLiteral(resourceName: "gif－6")]
    

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, type: refreshType) {
        self.type = type
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 下拉刷新
    @objc func refreshLoading(_ loadSucess: @escaping ()->Void) {
        
        DispatchQueue.global().async {
            
            // *netWork...
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async {
                loadSucess()
            }
        }
    }
    
    
    /// 上拉加载
    @objc func pullLoading(_ loadSucess: @escaping ()->Void) {
        
        DispatchQueue.global().async {
            
            // *netWork...
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async {
                loadSucess()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("MemoryWarning")
    }
    
    deinit {
        print("=== deinit ===")
    }
    
}






