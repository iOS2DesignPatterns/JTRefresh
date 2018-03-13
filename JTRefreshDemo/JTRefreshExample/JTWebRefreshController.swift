//
//  JTWebRefreshController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTWebRefreshController: JTBaseRefreshViewController {

    private var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setSubViews()
    }
    
    private func setSubViews() {
        
        webView = UIWebView(frame: CGRect(x: 0, y: naviHeight, width: view.jt_width, height: view.jt_height-naviHeight))
        webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
        view.addSubview(webView)
        
        switch self.type {
        case .Normal:
            let header = JTRefreshHeaderView(target: self, action: #selector(headerLoadWeb))
            header.refreshStatusLabel?.textColor = UIColor.white
            header.setStatusText("下拉刷新网页...", for: .normal)
            header.setStatusText("释放即可刷新...", for: .readyRefresh)
            header.setStatusText("网页加载中...", for: .refreshing)
            webView.scrollView.headerView = header
            
        case .GIF:
            let gifHeader = JTRefreshGIFHeaderView(target: self, action: #selector(headerLoadWeb))
            gifHeader.setImages(gifImages, for: .refreshing)
            gifHeader.refreshStatusLabel?.textColor = UIColor.white
            gifHeader.setStatusText("下拉刷新网页...", for: .normal)
            gifHeader.setStatusText("释放即可刷新...", for: .readyRefresh)
            gifHeader.setStatusText("网页加载中...", for: .refreshing)
            webView.scrollView.headerView = gifHeader
            
        case .DIY:
            let diyHeader = JTRefreshDIYHeaderView()
            diyHeader.delegate = self
            webView.scrollView.headerView = diyHeader
            
            let diyFooter = JTRefreshDIYFooterView({ [weak self] in
                self?.pullLoading {
                    
                }
            })
            webView.scrollView.footerView = diyFooter
            
        }
    }
    
    
    @objc private func headerLoadWeb() {
        webView.loadRequest(URLRequest(url: URL(string: "https://github.com/")!))
        webView.scrollView.headerStopRefresh()
    }
    
}

extension JTWebRefreshController: JTHeaderDIYProtocol {
    
    func headerStartRefresh(_ headerView: JTRefreshDIYHeaderView) {
        self.headerLoadWeb()
    }

}


