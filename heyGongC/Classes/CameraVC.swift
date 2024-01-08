//
//  CameraVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class CameraVC: BaseVC {
    
    private let viewModel = CameraVM()
    
    //MARK: LifeCycle
    override func initialize() {
        
    }
    
    override func bind() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... CameraVC ViewModel]")
        onBack(vm: viewModel)
    }
    
}
