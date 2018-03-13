 //
//  JTRefreshExtension.swift
//  ExpressPeople
//
//  Created by jintao on 2018/3/9.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

 
// *头部视图指针
private var headerPointer: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: 2)
// *底部视图指针
private var footerPointer: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: 3)

 
// MARK: - UIScrollView
extension UIScrollView: JTRefreshProtocol {
    
    /// 刷新头视图
    var headerView: JTRefreshHeader? {
        get {
            let header = objc_getAssociatedObject(self, headerPointer) as? JTRefreshHeader
            return header
        }
        set {
            if let oldValue = objc_getAssociatedObject(self, headerPointer) as? JTRefreshHeader {
                oldValue.removeFromSuperview()
            }
            setHeader(newValue)
            objc_setAssociatedObject(self, headerPointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 刷新底视图
    var footerView: JTRefreshFooter? {
        get {
            let footer = objc_getAssociatedObject(self, footerPointer) as? JTRefreshFooter
            return footer
        }
        set {
            if let oldValue = objc_getAssociatedObject(self, footerPointer) as? JTRefreshFooter {
                oldValue.removeFromSuperview()
            }
            setFooter(newValue)
            objc_setAssociatedObject(self, footerPointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// *setHeader
    private func setHeader(_ header: JTRefreshHeader?) {
        
        guard header != nil else { return }
        
        header?.setFrame(CGRect(x: 0, y: -JTRefresh.headerViewHeight, width: self.jt_width, height: JTRefresh.headerViewHeight), superRefreshView: self)
        
        // *ScrollView滑不动
        if !self.isKind(of: UITableView.classForCoder()) || !self.isKind(of: UICollectionView.classForCoder()) {
            if self.contentSize.height < self.jt_height + 1 {
                self.contentSize = CGSize(width: self.contentSize.width, height: self.jt_height+1)
            }
        }
        self.addSubview(header!)
    }
    
    
    /// *setFooter
    private func setFooter(_ footer: JTRefreshFooter?) {
        
        guard footer != nil else { return }
        
        footer?.setFrame(CGRect(x: 0, y: self.contentSize.height, width: self.jt_width, height: JTRefresh.footerViewHeight), superRefreshView: self)
        
        // *ScrollView滑不动
        if !self.isKind(of: UITableView.classForCoder()) || !self.isKind(of: UICollectionView.classForCoder()) {
            if self.contentSize.height < self.jt_height + 1 {
                self.contentSize = CGSize(width: self.contentSize.width, height: self.jt_height+1)
            }
        }
        self.addSubview(footer!)
    }
    
    
    /// *headerStart
    func headerstartRefresh() {
       self.headerView?.startRefresh()
    }
    
    /// *headerStop
    func headerStopRefresh() {
        self.headerView?.endRefresh()
    }
    
    /// *footerStart
    func footerStartRefresh() {
       self.footerView?.startRefresh()
    }
    
    /// *footerStop
    func footerStopRefresh() {
        self.footerView?.endRefresh()
    }

    
    /// 添加刷新方法
    ///
    /// - Parameters:
    ///   - target:
    ///   - headerSEL: 头部刷新方法
    ///   - footerSEL: 底部刷新方法
    ///   - isShowRefreshDate: 是否显示头部刷新时间
    public func addRefreshWithTarget(_ target: AnyObject, headerAction: Selector?, footerAction: Selector?, hiddenRefreshDate: Bool = true)
    {
        
        if headerAction != nil {
            
            let headerView = JTRefreshHeaderView(target: target, action: headerAction!, hiddenRefreshDate: hiddenRefreshDate)
            self.headerView = headerView
        }
        
        if footerAction != nil {
            
            let footerView = JTRefreshFooterView(target: target, action: footerAction!)
            self.footerView = footerView
        }
        
    }
    
    
    // MARK: 属性
    
    var jt_top: CGFloat {
        get {
            return self.contentInset.top
        }
    }
    
    var jt_left: CGFloat {
        get {
            return self.contentInset.left
        }
    }
    
    var jt_right: CGFloat {
        get {
            return self.contentInset.right
        }
    }
    
    var jt_bottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
    }
    
    /// *是否下拉中
    var jt_isDroping: Bool {
        get {
            return self.jt_top <= -self.contentOffset.y
        }
    }
    
    /// *是否上拉中
    var jt_isPulling: Bool {
        get {
            if self.contentSize.height >= self.jt_height {
                return self.contentOffset.y >= self.contentSize.height-self.jt_height
            } else {
                return self.jt_top >= -self.contentOffset.y
            }
        }
    }
    

}
 
 


