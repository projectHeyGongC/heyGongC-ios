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

class SettingsVC: BaseVC {
    
    @IBOutlet weak var btnNotificationSettings: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnDeleteUser: UIButton!
    
    private var viewModel = SettingsVM()

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
                
                guard let self = self else { return }
                
                if $0 {
                    navigationController?.backToIntro()
                }
            }.disposed(by: viewModel.bag)
        
        viewModel.completLogout
            .bind { [weak self] in
                
                guard let self = self else { return }
                
                if $0 {
                    navigationController?.backToIntro()
                }
            }
            .disposed(by: viewModel.bag)
    }
    
    private func bindAction() {
        btnNotificationSettings.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationSettings") as? NotificationSettingsVC else { return }
                
                navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: viewModel.bag)
        
        btnLogout.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                showAlert(localized: .DLG_LOGOUT,
                          confirm: { [weak self] in
                    
                    guard let self = self else { return }
                    viewModel.callLogout()
                })
            }
            .disposed(by: viewModel.bag)
        
        btnDeleteUser.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                self.showAlert(localized: .DLG_DELETE_USER,
                               confirm: { [weak self] in
                    guard let self = self else { return }
                    viewModel.callUnregister()
                })
                
            }.disposed(by: viewModel.bag)
    }
}
