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
        bindViewModel()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... CameraSettingVC ViewModel]")
        self.viewFrontCamera.removeGestureRecognizer(frontCameraTapGesture)
        self.viewBackCamera.removeGestureRecognizer(backCameraTapGesture)
        onBack(vm: viewModel)
    }
    
    public func updateParam(deviceId: String) {
        viewModel.callDeviceInfo(deviceId: deviceId)
    }
}

extension CameraSettingVC {
    func bindViewModel(){
        let editNameAlertTrigger = btnEditDeviceName.rx.tap.flatMap{
            return Observable<String?>.create { observe in
                let alert = UIAlertController(title: Localized.DLG_DEVICE_NAME_EDIT.title, message: "", preferredStyle: .alert)
                
                alert.addTextField { textField in
                    textField.text = self.viewModel.deviceInfo.value?.deviceName
                }
                
                
                let leftAction = UIAlertAction(title: Localized.DLG_DEVICE_NAME_EDIT.confirmText, style: .default) { action in
                    if let name = alert.textFields?.first?.text {
                        print("name:\(name)")
                        observe.onNext(name)
                        observe.onCompleted()
                    }
                }
                
                leftAction.setValue(UIColor(red: 0/255, green: 104/255, blue: 119/255, alpha: 1), forKey: "titleTextColor")
                alert.addAction(leftAction)
                
                let rightAction = UIAlertAction(title: Localized.DLG_DEVICE_NAME_EDIT.cancelText, style: .cancel)
                
                rightAction.setValue(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), forKey: "titleTextColor")
                alert.addAction(rightAction)
                
                self.present(alert, animated: true)
                
                return Disposables.create()
            }
        }
        
        let changedSensitivityAlertTrigger = sliderSoundSensitivity.rx.controlEvent(.valueChanged)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ [weak self] _ in
                guard let self else { return }
                
                let normalizedValue = round(sliderSoundSensitivity.value/stepSize) * stepSize
                
                DispatchQueue.main.async{ [weak self] in
                    self?.sliderSoundSensitivity.value = normalizedValue
                }
            }
            .flatMap { observer in
                return Observable<Float>.create{ observe in
                    
                    self.showAlert(localized: Localized.DLG_SENSITIVITY_VALUE_EDIT) {
                        observe.onNext(self.sliderSoundSensitivity.value)
                        observe.onCompleted()
                    } cancel: {
                        if let currentValue = self.viewModel.deviceInfo.value?.sensitivity, let sensitivity = ControlMode.Sensitivity(rawValue: currentValue) {
                            self.sliderSoundSensitivity.value = sensitivity.sliderValue
                        }
                    }
                    
                    return Disposables.create()
                }
            }
        
        let changedOrientationAlertTrigger = Observable<ControlMode>.create{ observe in
            self.viewFrontCamera.addGestureRecognizer(self.frontCameraTapGesture)
            self.viewBackCamera.addGestureRecognizer(self.backCameraTapGesture)
            
            let frontObservable = self.frontCameraTapGesture.rx.event
                .map{ _ in return ControlMode.front }
            
            let backObservable = self.backCameraTapGesture.rx.event
                .map{ _ in return ControlMode.back }
            
            Observable.of(frontObservable, backObservable).merge()
                .subscribe{ mode in
                    var msg: Localized?
                    switch mode {
                    case .front:
                        msg = .DLG_FRONT_CAMERA
                    case .back:
                        msg = .DLG_BACK_CAMERA
                    default:
                        break
                    }
                    
                    if let msg = msg {
                        self.showAlert(localized: msg) {
                            observe.onNext(mode)
                        } cancel: { }
                    }
                }
                .disposed(by: self.viewModel.bag)
            
            return Disposables.create()
        }
        
        let input = CameraSettingVM.Input(editNameAlertTrigger: editNameAlertTrigger.asObservable(),
                                          changedSensitivityAlertTrigger: changedSensitivityAlertTrigger.asObservable(),
                                          changedCameraOrientationAlertTrigger: changedOrientationAlertTrigger.asObservable())
        
        configureViewModelOutput(viewModel.transform(input: input))
    }
    
    func configureViewModelOutput(_ output: CameraSettingVM.Output){
        output.deviceName
            .asDriver()
            .drive(lblDeviceName.rx.text)
            .disposed(by: viewModel.bag)
        
        output.deviceModelName
            .asDriver()
            .drive(lblDeviceModel.rx.text)
            .disposed(by:
                        viewModel.bag)
        
        output.showEditNameToast
            .skip(1)
            .filter { _ in true }
            .bind{ _ in
                self.showToast("정상적으로 변경되었습니다.")
            }
            .disposed(by: viewModel.bag)
        
        output.sensitivityValue
            .bind(to:sliderSoundSensitivity.rx.value)
            .disposed(by: viewModel.bag)
        
        output.frontOrientationImage
            .bind(to: imgFrontCamera.rx.image)
            .disposed(by: viewModel.bag)
        
        output.backOrientationImage
            .bind(to: imgBackCamera.rx.image)
            .disposed(by: viewModel.bag)
    }
}
