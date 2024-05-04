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
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAlarmCnt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    private let viewModel = CameraAnalysisVM()
    
    override func initialize() {
        self.view.backgroundColor = GCColor.C_F5F5F5
        self.viewModel.callAnalysisDetail()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        bindText()
    }
    
    deinit {
        print("[Clear... CameraAnalysisVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension CameraAnalysisVC {
    private func bindText() {
        viewModel.name
            .bind(to: lblName.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.date
            .bind(to: lblDate.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.alarmCnt
            .bind(to: lblAlarmCnt.rx.text)
            .disposed(by: viewModel.bag)
    }
}

extension CameraAnalysisVC {
    public func updateParam(param: CameraAnalysisVM.Param) {
        self.viewModel.param = param
    }
    
}
