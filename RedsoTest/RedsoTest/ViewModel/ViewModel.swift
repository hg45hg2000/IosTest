//
//  ViewModel.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit

class ViewModel: NSObject , NSCoding{
    func encode(with coder: NSCoder) {
        coder.encode(profileData, forKey: "profileData")
        coder.encode(selectedTeam, forKey: "selectedTeam")
        coder.encode(currentPageIndex, forKey: "currentPageIndex")
    }
    
    required init?(coder: NSCoder) {
        
    }
    
    override init() {
        super.init()
    }
 
    var profileData : ProfileData!
    
    var selectedTeam : Team = .rangers
    
    var currentPageIndex : Int = 0
    
    func loadProfileAPI(loadMore:Bool, completion: @escaping () -> Void){
       CatalogAPI.requestCatalogData(team: selectedTeam, page: currentPageIndex ) { (data) in
               if loadMore {
                   // Infinite load
                   if data.results.count == 0 {
                       self.currentPageIndex = 0
                       self.loadProfileAPI(loadMore: true, completion:{ })
                   }else{
                       for result in data.results {
                             self.profileData.results.append(result)
                         }
                   }
               }
               else{
                   self.profileData = data
           }
        do {
               // saving the entire list
            try self.profileData.save()

           } catch { print(error) }
           completion()
        }
    }
    
}
