//
//  AnalysisVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class AnalysisVC: BaseVC {
    
    private let viewModel = AnalysisVM()
    
    override func initialize() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        
    }
    
    deinit {
        print("[Clear... AnalysisVC ViewModel]")
        onBack(vm: viewModel)
    }
}

