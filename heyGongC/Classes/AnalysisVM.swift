//
//  AnalysisVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class AnalysisVM: BaseVM {
    var selectedDate = BehaviorRelay<Date?>(value: Date.now)
    var tableData = BehaviorRelay<[AnalysisModel.Notification]?>(value: nil)
    var videoImgUrl = BehaviorRelay<String?>(value: nil)
    
    public func updateDate(_ date: Date) {
        self.selectedDate.accept(date)
    }
    
    // MARK: - callAPI
    public func callAnalysis(date: Date?) {
        guard let date else { return }
        
        let stringDate = date.makeToY_M_D()
        
        AnalysisAPI.shared.networking(analysisService: .getAnalysis(requestAt: stringDate), type: AnalysisModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    var tableData = [AnalysisModel.Notification]()
                    
                    response?.notifications?.forEach({
                        tableData.append($0)
                    })
                    // kes 240410 최대 3개까지 빈데이터 전해줘서 해당 cell on/off 처리
                    for _ in 0 ..< 3 - (response?.notifications?.count ?? 0) {
                        tableData.append(AnalysisModel.Notification(deviceID: nil, deviceName: nil, contents: nil))
                    }
                    self.tableData.accept(tableData)
                    self.videoImgUrl.accept(response?.videos)
                    
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callAnalysis - error")
                
            }).disposed(by: self.bag)
    }
}
