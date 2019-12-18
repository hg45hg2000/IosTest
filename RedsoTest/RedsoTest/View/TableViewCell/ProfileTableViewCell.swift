//
//  TableViewCell.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftImageView.clipsToBounds = true
//        leftImageView.layer.masksToBounds = true
        leftImageView.layer.cornerRadius = leftImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadProfileData(profileDataResult:ProfileDataResult){
        if let url  = URL(string:profileDataResult.avatar){
            leftImageView.kf.setImage(with: url)
            
        }
        topLabel.text = profileDataResult.name
        middleLabel.text = profileDataResult.position
        bottomLabel.text = profileDataResult.expertiseString()
    }
    
}
