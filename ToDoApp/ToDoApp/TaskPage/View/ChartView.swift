//
//  ChartView.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import Foundation
import UIKit
import DGCharts

final class ChartView: UIView {
    
    private lazy var chartView = PieChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupChart()
    }

    private func setupChart() {
        addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.tintColor = .black

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configureChart(dataEntries: [PieChartDataEntry], chartTitle: String) {
        let dataSet: PieChartDataSet
        if dataEntries.count == 0 {
            dataSet = PieChartDataSet(entries: [PieChartDataEntry(value: 100)], label: "Пусто")
            dataSet.colors = [NSUIColor.gray]
        } else {
            dataSet = PieChartDataSet(entries: dataEntries, label: chartTitle)

            dataSet.colors = [
                NSUIColor.systemBlue,
                NSUIColor.systemRed
            ]
        }
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
        chartView.legend.enabled = true
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}
