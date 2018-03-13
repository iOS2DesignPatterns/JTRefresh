//
//  JTRefreshGIFHeaderView.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
    GIF动态图下拉刷新
 **/

import UIKit

class JTRefreshGIFHeaderView: JTRefreshHeader {

    // 下拉绑定的方法(不暴露出来，不写到父类中)
    private var headerSelector: Selector!
    
    // 下拉执行的block
    private var headerBlock: JTRefresh.refreshBlock?
    
    // 是否隐藏下拉时间
    private var hiddenRefreshDate: Bool
    
    // 最后一次刷新时间
    private var lastRefreshDate: Date!
    
    // 是否隐藏下拉状态
    private var hiddenRefreshStatus: Bool
    
    // 下拉状态
    var refreshStatusLabel: UILabel?
    
    // 最后刷新时间
    var lastRefreshDateLabel: UILabel?
    
    // 刷新动画
    private var refreshGIFView: UIImageView!
    
    // *stateImages
    private var normalImages: Array<UIImage>!
    private var readyImages: Array<UIImage>!
    private var refreshImages: Array<UIImage>!
    
    // *stateText
    private var normalText: String?
    private var readyText: String?
    private var refreshingText: String?
    
    
    /// *init
    init(target: AnyObject, action: Selector, hiddenDate: Bool=true, hiddenStatus: Bool=false) {
        self.hiddenRefreshDate = hiddenDate
        self.hiddenRefreshStatus = hiddenStatus
        super.init(target: target)
        self.headerSelector = action
        self.setSubViews()
    }
    
    init(hiddenDate: Bool=true, hiddenStatus: Bool=false, _ headerBlock:@escaping JTRefresh.refreshBlock) {
        self.hiddenRefreshDate = hiddenDate
        self.hiddenRefreshStatus = hiddenStatus
        super.init(target: nil)
        self.headerBlock = headerBlock
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// *setSubViews
    private func setSubViews() {
        
        // 添加状态
        func addStatusLabel() {
            refreshStatusLabel = UILabel(frame: .zero)
            refreshStatusLabel!.translatesAutoresizingMaskIntoConstraints = false
            refreshStatusLabel!.textColor = UIColor.lightGray
            refreshStatusLabel!.font = UIFont.systemFont(ofSize: 15)
            refreshStatusLabel!.textAlignment = .center
            refreshStatusLabel!.text = normalText == nil ? JTRefresh.headerNormal:normalText!
            self.addSubview(refreshStatusLabel!)
            
            let statusCenterX = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let statusHeight = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
            refreshStatusLabel!.addConstraint(statusHeight)
            self.addConstraint(statusCenterX)
        }
        
        // 添加时间
        func addDateLabel() {
            lastRefreshDateLabel = UILabel(frame: .zero)
            lastRefreshDateLabel!.translatesAutoresizingMaskIntoConstraints = false
            lastRefreshDateLabel!.textColor = UIColor.lightGray
            lastRefreshDateLabel!.font = UIFont.systemFont(ofSize: 14)
            lastRefreshDateLabel!.textAlignment = .center
            lastRefreshDateLabel!.text = JTRefresh.dateNormal
            self.addSubview(lastRefreshDateLabel!)
            
            let dateHeight = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21)
            let dateCenterX = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            lastRefreshDateLabel!.addConstraint(dateHeight)
            self.addConstraint(dateCenterX)
        }
        
        // 添加动画
        func addGIFView() {
            refreshGIFView = UIImageView(frame: .zero)
            refreshGIFView.translatesAutoresizingMaskIntoConstraints = false
            refreshGIFView.contentMode = .scaleAspectFit
            refreshGIFView.animationImages = normalImages
            self.addSubview(refreshGIFView)
            
            let gifHeight = NSLayoutConstraint(item: refreshGIFView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: JTRefresh.refreshGIFHeight)
            let gifWidth = NSLayoutConstraint(item: refreshGIFView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: JTRefresh.refreshGIFWidth)
            let gifCenterY = NSLayoutConstraint(item: refreshGIFView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            refreshGIFView.addConstraints([gifHeight, gifWidth])
            self.addConstraint(gifCenterY)
        }
        
        /// *只显示动画
        if self.hiddenRefreshStatus && self.hiddenRefreshDate {
            addGIFView()
            let gifCenterX = NSLayoutConstraint(item: refreshGIFView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            self.addConstraint(gifCenterX)
            return
        }
        
        /// *显示动画和状态
        if !self.hiddenRefreshStatus && self.hiddenRefreshDate {
            addStatusLabel()
            addGIFView()
            
            let statusCenterY = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let gifRight = NSLayoutConstraint(item: refreshGIFView, attribute: .right, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .left, multiplier: 1, constant: -15)
            self.addConstraints([statusCenterY, gifRight])
            return
        }
        
        /// *显示动画和时间
        if self.hiddenRefreshStatus && !self.hiddenRefreshDate {
            addDateLabel()
            addGIFView()
            
            let dateCenterY = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let gifRight = NSLayoutConstraint(item: refreshGIFView, attribute: .right, relatedBy: .equal, toItem: lastRefreshDateLabel, attribute: .left, multiplier: 1, constant: -15)
            self.addConstraints([dateCenterY ,gifRight])
            return
        }
        
        /// *都显示
        if !self.hiddenRefreshStatus && !self.hiddenRefreshDate {
            addStatusLabel()
            addDateLabel()
            addGIFView()
            
            let statusBottom = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let dateTop = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10)
            let gifRight = NSLayoutConstraint(item: refreshGIFView, attribute: .right, relatedBy: .equal, toItem: lastRefreshDateLabel, attribute: .left, multiplier: 1, constant: -15)
            self.addConstraints([statusBottom, dateTop, gifRight])
        }
        
    }
    
    
    /// *设置刷新不同动画状态
    public func setImages(_ images: Array<UIImage>?, for state: JTRefresh.headerStatus) {
        
        switch state {
        case .normal:
            self.normalImages = images
            
        case .readyRefresh:
            self.readyImages = images
            
        case .refreshing:
            self.refreshImages = images
        }
    }
    
    
    public func setStatusText(_ text: String, for state: JTRefresh.headerStatus) {
        
        switch state {
        case .normal:
            normalText = text
            self.refreshStatusLabel?.text = text
        case .readyRefresh: readyText = text
        case .refreshing: refreshingText = text
        }
    }
    
}

extension JTRefreshGIFHeaderView {
    
    
    override func headerDroping(_ progrss: CGFloat) {
        
        refreshGIFView.animationImages = normalImages
        refreshStatusLabel?.text = normalText == nil ? JTRefresh.headerNormal:normalText!
        refreshGIFView.startAnimating()
    }
    
    override func headerReadyRefresh() {
        
        refreshGIFView.animationImages = readyImages
        refreshStatusLabel?.text = readyText == nil ? JTRefresh.headerReady:readyText!
        refreshGIFView.startAnimating()
    }
    
    override func headerRefreshing() {
        
        refreshGIFView.animationImages = refreshImages
        refreshStatusLabel?.text = refreshingText == nil ? JTRefresh.headerRefreshing:refreshingText!
        self.lastRefreshDate = Date()
        refreshGIFView.startAnimating()
        
        target?.perform(headerSelector, with: nil, afterDelay: 0)
        self.headerBlock?()
    }
    
    override func headerStopRefresh() {
        
        self.refreshGIFView.stopAnimating()
        if !self.hiddenRefreshDate && self.lastRefreshDate != nil {
            let formatter = DateFormatter()
            if self.lastRefreshDate.jt_isToday() {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat = "MM-dd HH:mm"
            }
            self.lastRefreshDateLabel!.text = "最后更新:   " + (self.lastRefreshDate.jt_isToday() ? "今天 ":"") + formatter.string(from: self.lastRefreshDate)
        }
        
    }
    
}





