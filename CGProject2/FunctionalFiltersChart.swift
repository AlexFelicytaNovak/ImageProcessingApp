//
//  FunctionalFiltersChart.swift
//  CGProject2
//
//  Created by Aleksandra Novák on 27/03/2023.
//

import SwiftUI
import Charts

struct FunctionalFiltersChart: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        Chart(viewModel.filterChart, id: \.x) {
            LineMark(
                x: .value("x", $0.x),
                y: .value("y", $0.y)
            ).foregroundStyle(Color.pink)
                .symbol(.circle)
        }
        .disabled(viewModel.selectedFunctionalFilter == FunctionFilters.gammaCorrection)
        .frame(width: 256, height: 256)
        .padding(.trailing, 80)
        .padding(.leading, 30)
        .chartXScale(domain: 0...255)
        .chartYScale(domain: 0...255)
        .chartYAxis {
            AxisMarks (position: .leading, values: [0, 255]) {
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
            }
            
            AxisMarks (position: .leading, values: [0, 128, 255]){value in
                AxisValueLabel("\(value.as(Int.self)!)")
            }
        }
        .chartXAxis {
            AxisMarks (values: [0, 255]) {
                AxisGridLine( stroke: StrokeStyle(lineWidth: 1))
            }
            
            AxisMarks(preset: .aligned, position: .bottom, values: [0, 128, 255]){ value in
                AxisValueLabel("\(value.as(Int.self)!)")
                
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in

                                let origin = geometry[proxy.plotAreaFrame].origin
                                let location = CGPoint(

                                    x: 255/240*(value.location.x - origin.x),
                                    y: 255 - 255/240 * (value.location.y - origin.y)
                                    
                                )
                                
                                let startingLocation = CGPoint(
                                    x: 255/240*(value.startLocation.x - origin.x),
                                    y: 255 - 255/240 * (value.startLocation.y - origin.y)
                                )
                                
                                viewModel.movePoint(from: startingLocation, to: location)
                            }
                            .onEnded({ value in
                                viewModel.finishEditingChart()
                            })
                        
                    ).onTapGesture(perform: { value in
                        let origin = geometry[proxy.plotAreaFrame].origin
                        let location = CGPoint(
                            x: 255/240*(value.x - origin.x),
                            y: 255 - 255/240 * (value.y - origin.y)

                        )
                        
                        viewModel.removePoint(at: location)
                    })
                       
                       
            }
        }
    }
}


