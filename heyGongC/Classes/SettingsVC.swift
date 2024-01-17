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
        btnDeleteUser.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                showAlert(localized: .DLG_DELETE_USER, isAccent: true) {
                    
                } cancel: {
                    
                }

            }
            .disposed(by: disposeBag)
        
        btnLogout.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                showAlert(localized: .DLG_LOGOUT) {
                    
                } cancel: {
                    
                }

            }
            .disposed(by: disposeBag)
    }
    
    override func setupHandler() { }
}