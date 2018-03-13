//
//  JTRefreshGIFFooterView.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
    GIF动态上拉刷新
 **/

import UIKit

class JTRefreshGIFFooterView: JTRefreshFooter {

    // 下拉绑定的方法(不暴露出来，不写到父类中)
    private var footerSelector: Selector!
    
    // 下拉执行的block
    private var footerBlock: JTRefresh.refreshBlock?
    
    // 是否隐藏下拉状态
    private var hiddenRefreshStatus: Bool
    
    // 上拉状态
    var refreshStatusLabel: UILabel?
        
    // 刷新动画
    private var refreshGIFView: UIImageView!
    
    // *stateImages
    private var normalImages: Array<UIImage>!
    private var readyImages: Array<UIImage>!
    private var refreshImages: Array<UIImage>!
    
    // *sateText
    private var normalText: String?
    private var readyText: String?
    private var loadingText: String?
    

    /// *init
    init(target: AnyObject, action: Selector, hiddenStatus: Bool = true) {
        self.hiddenRefreshStatus = hiddenStatus
        super.init(target: target)
        self.footerSelector = action
        self.setSubViews()
    }
    
    init(hiddenStatus: Bool = true, _ footerBlock: @escaping JTRefresh.refreshBlock) {
        self.hiddenRefreshStatus = hiddenStatus
        super.init(target: nil)
        self.footerBlock = footerBlock
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// *SubViews
    private func setSubViews() {
        
        // *添加动画
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
        
        // 下拉状态
        if hiddenRefreshStatus {
            let gifCenterX = NSLayoutConstraint(item: refreshGIFView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            self.addConstraint(gifCenterX)
            
        } else {
            refreshStatusLabel = UILabel(frame: .zero)
            refreshStatusLabel!.translatesAutoresizingMaskIntoConstraints = false
            refreshStatusLabel!.textColor = UIColor.lightGray
            refreshStatusLabel!.font = UIFont.systemFont(ofSize: 15)
            refreshStatusLabel!.textAlignment = .center
            refreshStatusLabel!.text = JTRefresh.footerNormal
            self.addSubview(refreshStatusLabel!)
            
            let statusCenterX = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let statusCenterY = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let statusHeight = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
            refreshStatusLabel!.addConstraint(statusHeight)
            self.addConstraints([statusCenterX, statusCenterY])
            
            let gifRight = NSLayoutConstraint(item: refreshGIFView, attribute: .right, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .left, multiplier: 1, constant: -15)
            self.addConstraint(gifRight)
        }
        
        // *点击加载
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(startRefresh))
        self.addGestureRecognizer(clickTap)
    }
    
    
    /// 设置刷新不同动画状态
    public func setImages(_ images: Array<UIImage>?, for state: JTRefresh.footerStatus) {
        
        switch state {
        case .normal:
            self.normalImages = images
            
        case .readyLoad:
            self.readyImages = images
       
        case .loading:
            self.refreshImages = images
        }
    }
    
    public func setStatusText(_ text: String, for state: JTRefresh.footerStatus) {
        
        switch state {
        case .normal:
            normalText = text
            self.refreshStatusLabel?.text = text
        case .readyLoad: readyText = text
        case .loading: loadingText = text
            
        }
    }
    
}


extension JTRefreshGIFFooterView {
    
    override func footerPulling(_ progrss: CGFloat) {
        refreshGIFView.animationImages = normalImages
        refreshStatusLabel?.text = normalText == nil ? JTRefresh.footerNormal:normalText!
        refreshGIFView.startAnimating()
    }
    
    override func footerReadyLoad() {
        refreshGIFView.animationImages = readyImages
        refreshStatusLabel?.text = readyText == nil ? JTRefresh.footerReady:readyText!
        refreshGIFView.startAnimating()
    }
    
    override func footerLoading() {
        refreshGIFView.animationImages = refreshImages
        refreshStatusLabel?.text = loadingText == nil ? JTRefresh.footerLoading:loadingText!
        refreshGIFView.startAnimating()
        
        target?.perform(footerSelector, with: nil, afterDelay: 0)
        self.footerBlock?()
    }
    
    override func footerStopLoad() {
        self.refreshGIFView.stopAnimating()
    }
    
}







