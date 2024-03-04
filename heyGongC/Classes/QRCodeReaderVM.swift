//
//  QRCodeReaderVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/17/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

class QRCodeReaderVM: BaseVM {
    
    struct Param {
        var type: String
        var deviceQR: String
    }
    
    public var param: QRCodeReaderVM.Param?
    public var successReadQR = BehaviorRelay<Bool>(value: false)
    
    func getDeviceType(qrData: String) {
        if let splitIndex = qrData.firstIndex(of: " ") {
            let afterFirstSpaceIndex = qrData.index(after: splitIndex)
            let type = qrData[afterFirstSpaceIndex..<qrData.endIndex]
            
            print("device Type: \(type), qrData: \(qrData)")
            param = Param(type: String(type), deviceQR: qrData)
            
            successReadQR.accept(true)
            return
        }
        successReadQR.accept(false)
    }
}
