//
//  JTTableRefreshController.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/13.
//  Copyright © 2018年 jintao. All rights reserved.
//

import UIKit

class JTTableRefreshController: JTBaseRefreshViewController {
    
    private var tableView: UITableView!
    
    private var numberRow: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
    }
    
    private func setSubViews() {
        tableView = UITableView(frame: CGRect(x: 0, y: naviHeight, width: view.jt_width, height: view.jt_height-naviHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        
        switch self.type {
            
        case .Normal:
            tableView.addRefreshWithTarget(self, headerAction: #selector(refreshLoading(_:)), footerAction: #selector(pullLoading(_:)), hiddenRefreshDate: false)
            tableView.footerView?.refresh_height = 40
            
        case .GIF:
            /// =====header
            var header: JTRefreshGIFHeaderView!
            header = JTRefreshGIFHeaderView(target: self, action: #selector(refreshLoading(_:)), hiddenDate: true, hiddenStatus: false)
            // or
            header = JTRefreshGIFHeaderView(hiddenDate: true, hiddenStatus: false, { [weak self] in
                self?.refreshLoading({
                    
                })
            })
            header.refreshStatusLabel?.textColor = UIColor.blue
            header.setImages(gifImages, for: .refreshing)
            tableView.headerView = header
            
            /// =====footer
            var footer: JTRefreshGIFFooterView!
            footer = JTRefreshGIFFooterView(target: self, action: #selector(pullLoading(_:)), hiddenStatus: false)
            // or
            footer = JTRefreshGIFFooterView(hiddenStatus: false, { [weak self] in
                self?.pullLoading {
                    
                }
            })
            footer.setImages(gifImages, for: .loading)
            tableView.footerView = footer
            
        case .DIY:
            let diyHeader = JTRefreshDIYHeaderView()
            diyHeader.delegate = self
            diyHeader.refresh_height = 60
            tableView.headerView = diyHeader
            
            let diyFooter = JTRefreshDIYFooterView({ [weak self] in
                self?.pullLoading {
                    
                }
            })
            tableView.footerView = diyFooter
            tableView.footerView?.refresh_height = 100
            
        }
        
    }
    
    /// *下拉
    override func refreshLoading(_ loadSucess: @escaping () -> Void) {
        
        super.refreshLoading {
            self.tableView.headerStopRefresh()
            self.numberRow = 5
            self.tableView.reloadData()
        }
    }
    
    /// *上拉
    override func pullLoading(_ loadSucess: @escaping () -> Void) {
        
        super.pullLoading {
            self.tableView.footerStopRefresh()
            self.numberRow += 5
            self.tableView.reloadData()
        }
    }


}

/// MARK: - HeaderDIYProtocol
extension JTTableRefreshController: JTHeaderDIYProtocol {
    
    func headerStartRefresh(_ headerView: JTRefreshDIYHeaderView) {
        self.refreshLoading {
            
        }
    }
  
}

/// MARK: - tableView
extension JTTableRefreshController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JTBaseCell.cell(tableview: tableView)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
    
}




