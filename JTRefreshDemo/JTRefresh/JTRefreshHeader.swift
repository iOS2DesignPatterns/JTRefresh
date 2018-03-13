//
//  JTRefreshHeader.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
   Base Header
 **/

import UIKit

class JTRefreshHeader: JTRefreshBaseView {

    
    /// 开始刷新
    func startRefresh() {
        self._heaerRefreshStatus = .refreshing
        self.heaerRefreshStatus = .refreshing
    }
    
    /// 结束刷新
    func endRefresh() {
        self._heaerRefreshStatus = .normal
        self.heaerRefreshStatus = .normal
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            self.superRefreshView.contentInset = UIEdgeInsetsMake(self.superRefreshView.jt_top-(self.refresh_height==nil ? JTRefresh.headerViewHeight:self.refresh_height), self.superRefreshView.jt_left, self.superRefreshView.jt_bottom, self.superRefreshView.jt_right)
            
        }, completion: { (finish) in
    
            self.headerStopRefresh()
        })
    
    }
    
    override func setFrame(_ frame: CGRect, superRefreshView: UIScrollView) {
        super.setFrame(frame, superRefreshView: superRefreshView)
    }
    
    /// 更新状态
    override func updateHeaderView(_ refreshStatus: JTRefresh.headerStatus) {
        
        switch refreshStatus {
        case .normal:
//            var moveDistance: CGFloat!
//            if superRefreshView.jt_top <= 0 {
//                moveDistance = -superRefreshView.jt_top-superRefreshView.contentOffset.y
//            } else {
//                moveDistance = -superRefreshView.contentOffset.y-superRefreshView.jt_top
//            }
            self.headerDroping((-superRefreshView.jt_top-superRefreshView.contentOffset.y)/(self.refresh_height==nil ? JTRefresh.headerViewHeight:refresh_height))
            
        case .readyRefresh:
            self.headerReadyRefresh()
            
        case .refreshing:
            self.superRefreshView.contentInset = UIEdgeInsets(top: superRefreshView.jt_top+(self.refresh_height==nil ? JTRefresh.headerViewHeight:refresh_height), left: superRefreshView.jt_left, bottom: superRefreshView.jt_bottom, right: superRefreshView.jt_right)
            self.headerRefreshing()
        }
        
    }
    
}

extension JTRefreshHeader: JTRefreshHeaderProtocol {
    
    /// *下拉中
    func headerDroping(_ progrss: CGFloat) {
    }
    
    /// *准备刷新
    func headerReadyRefresh() {
    }
    
    /// *刷新中
    func headerRefreshing() {
    }
    
    /// *停止刷新
    func headerStopRefresh() {
    }

}



