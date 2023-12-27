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

class CreateAccountVC: BaseVC {
    
    private let viewModel = CreateAccountVM()
    
    override func initialize() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        
    }
    
    deinit {
        print("[Clear... CreateAccountVC ViewModel]")
        onBack(vm: viewModel)
    }
}

