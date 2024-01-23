//
//  NotificationVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/23/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class NotificationVC: BaseVC {
    
    private let viewModel = NotificationVM()
    
    //MARK: LifeCycle
    override func initialize() {
        
    }
    
    override func bind() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... NotificationVC ViewModel]")
        onBack(vm: viewModel)
    }
    
}
