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
    
    public var deviceId: String?
    public var successReadQR = PublishRelay<Bool>()
    
    func getDeviceId(qrData: String) {
        
        guard let heygongCRange = qrData.range(of: "HeyGongC_") else {
            successReadQR.accept(false)
            return
        }
    
        let startIndex = heygongCRange.upperBound
        let deviceIdStr = qrData[startIndex...]
        print("deviceId: \(String(deviceIdStr))")
        deviceId = String(deviceIdStr)
        
        successReadQR.accept(true)
    }
}
