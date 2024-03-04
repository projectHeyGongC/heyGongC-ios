//
//  DeviceNamingVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/17/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults

class DeviceNamingVC: BaseVC {
    
    private let viewModel = DeviceNamingVM()
    
    @IBOutlet weak var txtFieldDeviceName: UITextField!
    @IBOutlet weak var btnDeviceRegister: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    
    override func initialize() {
        setTextFieldUI()
        
    }
    
    override func bind() {
        txtFieldDeviceName.rx.text
            .map{ text -> Bool in
                return text?.isEmpty == true ? true : false
            }
            .subscribe{ isEmpty in
                UIView.animate(withDuration: 0.2) {
                    self.btnDeviceRegister.backgroundColor = isEmpty ? GCColor.C_C4C4C4 : GCColor.C_FFC000
                    self.btnDeviceRegister.isEnabled = isEmpty ? false : true
                    self.txtFieldDeviceName.layer.borderColor = isEmpty ? GCColor.C_C4C4C4.cgColor : GCColor.C_006877.cgColor
                }
            }
            .disposed(by: viewModel.bag)
        
        btnDeviceRegister.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if let name = txtFieldDeviceName.text {
                    viewModel.name = name
                    viewModel.callAppendDevice()
                }
            }
            .disposed(by: viewModel.bag)
        
        btnDismiss.rx.tap
            .subscribe { _ in
                self.dismiss(animated: true)
            }
            .disposed(by: viewModel.bag)
            
        viewModel.successAppendDevice
            .bind { [weak self] in
                
                guard let self else { return }
                
                if $0 {
                    SegueUtils.open(target: self, link: .MainTBC)
                }
            }
            .disposed(by: viewModel.bag)
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    func updateParam(param: QRCodeReaderVM.Param){
        self.viewModel.param = param
    }
    
    deinit {
        print("[Clear... DeviceNamingVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension DeviceNamingVC: UITextFieldDelegate {
    private func setTextFieldUI(){
        if let clearButton = txtFieldDeviceName.value(forKey: "_clearButton") as? UIButton {
            
            guard let image = UIImage(named:"ic_xmark") else { return }
            clearButton.setImage(image.resized(to: CGSizeMake(20, 20)), for: .normal)
        }
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
