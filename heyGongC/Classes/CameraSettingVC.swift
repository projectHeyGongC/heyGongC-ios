//
//  CameraSettingVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class CameraSettingVC: BaseVC {
    
    private let viewModel = CameraSettingVM()
    
    //MARK: LifeCycle
    override func initialize() {
        
    }
    
    override func bind() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... CameraSettingVC ViewModel]")
        onBack(vm: viewModel)
    }
}
