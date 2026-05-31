//
//  PointsChartView.swift
//  Saboteur
//
//  Created by Henrique Lima on 02/04/26.
//

import SwiftUI
import Charts

struct PointsChartView: View {
    let data: [PointData]
    
    private var filteredData: [PointData] {
        let categories = Set(data.map { $0.category })
        let activeCategories = categories.filter { category in
            if category == "Pontos" {
                return true
            }
            return data.filter { $0.category == category }.contains { $0.points > 0 }
        }
        return data.filter { activeCategories.contains($0.category) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resumo Semanal")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Chart {
                ForEach(filteredData) { item in
                    LineMark(
                        x: .value("Dia", item.day),
                        y: .value("Pontos", item.points)
                    )
                    .foregroundStyle(by: .value("Categoria", item.category))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    

                    PointMark(
                        x: .value("Dia", item.day),
                        y: .value("Pontos", item.points)
                    )
                    .foregroundStyle(by: .value("Categoria", item.category))
                }
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic)
            }
            .chartForegroundStyleScale([
                "Pontos": Color.primaryTheme,
                "Denúncias": Color.red,
                "Tarefas": Color.gray
            ])
            .chartLegend(position: .bottom, spacing: 16)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    PointsChartView(data: [
        .init(day: "Seg", points: 10, category: "Pontos"),
        .init(day: "Ter", points: 25, category: "Pontos"),
        .init(day: "Qua", points: 45, category: "Pontos"),
        .init(day: "Seg", points: 2, category: "Denúncias"),
        .init(day: "Ter", points: 5, category: "Denúncias"),
        .init(day: "Qua", points: 3, category: "Denúncias"),
        .init(day: "Seg", points: 5, category: "Tarefas"),
        .init(day: "Ter", points: 8, category: "Tarefas"),
        .init(day: "Qua", points: 12, category: "Tarefas")
    ])
    .padding()
}
