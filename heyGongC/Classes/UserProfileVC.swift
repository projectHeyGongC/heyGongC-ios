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
        collectionViewDeviceInfo.dataSource = self
        
        collectionViewDeviceInfo.snp.makeConstraints { make in
            collectionViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        updateCollectionViewHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = btnSettings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    
    override func bind() {
        btnDisconnectAllDevices.rx.tap
            .bind{
                self.showAlert(localized: .DLG_DISCONNECTED_ALL_DIVICES, isAccent: true) {
                    
                } cancel: {
                    
                }
                
                
            }
            .disposed(by: viewModel.bag)
        
        btnAddDivice.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                viewModel.addDivice()
                updateCollectionViewHeight()
                collectionViewDeviceInfo.reloadData()
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
        lblUserEmail.text = KeyChains.shared.USER_DATA?.email
        setSNSTypeUI(type: KeyChains.shared.USER_DATA?.snsType)
    }
    
    private func setSNSTypeUI(type: String?){
        guard let type = type else { return }
        
        switch type {
        case "GOOGLE":
            viewBackground.backgroundColor = .white
            imgViewSNSType.image = UIImage(named: "ic_google")
        case "APPLE":
            viewBackground.backgroundColor = .black
            imgViewSNSType.image = UIImage(named: "ic_apple")
        case "KAKAO":
            viewBackground.backgroundColor = UIColor(named: "color_kakao")
            imgViewSNSType.image = UIImage(named: "ic_kakao")
        default:
            viewBackground.backgroundColor = .white
            imgViewSNSType.image = UIImage()
        }
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
        let numberOfCells = CGFloat(viewModel.devices.count)
        
        return numberOfCells * cellHeight + (numberOfCells - 1) * spacing
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeviceInfoCollectionViewCell.identifier, for: indexPath) as! DeviceInfoCollectionViewCell
        
        cell.configure(deviceName: viewModel.devices[indexPath.row])
        return cell
    }
    
    
}

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewDeviceInfo.bounds.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Monitoring", bundle: nil)
        guard let settingVC = storyboard.instantiateViewController(withIdentifier: "CameraSettingVC") as? CameraSettingVC else { return }
        navigationController?.pushViewController(settingVC, animated: true)
    }
}
