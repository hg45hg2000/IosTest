//
//  ViewController.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    

    @IBOutlet weak var contentTableView: ViewWithTableView!
    
    @IBOutlet weak var topSelectedView: SelectedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topSelectedView.delegate = self
        contentTableView.loadProfileAPI(team: .rangers, page: 0, loadMore: false)
    }

            
}
extension ViewController : SelectedViewDeleagate {
    
    func selectedViewSelected(selectedIndex: Int) {
        var team = Team.dynamo
            switch selectedIndex {
            case 0:
                team = .dynamo
            case 1:
                team = .elastic
            case 2:
                team = .rangers
            default: break
            }
        contentTableView.tableView.setContentOffset(CGPoint.zero, animated: false)
        contentTableView.loadProfileAPI(team: team, page: 0, loadMore: false)
        }
}
