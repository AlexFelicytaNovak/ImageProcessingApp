//
//  ContentViewModel.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Binding private var doc: Document
    private var nsDoc: NSDocument? { NSDocumentController.shared.currentDocument }
    
    
    @Published var selectedFunctionalFilter: FunctionFilters = FunctionFilters.inversion
    @Published var selectedConvolutionFilter: ConvolutionFilters = ConvolutionFilters.blur
    @Published var selectedMorphologicalFilter: MorphologicalFilters = MorphologicalFilters.dilation
    
    @Published var originalImage: Image?
    @Published var filteredImage: Image?
    @Published var filterChart = [Point(x :0, y: 255), Point(x: 255, y:0)]
    
    @Published var selectedSize: DitherMatrices = DitherMatrices.D2
    @Published var sliderValue : Float = 2.0
    
    @Published var sliderValueColors : Float = 1.0
    
    func saveDocument() {
        nsDoc?.save(nil)
    }
    
    func saveCopyOfDocument() {
        nsDoc?.saveAs(nil)
    }
    
    func resetChanges() {
        doc.reset()
        nsDoc?.undoManager?.removeAllActions()
        nsDoc?.save(nil)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    func fetchFilteredImage() {
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text("Filtered"))
        }
    }
    
    func convertToGrayScaleImage() {
        doc.convertToGrayScaleImage()
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    func backConvertToColorImage() {
        doc.back()
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    //FUNCTIONAL FILTERS
    func newFunctionalFilter() {
        doc.newPoints = [Point(x: 0, y: 0), Point(x: 255, y: 255)]
        filterChart = doc.newPoints
        selectedFunctionalFilter = FunctionFilters.newFunctionalFilter
    }
    
    func saveFunctionalFilter() {
        doc.newPoints = filterChart
    }
    
    func applyFunctionalFilter() {
        doc.applyFunctionFilters(functionFilterType: selectedFunctionalFilter)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    //CONVOLUTION FILTERS
    func applyConvolutionFilter() {
        doc.applyConvolutionFilters(convolutionFilterType: selectedConvolutionFilter)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    // MORPHOLOGICAL FILTERS
    func applyMorphologicalFilter() {
        doc.applyMorphologicalFilters(morphologicalFiltersType: selectedMorphologicalFilter)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    // ORDERED DITHERING
    func applyOrderedDithering() {
        doc.orderedDithering(ditherMatrices: selectedSize, shades: sliderValue)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }
    }
    
    // MEDIAN CUT
    func applyMedianCutQuantization() {
        doc.medianCutAlgorithm(colors: sliderValueColors)
        if let imageFiltered = doc.filteredImage?.cgImage {
            filteredImage = Image(imageFiltered, scale: 1.0, label: Text(" "))
        }

    }
    
    // CHART
    func updateChart(basedOn selectedFilter: FunctionFilters) {
        switch selectedFilter {
        case .inversion:
            
            filterChart = [Point(x :0, y: 255), Point(x: 255, y:0)]
        case .brightnessCorrection:
            if doc.brightnessCorrectionConst > 0 {
                filterChart = [Point(x :0, y: doc.brightnessCorrectionConst), Point(x: 255 - doc.brightnessCorrectionConst, y: 255), Point(x: 255, y: 255)]
            } else if doc.brightnessCorrectionConst < 0 {
                filterChart = [Point(x :0, y: 0), Point(x:  -doc.brightnessCorrectionConst , y: 0 ), Point(x: 255, y: 255 +  doc.brightnessCorrectionConst)]
            } else {
                filterChart = [Point(x :0, y: 0), Point(x :255, y: 255)]
            }
        case .contrastEnhancement:
            if doc.contrastEnhancementConst > 0 {
                filterChart = [Point(x :0, y: 0), Point(x: (128 * doc.contrastEnhancementConst - 128)/doc.contrastEnhancementConst, y: 0), Point(x: (255 + 128 * doc.contrastEnhancementConst - 128)/doc.contrastEnhancementConst, y: 255),Point(x :255, y: 255) ]
            }  else if doc.contrastEnhancementConst < 0{
                filterChart = [Point(x :0, y: 255), Point(x: (255 + 128 * doc.contrastEnhancementConst - 128)/doc.contrastEnhancementConst, y: 255), Point(x: (128 * doc.contrastEnhancementConst - 128)/doc.contrastEnhancementConst, y: 0),Point(x :255, y: 0) ]
            }
            
        case .gammaCorrection:
            filterChart = []
        case .newFunctionalFilter:
            filterChart = doc.newPoints
            
        }
    }
    
    func removePoint(at location: CGPoint) {
        if let pointIndex =  filterChart.firstIndex(where: {
            ((Int(location.x) - 10)...(Int(location.x) + 10)).contains($0.x) &&
            ((Int(location.y) - 10)...(Int(location.y) + 10)).contains($0.y)
        }){
            if filterChart[pointIndex].x > 0 && filterChart[pointIndex].x < 255 {
                filterChart.remove(at: pointIndex)
            }
        }
    }
    
    func movePoint(from startingLocation: CGPoint, to location: CGPoint) {
        if let pointIndex =  filterChart.firstIndex(where: {
            $0.isCurrentlyDragged
        }) {
            
            if filterChart[pointIndex].x != 255 && filterChart[pointIndex].x != 0{
                filterChart[pointIndex].x = (Int(location.x)).clamped(to: 1...254)
            }
            
            filterChart[pointIndex].y =  (Int(location.y)).clamped(to: 0...255)
            filterChart.sort()
        } else {
            if let pointIndex =  filterChart.firstIndex(where: {
                ((Int(startingLocation.x) - 10)...(Int(startingLocation.x) + 10)).contains($0.x) &&
                ((Int(startingLocation.y) - 10)...(Int(startingLocation.y) + 10)).contains($0.y)
                
            }) {
                filterChart[pointIndex].isCurrentlyDragged = true
                if filterChart[pointIndex].x != 255 && filterChart[pointIndex].x != 0{
                    filterChart[pointIndex].x = (Int(location.x)).clamped(to: 1...254)
                }
                filterChart[pointIndex].y = (Int(location.y)).clamped(to: 0...255)
                filterChart.sort()
            } else {
                
                var point = Point(x: (Int(location.x)).clamped(to: 1...254), y: (Int(location.y)).clamped(to: 0...255))
                point.isCurrentlyDragged = true
                filterChart.append(point)
                filterChart.sort()
            }
        }
    }
    
    func finishEditingChart() {
        if let pointIndex =  filterChart.firstIndex(where: {
            $0.isCurrentlyDragged
        }) {
            filterChart[pointIndex].isCurrentlyDragged = false
        }
    }
        
    init(doc: Binding<Document>) {
        self._doc = doc
        
        self.originalImage = self.doc.originalImage.map({ Image($0, scale: 1.0, label: Text("Original")) })
    }
}
