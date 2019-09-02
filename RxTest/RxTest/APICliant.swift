//
//  APICliant.swift
//  RxTest
//
//  Created by isami odagiri on 2019/09/01.
//  Copyright © 2019 dowel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APICli {
    var url:String { get }
    func getReq(para:[String:String]) -> DataRequest
}

class APICliant : APICli {
//    Wikiのエンドポイント
    var url = "https://ja.wikipedia.org/w/api.php?format=json&action=query&list=search"
    
    func getReq( para:[String:String]) -> DataRequest {
        return Alamofire.request(URL(string:url)!, parameters: para, encoding: URLEncoding.default, headers: nil)
    }
    
}
