//
//  RecordedVideoListVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import Charts

class RecordedVideoListVC: BaseVC {
    
    private let viewModel = RecordedVideoListVM()
    
    override func initialize() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        
    }
    
    deinit {
        print("[Clear... RecordedVideoListVC ViewModel]")
        onBack(vm: viewModel)
    }
}

