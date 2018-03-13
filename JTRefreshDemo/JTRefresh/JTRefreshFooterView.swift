//
//  JTRefreshFooterView.swift
//  ExpressPeople
//
//  Created by jintao on 2018/3/9.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
    正常上拉加载视图
 **/

import UIKit

class JTRefreshFooterView: JTRefreshFooter {
    
    // 上拉绑定的方法
    private var footerSelector: Selector!
    
    // 上拉执行的block
    private var footerBlock: JTRefresh.refreshBlock?
    
    // 上拉状态
    var refreshStatusLabel: UILabel?
    
    // 刷新动画
    private var refreshImageView: UIImageView!
    
    // 刷新指示器
    private var refreshIndicatorView: UIActivityIndicatorView!
    
    // *sateText
    private var normalText: String?
    private var readyText: String?
    private var loadingText: String?
    
    
    /// *init
    init(target: AnyObject, action: Selector) {
        super.init(target: target)
        self.footerSelector = action
        self.setSubViews()
    }
    
    init(_ footerBlock: @escaping JTRefresh.refreshBlock) {
        super.init(target: nil)
        self.footerBlock = footerBlock
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// *加载子视图
    private func setSubViews() {
        
        refreshStatusLabel = UILabel(frame: .zero)
        refreshStatusLabel!.translatesAutoresizingMaskIntoConstraints = false
        refreshStatusLabel!.textColor = UIColor.lightGray
        refreshStatusLabel!.font = UIFont.systemFont(ofSize: 15)
        refreshStatusLabel!.textAlignment = .center
        refreshStatusLabel!.text = JTRefresh.footerNormal
        self.addSubview(refreshStatusLabel!)
        
        let statusTop = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12)
        let statusCenterX = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let statusHeight = NSLayoutConstraint(item: refreshStatusLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
        refreshStatusLabel!.addConstraint(statusHeight)
        self.addConstraints([statusTop, statusCenterX])
        
        refreshImageView = UIImageView(frame: .zero)
        refreshImageView.translatesAutoresizingMaskIntoConstraints = false
        refreshImageView.contentMode = .scaleAspectFit
        if let bundlePath = Bundle.main.path(forResource: "JTRefresh", ofType: "bundle") {
            if let imageBundle = Bundle(path: bundlePath) {
                refreshImageView.image = UIImage(named: "pullUp(32)", in: imageBundle, compatibleWith: nil)
            }
        }
        self.addSubview(refreshImageView)
        let imageRight = NSLayoutConstraint(item: refreshImageView, attribute: .right, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .left, multiplier: 1, constant: -20)
        let imageHeight = NSLayoutConstraint(item: refreshImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 28)
        let imageWidth = NSLayoutConstraint(item: refreshImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 28)
        let imageCenterY = NSLayoutConstraint(item: refreshImageView, attribute: .centerY, relatedBy: .equal, toItem: refreshStatusLabel, attribute: .centerY, multiplier: 1, constant: 0)
        refreshImageView.addConstraints([imageHeight, imageWidth])
        self.addConstraints([imageRight, imageCenterY])

        refreshIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        refreshIndicatorView.hidesWhenStopped = true
        refreshIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(refreshIndicatorView)
        
        // *点击加载
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(startRefresh))
        self.addGestureRecognizer(clickTap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshIndicatorView.frame = refreshImageView.frame
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


extension JTRefreshFooterView {
    
    /// 上拉中...
    override func footerPulling(_ progrss: CGFloat) {
        
        self.refreshStatusLabel?.text = normalText == nil ? JTRefresh.footerNormal:normalText!
        refreshIndicatorView.stopAnimating()
        self.refreshImageView.isHidden = false
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            
            self.refreshImageView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
    /// *准备加载
    override func footerReadyLoad() {
        
        self.refreshStatusLabel?.text = readyText == nil ? JTRefresh.footerReady:readyText!
        UIView.animateKeyframes(withDuration: JTRefresh.refreshDuration, delay: 0, options: [.calculationModeCubic], animations: {
            
            self.refreshImageView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
        }, completion: nil)
    }
    
    /// *加载中
    override func footerLoading() {
        
        self.refreshStatusLabel?.text = loadingText == nil ? JTRefresh.footerLoading:loadingText!
        self.refreshImageView.isHidden = true
        self.refreshImageView.transform = CGAffineTransform.identity
        refreshIndicatorView.startAnimating()
        
        target?.perform(footerSelector, with: nil, afterDelay: 0)
        self.footerBlock?()
    }
    
    /// *停止加载
    override func footerStopLoad() {
        
    }
    
}








