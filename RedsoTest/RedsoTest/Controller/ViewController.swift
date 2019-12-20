//
//  ViewController.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var topSelectedView: SelectedView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModelList  = ViewModelList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: TableViewCollectionViewCell.IdentifierString(), bundle: nil), forCellWithReuseIdentifier: TableViewCollectionViewCell.IdentifierString())
        collectionView.delegate = self
        collectionView.dataSource = self
        topSelectedView.delegate = self
    }
    
            
}
extension ViewController : SelectedViewDeleagate {
    
    func selectedViewSelected(selectedIndex: Int) {
        let moveX = collectionView.bounds.width * CGFloat(selectedIndex)
        let point = CGPoint(x: moveX, y: 0)
        collectionView.setContentOffset(point, animated: true)
        }
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelList.viewModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableViewCollectionViewCell.IdentifierString(), for: indexPath) as! TableViewCollectionViewCell
        let viewModel = viewModelList.viewModelList[indexPath.row]
        cell.viewWithTableView.viewModel = viewModel
        if viewModel.profileData == nil {
            viewModel.loadProfileAPI(loadMore: false, completion: {
                cell.viewWithTableView.reloadData()
            } )
            
        }
        return cell
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.zero
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        topSelectedView.setselectedIndex(selectedIndex: Int(page))
    }
}
