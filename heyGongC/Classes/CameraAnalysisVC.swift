//
//  CameraAnalysisVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class CameraAnalysisVC: BaseVC {
    
    private let viewModel = CameraAnalysisVM()
    
    override func initialize() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        
    }
    
    deinit {
        print("[Clear... CameraAnalysisVC ViewModel]")
        onBack(vm: viewModel)
    }
}

