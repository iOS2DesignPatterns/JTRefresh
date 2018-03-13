//
//  JTRefreshBaseView.swift
//  ExpressPeople
//
//  Created by jintao on 2018/3/9.
//  Copyright © 2018年 jintao. All rights reserved.
//

/// ---* header
// 0. 下拉刷新
// 1. 释放以刷新
// 2. 刷新中
// 3. 刷新成功，失败
// 4. 回弹

/// ---* footer
// 0. 上拉加载
// 1. 释放以加载
// 2. 加载中
// 3. 加载成功，失败
// 4. 回弹

/**
    刷新视图
 **/

import UIKit

class JTRefreshBaseView: UIView {
    
    // 父视图
    weak var superRefreshView: UIScrollView!
    
    // 绑定方法的对象
    weak var target: AnyObject?
    
    // 视图高度
    var refresh_height: CGFloat! {
        didSet {
            let newFrame = CGRect(x: self.jt_x, y: self.jt_y, width: self.jt_width, height: refresh_height)
            self.frame = newFrame
        }
    }
    
    
    // 头刷新状态
    var _heaerRefreshStatus: JTRefresh.headerStatus! = .normal
    var heaerRefreshStatus: JTRefresh.headerStatus! {
        get {
            return self._heaerRefreshStatus
        }
        set {
            self.updateHeaderView(newValue)
        }
    }
    
    // 尾刷新状态
    var _footerRefreshStatus: JTRefresh.footerStatus! = .normal
    var footerRefreshStatus: JTRefresh.footerStatus! {
        get {
            return self._footerRefreshStatus
        }
        set {
            self.updateFooterView(newValue)
        }
    }
    
    
    /// * init
    init(target: AnyObject?) {
        super.init(frame: .zero)
        self.target = target
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// *监听ScrollView的contentOffset
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     
        if keyPath == "contentOffset" {
            
            let offsetY = self.superRefreshView.contentOffset.y
            
            /// --- header ---
            if _heaerRefreshStatus == .readyRefresh && !superRefreshView.isDragging {
                self._heaerRefreshStatus = .refreshing
                self.heaerRefreshStatus = .refreshing
                
            } else {
                
                // 刷新中。。。
                if self.heaerRefreshStatus == .refreshing {
                    
                } else {
                    var newHeaderRefreshStatus: JTRefresh.headerStatus!
                    if -offsetY >= (self.refresh_height==nil ? JTRefresh.headerViewHeight:self.refresh_height) {
                        if superRefreshView.isDragging {
                            newHeaderRefreshStatus = .readyRefresh
                        } else {
                            newHeaderRefreshStatus = .refreshing
                        }
                        
                    } else {
                        newHeaderRefreshStatus = .normal
                    }
                    
                    if self._heaerRefreshStatus != newHeaderRefreshStatus || (newHeaderRefreshStatus == .normal && superRefreshView.jt_isDroping) {
                        self._heaerRefreshStatus = newHeaderRefreshStatus
                        self.heaerRefreshStatus = newHeaderRefreshStatus
                    }
                }
                
            }
            
            /// --- footer ---
            if self.footerRefreshStatus == .readyLoad && !self.superRefreshView.isDragging {
                self._footerRefreshStatus = .loading
                self.footerRefreshStatus = .loading
                
            } else {
                if self._footerRefreshStatus == .loading {
                    return
                }
                
                var newFooterRefreshStatus: JTRefresh.footerStatus!
                
                if superRefreshView.contentSize.height <= superRefreshView.jt_height {
                    
                    if offsetY + (superRefreshView.jt_top) >= (self.refresh_height==nil ? JTRefresh.footerViewHeight:self.refresh_height) {
                        
                        if self.superRefreshView.isDragging {
                            newFooterRefreshStatus = .readyLoad
                        } else {
                            newFooterRefreshStatus = .loading
                        }
                        
                    } else {
                        newFooterRefreshStatus = .normal
                    }
                    
                } else {
                    
                    if offsetY + (superRefreshView.jt_top) + superRefreshView.jt_height >= superRefreshView.contentSize.height + (self.refresh_height==nil ? JTRefresh.footerViewHeight:self.refresh_height) {
                        
                        if self.superRefreshView.isDragging {
                            newFooterRefreshStatus = .readyLoad
                        } else {
                            newFooterRefreshStatus = .loading
                        }
                        
                    } else {
                        newFooterRefreshStatus = .normal
                    }
                    
                }
            
                if self._footerRefreshStatus != newFooterRefreshStatus || (newFooterRefreshStatus == .normal && superRefreshView.jt_isPulling) {
                    self._footerRefreshStatus = newFooterRefreshStatus
                    self.footerRefreshStatus = newFooterRefreshStatus
                }
            }
            
        }
        
    }
    
    deinit {
        self.superRefreshView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}


// MARK: - JTRefreshViewProtocol
extension JTRefreshBaseView: JTRefreshViewProtocol {
    
    /// *设置视图
    func setFrame(_ frame: CGRect, superRefreshView: UIScrollView) {
        let newFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: self.refresh_height == nil ? frame.height:self.refresh_height))
        self.frame = newFrame
        self.superRefreshView = superRefreshView
        self.superRefreshView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    /// *更新头部刷新UI
    func updateHeaderView(_ refreshStatus: JTRefresh.headerStatus) {
        
    }
    
    /// *更新尾部刷新UI
    func updateFooterView(_ refreshStatus: JTRefresh.footerStatus) {
        
    }
    
  
}









