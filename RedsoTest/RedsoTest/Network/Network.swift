//
//  Network.swift
//  RedsoTest
//
//  Created by HENRY on 2019/12/17.
//  Copyright © 2019 jamba. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class Network: NSObject {
    
    static let sharedInstance = Network()
    
    let domain = "https://us-central1-redso-challenge.cloudfunctions.net"
    
    private override init() {
    
    }
    func request(url:String,par:Parameters?, header:HTTPHeaders?, completion: @escaping (Any) -> Void, failure: @escaping (AFError) -> Void) {
        DispatchQueue.global().async {
            
            let Url = self.domain + url
            AF.request(Url, method: .post, parameters: par, encoding: URLEncoding(destination: .queryString), headers: header, interceptor: nil).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            completion(value)
                        }
                    case .failure(let error):
                        failure(error)
                        print(error)
                    }
            }
        }
    }
}
