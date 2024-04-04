//
//  CameraAnalysisVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class CameraAnalysisVM: BaseVM {
    
    struct Param {
        var data: AnalysisModel.Notification
    }
    
    public var param: Param {
        didSet {}
    }
    
    
    public func callAnalysisDetail() {
        AnalysisAPI.shared.networking(analysisService: .getDetail(deviceId: <#T##String#>, requestAt: <#T##String#>), type: <#T##(Decodable & Encodable).Protocol#>)
    }
}
