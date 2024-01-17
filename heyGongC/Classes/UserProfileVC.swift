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
    private var collectionViewHeightConstraint: Constraint?
    
    let viewModel = UserProfileVM()
    
    override func initialize() {
        collectionViewDeviceInfo.delegate = self
        collectionViewDeviceInfo.dataSource = self
        
        collectionViewDeviceInfo.snp.makeConstraints { make in
            collectionViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        updateCollectionViewHeight()
    }
    
    override func bind() {
        btnDisconnectAllDevices.rx.tap
            .bind{
                self.showAlert(localized: .DLG_DISCONNECTED_ALL_DIVICES, isAccent: true) {
                    
                } cancel: {
                    
                }
                
                
            }
            .disposed(by: disposeBag)
        
        btnAddDivice.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                viewModel.addDivice()
                updateCollectionViewHeight()
                collectionViewDeviceInfo.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    override func setupHandler() { }
    
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
}