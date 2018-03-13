//
//  JTRefreshDIYFooterView.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
     自定义footerView
 **/

import UIKit

class JTRefreshDIYFooterView: JTRefreshFooter {
    
    var footerDIYBlock: ()->Void
    
    private var progressView: UIProgressView!
    private var loadingView: UIActivityIndicatorView!
    
    
    init(_ footerBlock: @escaping ()->Void) {
        self.footerDIYBlock = footerBlock
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
        let top = NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 2)
        let width = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        let height = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 2)
        self.addConstraints([centerX, top])
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

extension JTRefreshDIYFooterView {
    
    /// 上拉中
    override func footerPulling(_ progrss: CGFloat) {
        progressView.progress = Float(progrss)
    }
    
    /// 释放即可加载
    override func footerReadyLoad() {
        progressView.progress = 1
    }
    
    /// 开始加载，加载中
    override func footerLoading() {
        loadingView.startAnimating()
        self.footerDIYBlock()
    }
    
    /// 已经停止加载
    override func footerStopLoad() {
        loadingView.stopAnimating()
    }
    
}
