//
//  JTScrollRefreshController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTScrollRefreshController: JTBaseRefreshViewController {
    
    private var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
    }
    
    private func setSubViews(){
        
        view.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: CGRect(x: 0, y: naviHeight, width: view.jt_width, height: view.jt_height-naviHeight))
        view.addSubview(scrollView)
        
        switch type {
            
        case .Normal:
            // 0.
//           scrollView.addRefreshWithTarget(self, headerAction: #selector(refreshLoading(_:)), footerAction: #selector(pullLoading(_:)), hiddenRefreshDate: false)
            // 1.
//           scrollView.addRefreshWithTarget(self, headerAction: #selector(refreshLoading(_:)), footerAction: nil, hiddenRefreshDate: false)
            // 2.
//           scrollView.addRefreshWithTarget(self, headerAction: nil, footerAction: #selector(pullLoading(_:)))
            
            // 3.
            let header = JTRefreshHeaderView(target: self, action: #selector(refreshLoading(_:)), hiddenRefreshDate: false)
            header.refreshStatusLabel?.textColor = UIColor.red
            header.setStatusText("header...0", for: .normal)
            header.setStatusText("header...1", for: .readyRefresh)
            header.setStatusText("header...2", for: .refreshing)
            scrollView.headerView = header
            let header2 = JTRefreshHeaderView(hiddenRefreshDate: false, { [weak self] in
                // 在这个闭包中调用的JTRefreshHeaderView，要弱引用，否则内存泄漏
                self?.refreshLoading {
                    
                }
            })
            header2.refreshStatusLabel?.textColor = UIColor.red
            header2.setStatusText("header2...0", for: .normal)
            header2.setStatusText("header2...1", for: .readyRefresh)
            header2.setStatusText("header2...2", for: .refreshing)
            scrollView.headerView = header2
            
            let footer = JTRefreshFooterView(target: self, action: #selector(pullLoading(_:)))
            footer.setStatusText("footer...0", for: .normal)
            footer.setStatusText("footer...1", for: .readyLoad)
            footer.setStatusText("footer...2", for: .loading)
            scrollView.footerView = footer
            let footer2 = JTRefreshFooterView({ [weak self] in
                // 在这个闭包中调用的JTRefreshFooterView， 要弱引用，否则内存泄漏
                self?.pullLoading({
                    
                })
            })
            footer2.setStatusText("footer2...0", for: .normal)
            footer2.setStatusText("footer2...1", for: .readyLoad)
            footer2.setStatusText("footer2...2", for: .loading)
            footer2.refreshStatusLabel?.textColor = UIColor.green
            scrollView.footerView = footer2
            
        case .GIF:
            var gifHeader: JTRefreshGIFHeaderView!
            gifHeader = JTRefreshGIFHeaderView(target: self, action: #selector(refreshLoading(_:)), hiddenDate: false, hiddenStatus: false)
            // or
            gifHeader = JTRefreshGIFHeaderView(hiddenDate: false, hiddenStatus: false, { [weak self] in
                self?.refreshLoading {
                    
                }
            })
            gifHeader.setImages([], for: .normal)
            gifHeader.setImages([], for: .readyRefresh)
            gifHeader.setImages(gifImages, for: .refreshing)
            gifHeader.setStatusText("gifHeader...0", for: .normal)
            gifHeader.setStatusText("gifHeader...1", for: .readyRefresh)
            gifHeader.setStatusText("gifHeader...2", for: .refreshing)
            gifHeader.refreshStatusLabel?.textColor = UIColor.cyan
            scrollView.headerView = gifHeader
            
            var gifFooter: JTRefreshGIFFooterView!
            gifFooter = JTRefreshGIFFooterView(target: self, action: #selector(pullLoading(_:)), hiddenStatus: true)
            // or
            gifFooter = JTRefreshGIFFooterView(hiddenStatus: true, { [weak self] in
                self?.pullLoading {
                    
                }
            })
            gifFooter.setImages(gifImages, for: .normal)
            gifFooter.setImages([], for: .readyLoad)
            gifFooter.setImages(gifImages, for: .loading)
//            gifFooter.setStatusText("gifFooter...0", for: .normal)
//            gifFooter.setStatusText("gifFooter...1", for: .readyRefresh)
//            gifFooter.setStatusText("gifFooter...2", for: .refreshing)
            gifFooter.refreshStatusLabel?.textColor = UIColor.cyan
            scrollView.footerView = gifFooter
            
        case .DIY:
            let diyHeader = JTRefreshDIYHeaderView()
            diyHeader.delegate = self
            scrollView.headerView = diyHeader
            
            let diyFooter = JTRefreshDIYFooterView({ [weak self] in
                self?.pullLoading {
                    
                }
            })
            scrollView.footerView = diyFooter
            
        }
    }
    
    /// *下拉
    override func refreshLoading(_ loadSucess: @escaping () -> Void) {
        
        super.refreshLoading {
            self.scrollView.headerStopRefresh()
        }
    }
    
    /// *上拉
    override func pullLoading(_ loadSucess: @escaping () -> Void) {
        
        super.pullLoading {
            self.scrollView.footerStopRefresh()
        }
    }
    

}


extension JTScrollRefreshController: JTHeaderDIYProtocol {
    
    func headerStartRefresh(_ headerView: JTRefreshDIYHeaderView) {
        self.refreshLoading {
            
        }
    }
 
}




