//
//  WikiSeachAPIViewModel.swift
//  RxTest
//
//  Created by isami odagiri on 2019/09/01.
//  Copyright © 2019 dowel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WikiSeachAPIViewModel {
    
    var seachWord = BehaviorRelay<String>(value: "")
    var items = BehaviorRelay<[Result]>(value: [])
    
    private let model = WikiSeachAPIModel()
    private let disposeBag = DisposeBag()
//    イニシャライザ（初期化）
    init() {
        seachWord.asObservable()
            .filter { $0.count >= 3 }
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] str in
                return self.model.seach(["srsearch": str])
            }
            .bind(to: self.items)
            .disposed(by: self.disposeBag)
    }
}
