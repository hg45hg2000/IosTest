//
//  SelectedView.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/18.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit

protocol SelectedViewDeleagate : NSObjectProtocol {
    func selectedViewSelected(selectedIndex:Int)
}

class SelectedView: UIView {

    
    weak var delegate : SelectedViewDeleagate?
    
    @IBOutlet weak var rangerButton: UIButton!
    @IBOutlet weak var elasticButton: UIButton!
    @IBOutlet weak var dynamoButton: UIButton!
    @IBOutlet weak var indicateView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)!
         // adding the top level view to the view hierarchy
         let view = (Bundle.main.loadNibNamed(SelectedView.IdentifierString(), owner: self, options: nil)![0])as! UIView
         self.addSubview(view)
         view.frame = bounds
     }
    
    @IBAction func buttonPress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.indicateView.frame.origin.x =  sender.frame.origin.x
            
        }
        delegate?.selectedViewSelected(selectedIndex: sender.tag)
    }
    func setselectedIndex(selectedIndex:Int){
        var moveX : CGFloat = 0.0
        switch selectedIndex {
        case 0: moveX = rangerButton.frame.origin.x
        case 1: moveX = elasticButton.frame.origin.x
        case 2: moveX = dynamoButton.frame.origin.x
        default:
            break
        }
        UIView.animate(withDuration: 0.3) {
            self.indicateView.frame.origin.x =  moveX 
            
        }
    }
}
