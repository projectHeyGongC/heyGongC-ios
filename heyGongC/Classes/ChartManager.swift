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
        
        // 스크롤 및 확대/축소 설정
        barChartView.dragEnabled = true
        barChartView.setScaleEnabled(false)
        barChartView.scaleYEnabled = false // y축 방향 확대/축소 비활성화
        barChartView.scaleXEnabled = true  // x축 방향 확대/축소 활성화
        
        // 가로 스크롤만 가능하도록 설정
        barChartView.pinchZoomEnabled = false
        barChartView.highlightPerDragEnabled = true
        
        // x축 스크롤 범위 설정 (6시간)
        let visibleRange = 72 // 6시간에 해당하는 데이터 수 (5분 간격으로 총 72개의 데이터)
        let totalRange = 24 * 60 / 5 // 전체 시간 범위 (5분 간격으로 총 288개의 데이터)
        let initialVisibleStart = totalRange - visibleRange // 초기에 표시할 범위 시작 지점 (00:00시로 설정)

        barChartView.setVisibleXRangeMaximum(Double(visibleRange))
        barChartView.moveViewToX(Double(0))
        
        // No data 설정
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20, weight: .bold)
        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        // 범례 숨기기
        barChartView.legend.enabled = false
        
        barChartView.xAxis.setLabelCount(entryArray.count/12, force: false)
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.granularity = 12
        
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.leftAxis.granularity = 1.0
        barChartView.leftAxis.axisMinimum = 0 // 최소 y값 설정
        
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawLabelsEnabled = false
        
        let chartDataSet = BarChartDataSet(entries: entryArray, label: "알림 횟수")
        chartDataSet.colors = [barColor]
        chartDataSet.highlightEnabled = false
        chartDataSet.drawValuesEnabled = false // 바에 값 표시하지 않음
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 2.5
        barChartView.data = chartData
    }
    
    public func setBarChartXData(barChartView: BarChartView, xData: [String]) {
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xData)
    }
}
