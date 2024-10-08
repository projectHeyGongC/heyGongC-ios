//
//  NotificationSettingsVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/10/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults
import RxRelay

class NotificationSettingsVC: BaseVC {
    
    @IBOutlet weak var viewBackground: UIView!
    
    private let viewModel =  NotificationSettingsVM()
    
    private var lblTitle: UILabel = {
        let object = UILabel()
        return object
    }()
    
    private var lblSubtitle: UILabel = {
        let object = UILabel()
        return object
    }()
    
    private var switchEventNotification: UISwitch = {
        let object = UISwitch()
        object.onTintColor = GCColor.C_FFC000
        
        object.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return object
    }()
    
    private var stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .vertical
        return object
    }()
    
    override func initialize() {
        setupUI()
    }
    
    override func bind() {
        
        switchEventNotification.rx.controlEvent(.valueChanged)
            .bind{ [weak self] _ in
                guard let self else { return }
                viewModel.changeNotificationStatus()
            }
            .disposed(by: viewModel.bag)
        
        viewModel.changedNotificationSetting
            .filterNil()
            .asDriver(onErrorJustReturn: false)
            .drive(switchEventNotification.rx.value)
            .disposed(by: viewModel.bag)
        
        viewModel.changedNotificationSetting
            .skip(1)
            .filterNil()
            .bind{ [weak self] result in
                guard let self else { return }
                showAlert(localized: result ? .DLG_NOTIFICATION_ON : .DLG_NOTIFICATION_OFF)
            }
            .disposed(by: viewModel.bag)
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... NotificationSettingsVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension NotificationSettingsVC {
    
    private func setupUI(){
        
        lblTitle.text = "이벤트 알림"
        lblTitle.font = .systemFont(ofSize: 12, weight: .regular)
        
        lblSubtitle.text = "이벤트 알림을 켜야 소리가 발생했을 때 알려드릴 수 있어요!"
        lblSubtitle.font = .systemFont(ofSize: 10, weight: .regular)
        lblSubtitle.numberOfLines = 2
        
        viewBackground.addSubview(stackView)
        viewBackground.addSubview(switchEventNotification)
        stackView.addArrangedSubview(lblTitle)
        stackView.addArrangedSubview(lblSubtitle)
        
        lblTitle.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        
        lblSubtitle.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(12)
        }
        
        switchEventNotification.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(stackView.snp.right)
        }
    }
}
