//
//  JTRefreshFooter.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
   Base Footer
 **/

import UIKit

class JTRefreshFooter: JTRefreshBaseView {
    
    
    /// *ScrollView内容变多
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // *contentOffset
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if keyPath == "contentSize" {
            
            self.frame = CGRect(x: 0, y: self.superRefreshView.contentSize.height, width: self.jt_width, height: JTRefresh.footerViewHeight)
        }
    }
    
    deinit {
        guard self.superRefreshView != nil else {
            return
        }
        self.superRefreshView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
}

extension JTRefreshFooter {
    
    override func setFrame(_ frame: CGRect, superRefreshView: UIScrollView) {
        super.setFrame(frame, superRefreshView: superRefreshView)
        self.superRefreshView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    /// 开始加载
    func startRefresh() {
        self._footerRefreshStatus = .loading
        self.footerRefreshStatus = .loading
    }
    
    /// 结束加载
    func endRefresh() {
        self._footerRefreshStatus = .normal
        self.footerRefreshStatus = .normal
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            
            self.superRefreshView.contentInset = UIEdgeInsetsMake(self.superRefreshView.jt_top, self.superRefreshView.jt_left, self.superRefreshView.jt_bottom-(self.refresh_height==nil ? JTRefresh.footerViewHeight:self.refresh_height), self.superRefreshView.jt_right)
            
        }) { (finish) in
            self.footerStopLoad()
        }
        
    }
    
    
    /// *刷新状态更新
    override func updateFooterView(_ refreshStatus: JTRefresh.footerStatus) {
        
        switch refreshStatus {
        case .normal:
            var progress: CGFloat!
            if superRefreshView.contentSize.height <= superRefreshView.jt_height {
               
                progress = (superRefreshView.contentOffset.y+superRefreshView.jt_top)/(refresh_height==nil ? JTRefresh.footerViewHeight:refresh_height)
                
            } else {
                let normalHieght = superRefreshView.contentSize.height - superRefreshView.jt_height
                progress = (superRefreshView.contentOffset.y-normalHieght)/(refresh_height==nil ? JTRefresh.footerViewHeight:refresh_height)
                
            }
            self.footerPulling(progress)
            
        case .readyLoad:
            self.footerReadyLoad()
            
        case .loading:
            self.superRefreshView.contentInset = UIEdgeInsetsMake(superRefreshView.jt_top, superRefreshView.jt_left, superRefreshView.jt_bottom+(refresh_height==nil ? JTRefresh.footerViewHeight:refresh_height), superRefreshView.jt_right)
            self.footerLoading()
            
        }
        
    }
    
}

extension JTRefreshFooter: JTRefreshFooterProtocol {
    
    /// 上拉中...
    func footerPulling(_ progrss: CGFloat) {
    }
    
    /// *准备加载
    func footerReadyLoad() {
    }
    
    /// *加载中
    func footerLoading() {
    }
    
    /// *停止加载
    func footerStopLoad() {
    }
  
}




