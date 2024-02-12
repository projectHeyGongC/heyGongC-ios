//
//  SettingsVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/15/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults

class SettingsVC: BaseVC {
    
    @IBOutlet weak var btnNotificationSettings: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnDeleteUser: UIButton!
    
    private var viewModel = SettingsVM()
    
    override func initialize() {
        
    }
    
    override func bind() {
        bindApi()
        bindAction()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... SettingsVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension SettingsVC {
    
    private func bindApi() {
        viewModel.completeUnregister
            .bind { [weak self] in
                
                if $0 {
                    Defaults.removeAll()
                    self?.navigationController?.backToIntro()
                }
            }.disposed(by: viewModel.bag)
    }
    
    private func bindAction() {
            btnDeleteUser.rx.tap
                .bind{ [weak self] in
                    guard let self = self else { return }
                    self.showAlert(localized: .DLG_DELETE_USER, 
                                   confirm: { [weak self] in
                        
                        self?.viewModel.callUnregister()
                    })

                }
                .disposed(by: viewModel.bag)
            
            btnLogout.rx.tap
                .bind{ [weak self] in
                    guard let self = self else { return }
                    showAlert(localized: .DLG_LOGOUT) {
                        
                    } cancel: {
                        
                    }

                }
                .disposed(by: viewModel.bag)
            
            btnNotificationSettings.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationSettings") as? NotificationSettingsVC else { return }
                    
                    navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: viewModel.bag)
    }
}
