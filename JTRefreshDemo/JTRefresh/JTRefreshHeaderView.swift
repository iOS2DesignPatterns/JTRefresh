//
//  JTRefreshHeaderView.swift
//  ExpressPeople
//
//  Created by jintao on 2018/3/9.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
    正常下拉刷新视图
 **/

import UIKit

class JTRefreshHeaderView: JTRefreshHeader {
    
    // 下拉绑定的方法
    private var headerSelector: Selector!
    
    // 下拉执行的block
    private var headerBlock: JTRefresh.refreshBlock?
    
    // 隐藏刷新时间
    private var hiddenRefreshDate: Bool 
    
    // 最后一次刷新时间
    private var lastRefreshDate: Date!
    
    // 下拉状态
    var refreshStatusLabel: UILabel?
    
    // 最后刷新时间
    var lastRefreshDateLabel: UILabel?
    
    // 刷新图片
    private var refreshImageView: UIImageView!
    
    // 刷新指示器
    private var refreshIndicatorView: UIActivityIndicatorView!
    
    
    // *stateText
    private var normalText: String?
    private var readyText: String?
    private var refreshingText: String?
    
    
    /// * init
    init(target: AnyObject, action: Selector, hiddenRefreshDate: Bool = true) {
        self.hiddenRefreshDate = hiddenRefreshDate
        super.init(target: target)
        
        self.headerSelector = action
        self.setSubViews()
    }
    
    init(hiddenRefreshDate: Bool = true, _ headerBlock: @escaping JTRefresh.refreshBlock) {
        self.hiddenRefreshDate = hiddenRefreshDate
        super.init(target: nil)
        
        self.headerBlock = headerBlock
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// *子视图
    private func setSubViews() {
        
        refreshStatusLabel = UILabel(frame: .zero)
        refreshStatusLabel!.translatesAutoresizingMaskIntoConstraints = false
        refreshStatusLabel!.textColor = UIColor.lightGray
        refreshStatusLabel!.font = UIFont.systemFont(ofSize: 15)
        refreshStatusLabel!.textAlignment = .center
        refreshStatusLabel!.text = normalText == nil ? JTRefresh.headerNormal:normalText!
        self.addSubview(refreshStatusLabel!)
        
        let statusHeight = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
        refreshStatusLabel!.addConstraint(statusHeight)
        let statusCenterX = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(statusCenterX)
        
        if !hiddenRefreshDate {
            
            lastRefreshDateLabel = UILabel(frame: .zero)
            lastRefreshDateLabel!.translatesAutoresizingMaskIntoConstraints = false
            lastRefreshDateLabel!.textColor = UIColor.lightGray
            lastRefreshDateLabel!.font = UIFont.systemFont(ofSize: 14)
            lastRefreshDateLabel!.textAlignment = .center
            lastRefreshDateLabel!.text = JTRefresh.dateNormal
            self.addSubview(lastRefreshDateLabel!)
            
            let dateHeight = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21)
            lastRefreshDateLabel!.addConstraint(dateHeight)
            let dateCenterX = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let dateTop = NSLayoutConstraint(item: lastRefreshDateLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10)
            self.addConstraints([dateCenterX, dateTop])
            
            let statusBottom = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            self.addConstraint(statusBottom)
            
        } else {
            
            let statusCenterY = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            self.addConstraints([statusCenterY])
        }
        
        refreshImageView = UIImageView(frame: .zero)
        refreshImageView.translatesAutoresizingMaskIntoConstraints = false
        refreshImageView.contentMode = .scaleAspectFit
        if let bundlePath = Bundle.main.path(forResource: "JTRefresh", ofType: "bundle") {
            if let imageBundle = Bundle(path: bundlePath) {
                refreshImageView.image = UIImage(named: "dropDown(32)", in: imageBundle, compatibleWith: nil)
            }
        }
        self.addSubview(refreshImageView)
        let imageRight = NSLayoutConstraint(item: refreshImageView, attribute: .right, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .left, multiplier: 1, constant: -15)
        let imageHeight = NSLayoutConstraint(item: refreshImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 28)
        let imageWidth = NSLayoutConstraint(item: refreshImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 28)
        let imageCenterY = NSLayoutConstraint(item: refreshImageView, attribute: .centerY, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .centerY, multiplier: 1, constant: 0)
        refreshImageView.addConstraints([imageHeight, imageWidth])
        self.addConstraints([imageRight, imageCenterY])

        refreshIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        refreshIndicatorView.hidesWhenStopped = true
        refreshIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(refreshIndicatorView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshIndicatorView.frame = refreshImageView.frame
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

extension JTRefreshHeaderView {
    
    override func headerDroping(_ progrss: CGFloat) {
        
        self.refreshStatusLabel?.text = normalText == nil ? JTRefresh.headerNormal:normalText!
        refreshIndicatorView.stopAnimating()
        self.refreshImageView.isHidden = false
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            
            self.refreshImageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    override func headerReadyRefresh() {
        
        self.refreshStatusLabel?.text = readyText == nil ? JTRefresh.headerReady:readyText!
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            
            self.refreshImageView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
        }, completion: nil)
        
    }
    
    override func headerRefreshing() {
        
        self.refreshStatusLabel?.text = refreshingText == nil ? JTRefresh.headerRefreshing:refreshingText!
        self.refreshImageView.isHidden = true
        self.refreshImageView.transform = CGAffineTransform.identity
        refreshIndicatorView.startAnimating()
        // now
        self.lastRefreshDate = Date()
        
        target?.perform(headerSelector, with: nil, afterDelay: 0)
        self.headerBlock?()
    }
    
    override func headerStopRefresh() {
        
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


