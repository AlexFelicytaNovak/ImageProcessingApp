//
//  ContentView.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel    
    
    
    var body: some View {
        ScrollView{
            VStack{
                
                HStack(alignment: .bottom) {
                    
                    FunctionalFiltersChart(viewModel: viewModel)
                    
                    VStack {
                        Label("Uploaded image", systemImage: "photo")
                            .font(.title2)
                            .padding(.top, 20)
                        ScrollView([.vertical,.horizontal], showsIndicators: true){
                            if let imageOriginal = viewModel.originalImage {
                                imageOriginal
                            } else {
                                Color(nsColor: .windowBackgroundColor)
                            }
                        }.frame(width: 300, height: 300)
                    }.padding()
                    
                    VStack {
                        Label("Edited image", systemImage: "pencil")
                            .font(.title2)
                            .padding(.top, 20)
                        ScrollView([.vertical,.horizontal], showsIndicators: true){
                            if let imageFiltered = viewModel.filteredImage {
                                imageFiltered
                            } else {
                                Color(nsColor: .windowBackgroundColor)
                            }
                        }.frame(width: 300, height: 300)
                    }.padding()
                }
                
                HStack{
                    VStack{
                        HStack(alignment: .top){
                            GroupBox{
                                VStack{
                                    GroupBox(label:
                                                Label("Functional filters", systemImage: "camera.macro")
                                        .font(.headline)){
                                            VStack {
                                                Picker("",selection: $viewModel.selectedFunctionalFilter) {
                                                    Text("Inversion").tag(FunctionFilters.inversion)
                                                    Text("Brightness Correction").tag(FunctionFilters.brightnessCorrection)
                                                    Text("Contrast Enhancement").tag(FunctionFilters.contrastEnhancement)
                                                    Text("Gamma Correction").tag(FunctionFilters.gammaCorrection)
                                                    Text("Custom").tag(FunctionFilters.newFunctionalFilter)
                                                    
                                                }
                                                .pickerStyle(.segmented)
                                                .onChange(of: viewModel.selectedFunctionalFilter, perform: { selectedFilter in
                                                    viewModel.updateChart(basedOn: selectedFilter)
                                                })
                                                HStack{
                                                    Button("Create custom filter") {
                                                        viewModel.newFunctionalFilter()
                                                    }.padding(.top, 8)
                                                    
                                                    
                                                    Button("Save custom filter") {
                                                        viewModel.saveFunctionalFilter()
                                                    }.padding(.top, 8)
                                                    
                                                    
                                                    Button("Apply functional filter") {
                                                        viewModel.applyFunctionalFilter()
                                                    }.padding(.top, 8)
                                                    
                                                }
                                                
                                            }.padding()
                                        }.padding(.horizontal)
                                }.padding()
                                
                                
                                GroupBox(label:
                                            Label("Convolution filters", systemImage: "square.2.layers.3d.bottom.filled")
                                    .font(.headline)){
                                        VStack{
                                            Picker("",selection: $viewModel.selectedConvolutionFilter) {
                                                Text("Blur").tag(ConvolutionFilters.blur)
                                                Text("Guassian Blur").tag(ConvolutionFilters.gaussianBlur)
                                                Text("Sharpen").tag(ConvolutionFilters.sharpen)
                                                Text("Edge Detection").tag(ConvolutionFilters.edgeDetection)
                                                Text("Emboss").tag(ConvolutionFilters.emboss)
                                                
                                            }
                                            .pickerStyle(.segmented)
                                            
                                            
                                            Button("Apply convolution filter") {
                                                viewModel.applyConvolutionFilter()
                                            }.padding(.top, 8)
                                        }.padding()
                                    }.padding(.horizontal)
                                GroupBox(label:
                                            Label("Morphological filters", systemImage: "moonphase.last.quarter.inverse")
                                    .font(.headline)){
                                        VStack{
                                            Picker("",selection: $viewModel.selectedMorphologicalFilter) {
                                                Text("Dilation").tag(MorphologicalFilters.dilation)
                                                Text("Erosion").tag(MorphologicalFilters.erosion)
                                                Text("Opening").tag(MorphologicalFilters.opening)
                                                Text("Closing").tag(MorphologicalFilters.closing)
                                            }
                                            .pickerStyle(.segmented)
                                            
                                            
                                            Button("Apply morphological filter") {
                                                viewModel.applyMorphologicalFilter()
                                            }.padding(.top, 8)
                                        }.padding()
                                    }.padding()
                            }.padding(.trailing,20)
                            GroupBox{
                                VStack{
                                    GroupBox(label:
                                                Label("Grayscale", systemImage: "photo")
                                        .font(.headline)){
                                            HStack{
                                                Button("Grayscale") {
                                                    viewModel.convertToGrayScaleImage()
                                                }
                                                Button("Before Grayscale") {
                                                    viewModel.backConvertToColorImage()
                                                }
                                            }.padding()
                                        }
                                    GroupBox(label:
                                                Label("Ordered Dithering", systemImage: "chart.dots.scatter")
                                        .font(.headline)) {
                                            
                                            VStack {
                                                Text("Shades of gray: \(Int(viewModel.sliderValue))")
                                                Slider(value: $viewModel.sliderValue, in: 2...256, step: 1) {
                                                } minimumValueLabel: {
                                                    Text("2").font(.title2).fontWeight(.thin)
                                                } maximumValueLabel: {
                                                    Text("256").font(.title2).fontWeight(.thin)
                                                }.tint(.pink)
                                                
                                                
                                            }.padding()
                                            
                                            VStack {
                                                Text("Threshold map size")
                                                    .padding(.vertical, 10)
                                                Picker("",selection: $viewModel.selectedSize) {
                                                    Text("2").tag(DitherMatrices.D2)
                                                    Text("3").tag(DitherMatrices.D3)
                                                    Text("4").tag(DitherMatrices.D4)
                                                    Text("6").tag(DitherMatrices.D6)
                                                }
                                                .pickerStyle(.segmented)
                                                .padding(.trailing, 8)
                                            }
                                            Button("Apply") {
                                                viewModel.applyOrderedDithering()
                                            }.padding()
                                        }.padding()
                                    
                                    
                                    GroupBox(label:
                                                Label("Median Cut Quantization", systemImage: "scissors")
                                        .font(.headline)) {
                                            VStack {
                                                Text("Number of colors: \(Int(viewModel.sliderValueColors))")
                                                Slider(value: $viewModel.sliderValueColors, in: 1...256, step: 1) {
                                                } minimumValueLabel: {
                                                    Text("1").font(.title2).fontWeight(.thin)
                                                } maximumValueLabel: {
                                                    Text("256").font(.title2).fontWeight(.thin)
                                                }.tint(.pink)
                                                    .padding(.trailing, 8)
                                                
                                                
                                            }.padding()
                                            
                                            Button("Apply") {
                                                viewModel.applyMedianCutQuantization()
                                            }.padding()
                                            
                                        }
                                    
                                }.padding()
                            }
                            
                        }
                        
                        HStack {
                            Button("Save") {
                                viewModel.saveDocument()
                            }
                            
                            Button("Save Copy...") {
                                viewModel.saveCopyOfDocument()
                            }
                            
                            Button("Reset") {
                                viewModel.resetChanges()
                            }
                            
                        }.padding()
                    }.padding()
                    
                }
                Spacer()
                
                Spacer()
            }.onAppear {
                viewModel.fetchFilteredImage()
            }
        }
    }
    
    init(doc: Binding<Document>) {
        self._viewModel = StateObject(wrappedValue: ContentViewModel(doc: doc))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(doc: .constant(Document()))
    }
}

