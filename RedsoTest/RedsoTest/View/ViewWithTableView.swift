//
//  ViewWithTableView.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
import ESPullToRefresh
class ViewWithTableView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ViewModel()
    
    var refreshControl:UIRefreshControl!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // adding the top level view to the view hierarchy
        let view = (Bundle.main.loadNibNamed(ViewWithTableView.IdentifierString(), owner: self, options: nil)![0])
        self.addSubview(view as! UIView)
    }
    override func awakeFromNib() {
        tableView.register(UINib(nibName: ProfileTableViewCell.IdentifierString(), bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.IdentifierString())
        tableView.register(UINib(nibName: ImageViewTableViewCell.IdentifierString(), bundle: nil), forCellReuseIdentifier: ImageViewTableViewCell.IdentifierString())
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControl.Event.valueChanged)
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            /// Do anything you want...
            /// ...
            /// If common end
            self.viewModel.currentPageIndex = self.viewModel.currentPageIndex + 1
            self.loadProfileAPI(team: self.viewModel.selectedTeam, page: self.viewModel.currentPageIndex, loadMore: true)
        }
    }
    @objc func refreshPull(){
        loadProfileAPI(team: viewModel.selectedTeam, page: 0, loadMore: false)
    }
    
    func loadProfileAPI(team : Team , page: Int,loadMore:Bool){
        viewModel.selectedTeam = team
        viewModel.currentPageIndex = page
        CatalogAPI.requestCatalogData(team: team, page: page) { (data) in
                if loadMore {
                    if data.results.count == 0 {
                        self.tableView.es.noticeNoMoreData()
                    }else{
                        for result in data.results {
                              self.viewModel.profileData.results.append(result)
                          }
                    }
                    self.loadData(profileDatas: self.viewModel.profileData)
                    self.tableView.es.stopLoadingMore()
                }
                else{
                    self.tableView.es.resetNoMoreData()
                    self.loadData(profileDatas: data)
                    self.refreshControl.endRefreshing()
            }
         }
     }
     
    private func loadData(profileDatas:ProfileData)  {
        viewModel.profileData = profileDatas
         DispatchQueue.main.async {
             self.tableView.reloadData()
         }
     }
}
extension ViewWithTableView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let profileData = viewModel.profileData  {
            return profileData.results.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profiledata = viewModel.profileData.results[indexPath.row]
        switch profiledata.type {
        case .banner:
             let cell = tableView.dequeueReusableCell(withIdentifier: ImageViewTableViewCell.IdentifierString(), for: indexPath) as! ImageViewTableViewCell
             if let url  = URL(string:profiledata.url){
                 cell.centerImageView.kf.setImage(with: url)
                 
             }
            return cell
        case .employee:
         let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.IdentifierString(), for: indexPath) as! ProfileTableViewCell
        cell.loadProfileData(profileDataResult: profiledata)
            return cell
        default:break
        }
        
    return UITableViewCell()
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let profiledata = viewModel.profileData.results[indexPath.row]
        switch profiledata.type {
        case .banner:
            return 200
        case .employee:
            return 120
        default:
            return 0
        }
    }
    
}
