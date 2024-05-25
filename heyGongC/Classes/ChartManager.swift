//
//  ChartManager.swift
//  heyGongC
//
//  Created by 김은서 on 5/6/24.
//

import Foundation
import Charts

class ChartManager {
    static let shared = ChartManager()
    
    /// 바차트 그리기
    /// - Parameters:
    ///   - barChartView: 만들 바차트
    ///   - entryArray: 차트에 넣을 데이터
    ///   - barColor: bar 색
    public func drawChart(barChartView: BarChartView, entryArray: [BarChartDataEntry], barColor: UIColor) {
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20, weight: .bold)
        barChartView.dragXEnabled = true
        barChartView.dragYEnabled = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        barChartView.xAxis.setLabelCount(entryArray.count, force: false)
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.axisLineWidth = 3

        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.leftAxis.drawLabelsEnabled = true

        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawLabelsEnabled = false
        
        let chartDataSet = BarChartDataSet(entries: entryArray, label: "알림 횟수")
        chartDataSet.colors = [barColor]
        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    public func setBarChartXData(barChartView: BarChartView, xData: [String]) {
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xData)
    }
}
