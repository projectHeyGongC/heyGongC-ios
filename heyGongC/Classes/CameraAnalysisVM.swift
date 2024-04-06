//
//  CameraAnalysisVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

class CameraAnalysisVM: BaseVM {
    
    struct Param {
        var data: AnalysisModel.Notification
        var date: String
    }
    
    public var param: Param?
    public var name = BehaviorRelay<String>(value: "")
    public var date = BehaviorRelay<String>(value: "")
    public var alarmCnt = BehaviorRelay<String>(value: "")
//    public var chartDate = BehaviorRelay<>
    
    
    public func callAnalysisDetail() {
        guard let param,
              let deviceId = param.data.deviceID else { return }
        
        AnalysisAPI.shared
            .networking(analysisService: .getDetail(deviceId: deviceId, requestAt: param.date),type: AnalysisDetailModel.self)
            .subscribe(with: self, onSuccess: { owner, networkResult in
                
                switch networkResult {
                case .success(let response):
                    
                    self.name.accept(response?.deviceName ?? "")
                    self.date.accept(self.makeDate(date: response?.requestAt))
                    self.alarmCnt.accept("\(response?.alarmCount ?? 0)")
                    
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callAnalysisDetail - error")
                
            }).disposed(by: self.bag)
    }
    
    private func makeDate(date: String?) -> String {
        let month = date?.substring(from: 2, to: 3) ?? ""
        let day = date?.substring(from: 4, to: 5) ?? ""
        
        return "\(month)월 \(day)일"
    }
}
