//
//  CreateAccountVC.swift
//  heyGongC
//
//  Created by 김은서 on 12/25/23.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class ExampleVC: BaseVC {

    private let viewModel = ExampleVM()

    override func initialize() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
//        alert 실행 예제
        
//            btnAdd.rx.tap
//                .bind(onNext: { [weak self] in
//                    
//                    self?.showAlert(localized: .DLG_TEST,
//                                    confirm: { print("confirm") },
//                                    cancel: { print("cancel") })
//                    
//                }).disposed(by: viewModel.bag)
    }
    
    deinit {
        print("[Clear... CreateAccountVC ViewModel]")
        onBack(vm: viewModel)
    }
}

