//
//  CameraSettingVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional
import SwiftyUserDefaults

class CameraSettingVC: BaseVC {
    
    enum Sensitivity: String {
        case VERYLOW
        case LOW
        case MEDIUM
        case HIGH
        case VERYHIGH
        
        var sliderValue: Float {
            switch self {
            case .VERYLOW:
                return 0.0
            case .LOW:
                return 0.25
            case .MEDIUM:
                return 0.5
            case .HIGH:
                return 0.75
            case .VERYHIGH:
                return 1.0
            }
        }
    }
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDeviceModel: UILabel!
    @IBOutlet weak var btnEditDeviceName: UIButton!
    @IBOutlet weak var sliderSoundSensitivity: UISlider!
    @IBOutlet weak var viewFrontCamera: UIView!
    @IBOutlet weak var imgFrontCamera: UIImageView!
    @IBOutlet weak var viewBackCamera: UIView!
    @IBOutlet weak var imgBackCamera: UIImageView!
    @IBOutlet weak var lblDeviceStatus: UILabel!
    @IBOutlet weak var btnRemoteStreamingSetting: UIButton!
    @IBOutlet weak var btnDisconnected: UIButton!
    
    private var stepSize: Float = 0.25
    private let frontCameraTapGesture = UITapGestureRecognizer()
    private let backCameraTapGesture = UITapGestureRecognizer()
    private let viewModel = CameraSettingVM()
    
    //MARK: LifeCycle
    override func initialize() { }
    
    override func bind() {
        bindAction()
        bindUI()
    }
    
    func bindAction(){
        viewFrontCamera.addGestureRecognizer(frontCameraTapGesture)
        viewBackCamera.addGestureRecognizer(backCameraTapGesture)
        
        // jyj 20240417 카메라 이름 변경
        btnEditDeviceName.rx.tap
            .bind{ [weak self] in
                guard let self else { return }
                presentDeviceSettingAlert()
            }
            .disposed(by: viewModel.bag)
        
        // jyj 20240417 민감도 설정
        sliderSoundSensitivity.rx.value
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ [weak self] value -> Sensitivity? in
                guard let self else { return nil }
                let normalizedValue = round(sliderSoundSensitivity.value/stepSize) * stepSize

                DispatchQueue.main.async{
                    self.sliderSoundSensitivity.value = normalizedValue
                }
                
                switch normalizedValue {
                case 0.0:
                    return .VERYLOW
                case 0.25:
                    return .LOW
                case 0.5:
                    return .MEDIUM
                case 0.75:
                    return .HIGH
                case 1.0:
                    return .VERYHIGH
                default:
                    return nil
                }
            }
            .filterNil()
            .bind{ [weak self] value in
                guard let self else { return }
                
                showAlert(localized: Localized.DLG_SENSITIVITY_VALUE_EDIT) {
                    self.viewModel.editSensitivity(sensitivity: value.rawValue, orientation: self.viewModel.deviceInfo.value?.cameraOrientation)
                } cancel: {
                    if let currentValue = self.viewModel.deviceInfo.value?.sensitivity, let sensitivity = Sensitivity(rawValue: currentValue) {
                        self.sliderSoundSensitivity.value = sensitivity.sliderValue
                    }
                }
            }
            .disposed(by: viewModel.bag)
        
        // jyj 20240417 카메라 전면 후면
        frontCameraTapGesture.rx.event
            .bind{ [weak self] _ in
                self?.viewModel.cameraOrientationRelay.accept("FRONT")
                
                self?.presentCameraOrientationSettingAlert(orientation: "FRONT")
            }
            .disposed(by: viewModel.bag)
        
        backCameraTapGesture.rx.event
            .bind{ [weak self] _ in
                self?.viewModel.cameraOrientationRelay.accept("BACK")
                
                self?.presentCameraOrientationSettingAlert(orientation: "BACK")
            }
            .disposed(by: viewModel.bag)
        
        // jyj 20240417 원격 스트리밍 제어 함수 추가 필요
        /*btnRemoteStreamingSetting.rx.tap
            .bind{ [weak self] in
                
            }
            .disposed(by: viewModel.bag)*/
        
        // jyj 20240417 기기 연동 해제
        btnDisconnected.rx.tap
            .bind{ [weak self] in
                self?.showAlert(localized: Localized.DLG_CAMERA_DISCONNECT){
                    self?.viewModel.deviceDisconnect()
                } cancel: { }
            }
            .disposed(by: viewModel.bag)
        
        viewModel.successDisconnected
            .filter { $0 == true }
            .bind{ [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: viewModel.bag)
    }
    
    func bindUI(){
        viewModel.deviceInfo
            .map{ $0?.deviceName }
            .filterNil()
            .bind(to: lblDeviceName.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.deviceInfo
            .map{ $0?.modelName }
            .filterNil()
            .bind(to: lblDeviceModel.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.deviceInfo
            .map{ $0?.sensitivity }
            .filterNil()
            .map{ value -> Float in
                return Sensitivity(rawValue: value)?.sliderValue ?? 0.0
            }
            .bind(to: sliderSoundSensitivity.rx.value)
            .disposed(by: viewModel.bag)
        
        viewModel.deviceInfo
            .map{ $0?.cameraOrientation }
            .filterNil()
            .bind{ [weak self] value in
                guard let self else { return }
                
                viewModel.cameraOrientationRelay.accept(value)
            }
            .disposed(by: viewModel.bag)
        
        viewModel.cameraOrientationRelay
            .bind{ [weak self] value in
                guard let self else { return }
                if value == "FRONT" {
                    imgFrontCamera.image = UIImage(named: "ic_radioButton_on")
                    imgBackCamera.image = UIImage(named: "ic_radioButton_off")
                } else {
                    imgFrontCamera.image = UIImage(named: "ic_radioButton_off")
                    imgBackCamera.image = UIImage(named: "ic_radioButton_on")
                }
            }
            .disposed(by: viewModel.bag)
        
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... CameraSettingVC ViewModel]")
        onBack(vm: viewModel)
    }
    
    private func presentCameraOrientationSettingAlert(orientation: String){
        showAlert(localized: orientation == "FRONT" ? Localized.DLG_FRONT_CAMERA : Localized.DLG_BACK_CAMERA) { [weak self] in
            self?.viewModel.editSensitivity(sensitivity: self?.viewModel.deviceInfo.value?.sensitivity, orientation: orientation)
        } cancel: { [weak self] in
            self?.viewModel.cameraOrientationRelay.accept(self?.viewModel.deviceInfo.value?.cameraOrientation)
        }
    }
    
    private func presentDeviceSettingAlert(){
        let alert = UIAlertController(title: Localized.DLG_DEVICE_NAME_EDIT.title, message: "", preferredStyle: .alert)
        
        
        alert.addTextField { textField in
            textField.text = self.viewModel.deviceInfo.value?.deviceName
        }
        
        
        let leftAction = UIAlertAction(title: Localized.DLG_DEVICE_NAME_EDIT.confirmText, style: .default) { action in
            if let name = alert.textFields?.first?.text {
                print("name:\(name)")
                self.viewModel.editDeviceName(name: name)
            }
        }
        
        leftAction.setValue(UIColor(red: 0/255, green: 104/255, blue: 119/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(leftAction)
        
        let rightAction = UIAlertAction(title: Localized.DLG_DEVICE_NAME_EDIT.cancelText, style: .cancel)
        
        rightAction.setValue(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), forKey: "titleTextColor")
        alert.addAction(rightAction)
        
        present(alert, animated: true)
    }
}

extension CameraSettingVC {
    public func updateParam(deviceId: String) {
        viewModel.callDeviceInfo(deviceId: deviceId)
    }
}
