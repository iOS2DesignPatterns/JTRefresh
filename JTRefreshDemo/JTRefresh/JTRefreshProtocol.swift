//
//  JTRefreshProtocol.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

/// * scrollView-methon
protocol JTRefreshProtocol: NSObjectProtocol {
    
    /// *headerStartRefresh
    func headerstartRefresh()
    
    /// *headerStopRefresh
    func headerStopRefresh()
    
    /// *footerStartRefresh
    func footerStartRefresh()
    
    /// *footerStopRefresh
    func footerStopRefresh()
    
}


/// * refreshBaseView-methon
@objc protocol JTRefreshViewProtocol {
    
    /// *更新UI
    func setFrame(_ frame: CGRect, superRefreshView: UIScrollView)
    
    /// *更新头部刷新UI
    @objc optional func updateHeaderView(_ refreshStatus: JTRefresh.headerStatus)
    
    /// *更新尾部刷新UI
    @objc optional func updateFooterView(_ refreshStatus: JTRefresh.footerStatus)
    
    /// 开始加载
    @objc optional func startRefresh()
    
    /// 结束加载
    @objc optional func endRefresh()
    
}


/// * refreshHeader-delegate
@objc protocol JTRefreshHeaderProtocol {
    
    /// *正常状态(下拉中)
    func headerDroping(_ progrss: CGFloat)
    
    /// *准备刷新状态(释放开启刷新)
    func headerReadyRefresh()
    
    /// *刷新中状态
    func headerRefreshing()
    
    /// *结束刷新
    func headerStopRefresh()
    
}

/// * refreshFooter-delegate
@objc protocol JTRefreshFooterProtocol {
    
    /// *正常状态(上拉中)
    func footerPulling(_ progrss: CGFloat)
    
    /// *准备加载状态(释放开启加载)
    func footerReadyLoad()
    
    /// *加载中状态
    func footerLoading()
    
    /// *结束加载
    func footerStopLoad()
    
}






