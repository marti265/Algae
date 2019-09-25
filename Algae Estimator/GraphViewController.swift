//
//  GraphViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 11/13/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//


import UIKit
import SwiftCharts
import CoreData
import Foundation

class GraphViewController: UIViewController {
    //data for chl values
    var chlaDataSet: Array<Float> = [Float]()
    var cyanoDataSet: Array<Float> = [Float]()
    
    fileprivate var chart: Chart? // arc
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //Settings of axis labels
        let labelSettings = ChartLabelSettings(font: UIFont.init(name: "Helvetica", size: 10)!)
        
        //chart's points
        var chartPoints0 = [ChartPoint]()
        var chartPoints1 = [ChartPoint]()
        var chartPoints2 = [ChartPoint]()
        
        
        
        //Plotting the CHL on the graph
        for i in 0..<chlaDataSet.count {
            chartPoints0.append(createChartPoint(Double(i), Double(chlaDataSet[i]), labelSettings))
            chartPoints1.append(createChartPoint(Double(i), Double(cyanoDataSet[i]), labelSettings))
            chartPoints2.append(createChartPoint(Double(i), 40.0, labelSettings))
        }
        

        //Graph settings, scaling, padding, gridlines
        let xValues = stride(from: 0, through: chartPoints0.count, by: 66).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPoints0, minSegmentCount: 5, maxSegmentCount: 20, multiple: 10, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
       
        //X & Y axis label settings
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Time (h)", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Chl a\nConc.\n(μg/L)", settings: labelSettings))
        
        
    
    
        //Scrolling view settings
        let scrollViewFrame = CGRect(x: self.view.bounds.minX + 20, y: self.view.bounds.minY + 80, width: self.view.bounds.width - 40, height: self.view.bounds.height - 150)
        
        
        
        //The white rectangle that holds the the graph
        let chartFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: self.view.bounds.height - 180)
    
        
        // calculate coords space in the background to keep UI smooth
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            //coordinate space
            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: FormatForDevice.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            
            //Building the lines in the graph
            DispatchQueue.main.async {
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
                
                let lineModel0 = ChartLineModel(chartPoints: chartPoints0, lineColor: #colorLiteral(red: 0.09019607843, green: 0.5490196078, blue: 0.5176470588, alpha: 1), lineWidth: 2.5, animDuration: 1, animDelay: 0)
                //let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor(red:0, green:1.96, blue:2.01, alpha:1.0), lineWidth: 2.5, animDuration: 1, animDelay: 0)
                let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), lineWidth: 2.5, animDuration: 1, animDelay: 0)
                let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: UIColor.red, lineWidth: 3.0, animDuration: 1, animDelay: 0)
                _ = (xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel0, lineModel1, lineModel2])
                
                
                let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: Env.iPad ? 0.5 : 0.1)
                
                
                let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
                
                let scrollView = UIScrollView(frame: scrollViewFrame)
                scrollView.contentSize = CGSize(width: chartFrame.size.width, height: scrollViewFrame.size.height)
                scrollView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
                //        self.automaticallyAdjustsScrollViewInsets = false // nested view controller - this is in parent
                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        guidelinesLayer,
                        //chartPointsLineLayer
                    ]
                )
                
                //The rest of the code until ∆ are the labels for the legend
                let warn = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                warn.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.17))  //x: 3.4 y: 1.17
                warn.textAlignment = .left
                warn.font = warn.font.withSize(10)
                warn.textColor = UIColor.red
                warn.text = "\t■"  //1 tab
                
                let warn2 = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                warn2.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.17))   //x: 3.4 y: 1.17
                warn2.textAlignment = .left
                warn2.font = warn2.font.withSize(10)
                warn2.textColor = UIColor.black
                warn2.text = "\t   WHO Risk Limit for HAB: 40 μg/L"    //1 tab 3 spaces
                
                
                let box = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                box.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.2))  //x: /3.4 y: /1.15
                box.textAlignment = .left   //left
                box.font = box.font.withSize(10)
                box.textColor = #colorLiteral(red: 0.09019607843, green: 0.5490196078, blue: 0.5176470588, alpha: 1)
                box.text = "\t■"   //1 tab
                
                
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                label.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.2))  //x: /3.4 y: /1.15
                //label.center = CGPoint(x: self.view.bounds.width - 265, y: self.view.bounds.height - 87)
                label.textAlignment = .left  //left
                label.font = label.font.withSize(10)
                label.text = "\t   Total Chla" //1 tab 3 spaces
                
                
                let box2 = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                box2.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.2))  //x: /3.4 y: /1.15
                //box2.center = CGPoint(x: self.view.bounds.width - 260, y: self.view.bounds.height - 87)
                box2.textAlignment = .center  //center
                box2.font = box2.font.withSize(10)
                box2.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                box2.text = "■" //no spaces
                
                
                
                let label2 = UILabel(frame: CGRect(x: 0, y: 0, width:200, height: 21)) //w: 200 h: 21
                label2.center = CGPoint(x: UIScreen.main.bounds.size.width/3.4, y: UIScreen.main.bounds.size.height/(1.2))  //x: /3.4 y: /1.15
                //label2.center = CGPoint(x: self.view.bounds.width - 258, y: self.view.bounds.height - 87)
                label2.textAlignment = .center   //center
                label2.font = label2.font.withSize(10)
                label2.text = "\t\t   Cyano Chla"  //2 tabs 3 spaces
                //∆ END OF LEGEND
                
                
                //viewing the componenets above
                scrollView.addSubview(chart.view)
                self.view.addSubview(scrollView)
                self.view.addSubview(box)
                self.view.addSubview(label)
                self.view.addSubview(box2)
                self.view.addSubview(label2)
                self.view.addSubview(warn)
                self.view.addSubview(warn2)
                self.chart = chart
                
            }
        }
    }
    
    fileprivate func createChartPoint(_ x: Double, _ y: Double, _ labelSettings: ChartLabelSettings) -> ChartPoint {
        return ChartPoint(x: ChartAxisValueDouble(x, labelSettings: labelSettings), y: ChartAxisValueDouble(y))
    }
}


///////////////////////////////////////////////////////////////////////////

//Getting device information
class Env {
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

//determines if iPad or iPhone
struct FormatForDevice {
    static var chartSettings: ChartSettings {
        if Env.iPad {
            return self.iPadChartSettings
        } else {
            return self.iPhoneChartSettings
        }
    }
    
    //Changing the view scaling for iPad
    fileprivate static var iPadChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        return chartSettings
    }
    
    //Changing the view scaling for iPhone
    fileprivate static var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        return chartSettings
    }
}
