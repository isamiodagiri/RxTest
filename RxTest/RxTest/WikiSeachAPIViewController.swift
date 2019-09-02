//
//  WikiSeachAPIViewController.swift
//  RxTest
//
//  Created by isami odagiri on 2019/09/01.
//  Copyright © 2019 dowel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class WikiSeachAPIViewController: UIViewController {

    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var resTableView: UITableView!
    
    private let viewModel = WikiSeachAPIViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        検索欄の入力ワードをViewModelに渡す
        self.seachBar.rx.text.orEmpty
        .bind(to: self.viewModel.seachWord)
        .disposed(by: self.disposeBag)
        
//        検索結果をTabileViewのCellに渡す
        self.viewModel.items.asObservable()
        .bind(to: self.resTableView.rx.items(cellIdentifier: "resCell")){ index, res, cell in
            cell.textLabel?.text = res.title
            cell.detailTextLabel?.text = "https://ja.wikipedia.org/w/index.php?curid=\(res.id)"
        }
        .disposed(by: disposeBag)
        
        // セル選択時の処理
        self.resTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.resTableView.cellForRow(at: indexPath)
                if let strUrl = cell?.detailTextLabel?.text,
                    let url = URL(string: strUrl){
                    let safariView = SFSafariViewController(url: url)
                    self?.present(safariView, animated: true)
                }else{
                    print("error")
                }
            }).disposed(by: self.disposeBag)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
