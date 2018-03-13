//
//  JTCollectionRefreshController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTCollectionRefreshController: JTBaseRefreshViewController {

    private var collectionView: UICollectionView!
    private var numberItem: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setSubView()
    }
    
    private func setSubView() {
     
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.jt_width-5*10)/4, height: (view.jt_width-5*10)/4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: naviHeight, width: view.jt_width, height: view.jt_height-naviHeight), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "JTCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        // 这个默认是关闭的，必须把这个打开，当视图内容小于高度时，滑不动喔😂
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        switch self.type {
        case .Normal:
            collectionView.addRefreshWithTarget(self, headerAction: #selector(refreshLoading(_:)), footerAction: #selector(pullLoading(_:)))
            
        case .GIF:
            let gifHeader = JTRefreshGIFHeaderView(target: self, action: #selector(refreshLoading(_:)), hiddenDate: false, hiddenStatus: false)
            gifHeader.setImages(gifImages, for: .refreshing)
            collectionView.headerView = gifHeader
            
            let gifFooter = JTRefreshGIFFooterView(target: self, action: #selector(pullLoading(_:)), hiddenStatus: false)
            gifFooter.setImages([], for: .normal)
            gifFooter.setImages([], for: .readyLoad)
            gifFooter.setImages(gifImages, for: .loading)
            gifFooter.setStatusText("上拉或点击加载更多图片...", for: .normal)
            gifFooter.setStatusText("释放你的小手就可以看啦...", for: .readyLoad)
            gifFooter.setStatusText("加载中...", for: .loading)
            collectionView.footerView = gifFooter
            
        case .DIY:
            let diyHeader = JTRefreshDIYHeaderView()
            diyHeader.delegate = self
            collectionView.headerView = diyHeader
            
        }
        
    }
    
    
    /// *下拉
    override func refreshLoading(_ loadSucess: @escaping () -> Void) {
        super.refreshLoading {
            self.collectionView.headerStopRefresh()
            self.numberItem = 10
            self.collectionView.reloadData()
        }
    }
    
    /// *上拉
    override func pullLoading(_ loadSucess: @escaping () -> Void) {
        super.pullLoading {
            self.collectionView.footerStopRefresh()
            self.numberItem += 5
            self.collectionView.reloadData()
        }
    }


}

extension JTCollectionRefreshController: JTHeaderDIYProtocol {
    
    /// 加载
    func headerStartRefresh(_ headerView: JTRefreshDIYHeaderView) {
        self.refreshLoading {
            
        }
    }
  
}


extension JTCollectionRefreshController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
}



