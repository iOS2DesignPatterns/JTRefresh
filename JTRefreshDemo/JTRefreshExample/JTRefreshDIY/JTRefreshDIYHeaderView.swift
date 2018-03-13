//
//  JTRefreshDIYHeaderView.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

@objc protocol JTHeaderDIYProtocol {
    
    // 开始刷新
    func headerStartRefresh(_ headerView: JTRefreshDIYHeaderView)
}

/**
     自定义headerView
 **/

import UIKit

class JTRefreshDIYHeaderView: JTRefreshHeader {

    private var progressView: UIProgressView!
    private var loadingView: UIActivityIndicatorView!
    
    weak var delegate: JTHeaderDIYProtocol?
    
    init() {
        super.init(target: nil)
        setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        progressView = UIProgressView(frame: .zero)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor.red
        progressView.tintColor = UIColor.white
        self.addSubview(progressView)
        let centerX = NSLayoutConstraint(item: progressView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: progressView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        let height = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 2)
        self.addConstraints([centerX, bottom])
        progressView.addConstraints([width, height])
        
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        self.addSubview(loadingView)
        
        let loadCenterX = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let loadCenterY = NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([loadCenterX, loadCenterY])
    }
    
    
}

extension JTRefreshDIYHeaderView {
    
    /// *下拉中
    override func headerDroping(_ progrss: CGFloat) {
        progressView.progress = Float(progrss)
    }
    
    /// *即将刷新
    override func headerReadyRefresh() {
        progressView.progress = 1
    }
    
    /// *开始刷新，刷新中 （刷新中，不会从复调用该方法）
    override func headerRefreshing() {
        loadingView.startAnimating()
        self.delegate?.headerStartRefresh(self)
    }
    
    /// *结束刷新
    override func headerStopRefresh() {
        loadingView.stopAnimating()
    }
    
}
