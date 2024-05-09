//
//  UserProfileVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/9/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults

enum ActionType {
    case ok
    case cancel
}

class UserProfileVC: BaseVC {
    
    @IBOutlet weak var btnDisconnectAllDevices: UIButton!
    @IBOutlet weak var btnAddDivice: UIButton!
    @IBOutlet weak var collectionViewDeviceInfo: UICollectionView!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var imgViewSNSType: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    private var collectionViewHeightConstraint: Constraint?
    private var btnSettings: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.image = UIImage(named: "ic_gear")
        object.tintColor = .black
        return object
    }()
    
    private let viewModel = UserProfileVM()
    
    override func initialize() {
        collectionViewDeviceInfo.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = btnSettings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.callDeviceList()
        setupUI()
    }
    
    override func bind() {
        viewModel.deviceList
            .filterNil()
            .bind(to: collectionViewDeviceInfo.rx.items(
                cellIdentifier: DeviceInfoCollectionViewCell.identifier,
                cellType: DeviceInfoCollectionViewCell.self)){ index, element, cell in
                    
                    cell.btnDeviceSetting.tag = index
                    cell.updateDisplay(deviceName: element.deviceName ?? "")
            }
            .disposed(by: viewModel.bag)
        
        viewModel.deviceList
            .bind{ [weak self] _ in
                if let isHidden = self?.viewModel.deviceList.value?.isEmpty {
                    self?.collectionViewDeviceInfo.isHidden = isHidden ? true : false
                }
            }
            .disposed(by: viewModel.bag)
        
        btnDisconnectAllDevices.rx.tap
            .bind{
                self.showAlert(localized: .DLG_DISCONNECTED_ALL_DIVICES, isAccent: true) {
                    self.viewModel.disconnectDevices()
                    self.collectionViewDeviceInfo.reloadData()
                } cancel: { }
            }
            .disposed(by: viewModel.bag)
        
        btnAddDivice.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                guard let vc = Link.QRCodeReaderVC.viewController else { return }
                present(vc, animated: true)
            }
            .disposed(by: viewModel.bag)
        
        btnSettings.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC else { return }
                navigationController?.pushViewController(nextVC, animated: true)
                
            }
            .disposed(by: viewModel.bag)
    }
    
    
    
    private func setupUI(){
        viewModel.userEmail
            .bind(to: lblUserEmail.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.logintType
            .bind{ [weak self] type in
                guard let self else { return }
                imgViewSNSType.image = type?.image
                viewBackground.backgroundColor = type?.backgroundColor
            }
            .disposed(by: viewModel.bag)
        
        
        collectionViewDeviceInfo.reloadData()
        updateCollectionViewHeight()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... UserProfileVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension UserProfileVC {
    
    // 데이터가 업데이트된 후 호출되는 메서드
    private func updateCollectionViewHeight() {
        // 계산된 높이를 설정
        collectionViewHeightConstraint?.update(offset: calculateCollectionViewHeight())
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        // 셀 높이와 간격 등을 고려하여 갯수에 따른 높이 계산
        let cellHeight: CGFloat = 50.0  // 셀의 예상 높이
        let spacing: CGFloat = 10.0    // 셀 간격
        let numberOfCells = CGFloat(viewModel.deviceList.value?.count ?? 0)
        
        return numberOfCells * cellHeight + (numberOfCells - 1) * spacing
    }
}

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewDeviceInfo.bounds.width, height: 50)
    }
}

extension UserProfileVC {
    @IBAction func goSetting(_ sender: UIButton) {
        guard let deviceInfo = self.viewModel.deviceList.value?[exist: sender.tag],
        let deviceId = deviceInfo.deviceId else { return }
        
        if let vc = Link.CameraSettingVC.viewController as? CameraSettingVC {
            vc.updateParam(deviceId: deviceId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
