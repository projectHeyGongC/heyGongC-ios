//
//  MonitoringVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class MonitoringVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!
    
    private let viewModel = MonitoringVM()
    
    private var btnSettings: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.image = UIImage(named: "ic_notification")
        object.tintColor = .black
        return object
    }()
    
    //MARK: LifeCycle
    override func initialize() {
        viewModel.fetchUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = btnSettings
    }
    
    override func bind() {
        
        viewModel.successFetchUserInfo
            .bind {
                if $0 {
                    
                }
            }
            .disposed(by: viewModel.bag)
        
        btnAdd.rx.tap
            .bind(onNext: { [weak self] in
                guard let self else { return }
                SegueUtils.open(target: self, link: .QRCodeReaderVC)
                
            }).disposed(by: viewModel.bag)
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... MonitoringVC ViewModel]")
        onBack(vm: viewModel)
    }
}
