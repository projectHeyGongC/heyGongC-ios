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
    
    //MARK: LifeCycle
    override func initialize() {
        
    }
    
    override func bind() {
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... MonitoringVC ViewModel]")
        onBack(vm: viewModel)
    }
    
}
