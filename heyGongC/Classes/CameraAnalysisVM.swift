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
    public var chartData = BehaviorRelay<[BarChartDataEntry]?>(value: nil)
    public var chartXData: [String] = []
    
    public func callAnalysisDetail() {
        guard let param,
              let deviceId = param.data.deviceID else { return }
        
        // kes 240410 'yyyy-MM-dd' 로 넘기기
        AnalysisAPI.shared
            .networking(analysisService: .getDetail(deviceId: deviceId, requestAt: param.date),type: AnalysisDetailModel.self)
            .subscribe(with: self, onSuccess: { owner, networkResult in
                
                switch networkResult {
                case .success(let response):
                    
                    self.name.accept(response?.deviceName ?? "")
                    self.date.accept(self.makeDate(date: response?.requestAt))
                    self.alarmCnt.accept("\(response?.alarmCount ?? 0)")

                    let data = self.setBarChartData(graphData: response?.graph)
                    self.chartData.accept(data)
                    
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callAnalysisDetail - error")
                
            }).disposed(by: self.bag)
    }
    
    private func makeDate(date: String?) -> String {
        var dateWithDash = ""
        
        if let onlyDate = date?.removeAllSign() {
            let month = onlyDate.substring(from: 4, to: 5)
            let day = onlyDate.substring(from: 6, to: 7)
            dateWithDash = "\(month)월 \(day)일"
        }
        
        return dateWithDash
    }
    
    private func setBarChartData(graphData: [AnalysisDetailModel.Graph]?) -> [BarChartDataEntry] {
        guard let graphData else { return [] }
        
        let xData: [String] = graphData.map({$0.x ?? ""})
        let yData: [Double] = graphData.map({Double($0.y ?? 0)})

        self.chartXData = xData
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<xData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yData[i])
            dataEntries.append(dataEntry)
        }
        return dataEntries
    }
}
