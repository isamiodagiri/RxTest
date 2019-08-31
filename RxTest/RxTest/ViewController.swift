//
//  ViewController.swift
//  RxTest
//
//  Created by isami odagiri on 2019/08/31.
//  Copyright © 2019 dowel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var button: UIButton!

    
    private let apiRequest = ApiRequest()
    private let disponsBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.rx.text
            .bind(to: labelText.rx.text)
            .disposed(by: disponsBag)
        button.rx.tap
            .subscribe { [unowned self] _ in
                self.start()
            }
            .disposed(by: disponsBag)
        
    }
    private func getResult() -> Observable<DataResponse<Any>> {
        return self.apiRequest.getResponse()
    }
    
    private func start() {
        print("始まり")
        getResult()
            .subscribe(
                onNext: { res in
                    if let json: JSON = JSON(res.value) {
                        self.jsonParse(Json: json)
                    }else{
                        print("エラー：\(res.error)")
                    }
            },
                onCompleted: {
                    print("終わり")
            }
            ).disposed(by: disponsBag)
    }
    
    private func jsonParse(Json: JSON) {
        let json = JSON(Json)
        json["pinpointLocations"].forEach{ (_, json) in
            print(json["name"])
            print(json["link"])
        }
    }
}

class ApiRequest {
    
    private let baseUrl: String = "http://weather.livedoor.com/forecast/webservice/json/v1?city=200010"

    func getResponse() -> Observable<DataResponse<Any>> {
        return Observable.create { observer in
            Alamofire.request(self.baseUrl)
                .responseJSON{response in
                    print("JSONあげるわ")
                    observer.onNext(response)
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
