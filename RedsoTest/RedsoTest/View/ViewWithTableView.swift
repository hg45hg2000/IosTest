//
//  ViewWithTableView.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
import ESPullToRefresh

protocol ViewWithTableViewDataSource : NSObjectProtocol{
    func ViewWithTableViewNumberOfViewModel()->ViewModel
}


class ViewWithTableView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    weak var dataSource : ViewWithTableViewDataSource?
    
    var viewModel : ViewModel!
    
    var refreshControl:UIRefreshControl!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // adding the top level view to the view hierarchy
        let view = (Bundle.main.loadNibNamed(ViewWithTableView.IdentifierString(), owner: self, options: nil)![0])as! UIView
        self.addSubview(view)
    }
    override func awakeFromNib() {
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 0)
        tableView.register(UINib(nibName: ProfileTableViewCell.IdentifierString(), bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.IdentifierString())
        tableView.register(UINib(nibName: ImageViewTableViewCell.IdentifierString(), bundle: nil), forCellReuseIdentifier: ImageViewTableViewCell.IdentifierString())
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControl.Event.valueChanged)
        
        self.tableView.es.addInfiniteScrolling { [unowned self] in
            self.viewModel.currentPageIndex = self.viewModel.currentPageIndex + 1

            self.viewModel.loadProfileAPI(loadMore: true, completion: { 
                self.reloadData()
            })
        }
    }
    @objc func refreshPull(){
        viewModel.currentPageIndex = 0
        
        viewModel.loadProfileAPI(loadMore: false, completion: {
             DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
             }
        })
    }
         
     func reloadData()  {
         DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.es.stopLoadingMore()
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
