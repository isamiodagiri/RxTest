//
//  WikiSeachAPIModel.swift
//  RxTest
//
//  Created by isami odagiri on 2019/09/01.
//  Copyright © 2019 dowel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class WikiSeachAPIModel {
    
    private let client = APICliant()
    private let disposeBag = DisposeBag()

    func seach(_ para:[String:String]) -> Observable<[Result]> {
        return Observable<[Result]>.create{ (obserber) -> Disposable in
            let req = self.client.getReq(para: para).responseJSON{ res in
                if let error = res.error{
                    obserber.onError(error)
                }
                let result = self.parseJson(JSON(res.result.value!))
                obserber.onNext(result)
                obserber.onCompleted()
            }
            return Disposables.create{req.cancel()}
        }
    }
    
    private func parseJson(_ json: JSON) -> [Result] {
        var results = [Result]()
        json["query"]["search"].forEach { (val,item) in
            let t:String = item["title"].string!
            let i:Int = item["pageid"].int!
            results.append(Result(title: t, id: i))
        }
        return results
    }
}
