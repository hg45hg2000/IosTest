//
//  ViewModelList.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/18.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewModelList: NSObject,NSCoding{
    func encode(with coder: NSCoder) {
        coder.encode(viewModelList, forKey: "viewModelList")
    }
    
    required init?(coder: NSCoder) {
        
    }
    
    
    override init() {
        super.init()
    }
    
    var viewModelList : [ViewModel] = {
        var list : [ViewModel] = []
        var viewModelOne = ViewModel()
        viewModelOne.selectedTeam = .rangers
        list.append(viewModelOne)
        
        var viewModelTwo = ViewModel()
        viewModelTwo.selectedTeam = .elastic
        list.append(viewModelTwo)
        
        var viewModelThree = ViewModel()
        viewModelThree.selectedTeam = .dynamo
        list.append(viewModelThree)

        return list
    }()
    
    func saveToLocal(){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        userDefaults.set(encodedData, forKey: "viewModelList")
        userDefaults.synchronize()
    }
    
    
    static func initLocalData()->ViewModelList?{
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "viewModelList")
        if let decoded = decoded {
           let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! ViewModelList
            return decodedTeams
        }
        return nil
    }
}
