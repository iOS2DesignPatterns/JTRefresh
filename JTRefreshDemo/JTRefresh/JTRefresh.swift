//
//  JTRefresh.swift
//  ExpressPeople
//
//  Created by jintao on 2018/3/9.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTRefresh {
    
    /// *refreshBlock
    typealias refreshBlock = ()->Void 
    
    /// *默认刷新header视图高度
    static let headerViewHeight: CGFloat = 60
    
    /// *默认刷新footer视图高度
    static let footerViewHeight: CGFloat = 40
    
    /// *GIF图片尺寸
    static let refreshGIFWidth: CGFloat = 32
    static let refreshGIFHeight: CGFloat = 32
    
    /// *动画时间
    static let refreshDuration: TimeInterval = 0.2
    
    /// *下拉刷新状态
    @objc enum headerStatus: Int {
        case normal              // 正常状态
        case readyRefresh        // 准备刷新
        case refreshing          // 刷新中
    }
    
    /// *上拉加载状态
    @objc enum footerStatus: Int {
        case normal              // 正常状态
        case readyLoad           // 准备加载
        case loading             // 正在加载
    }
    

    /// *下拉
    static let headerNormal = "下拉即可刷新..."
    static let headerReady = "释放即可刷新..."
    static let headerRefreshing = "数据加载中..."
    
    /// *上拉
    static let footerNormal = "点击或上拉即可加载..."
    static let footerReady = "释放马上加载..."
    static let footerLoading = "正在加载更多数据..."
    
    /// *Date
    static let dateNormal = "最近无更新~"
    
}




