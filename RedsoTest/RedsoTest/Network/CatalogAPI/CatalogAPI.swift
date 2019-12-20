//
//  CatalogAPI.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit

enum Team : String , Codable{
    case rangers
    case elastic
    case dynamo
}

class CatalogAPI: NSObject {
    static func  requestCatalogData(team:Team, page:Int, completion: @escaping (ProfileData) -> Void){
        
        Network.sharedInstance.request(url:"/catalog" , par: ["team":team.rawValue,
                                                              "page":page], header: nil, completion: { (data) in
            completion(ProfileData(fromDictionary: data as! [String : Any]))
        }){ (error) in
            if let data = UserDefaults.standard.object(forKey: team.rawValue) {
                if page == 0 {
                   completion(ProfileData(fromDictionary: data as! [String : Any]))
                }
            }
        }
    }
}
