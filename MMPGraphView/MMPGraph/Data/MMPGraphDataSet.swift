//
//  MMPGraphDataSet.swift
//  My Workout
//
//  Created by Jason Loewy on 4/9/16.
//  Copyright © 2016 My Macros LLC. All rights reserved.
//

import UIKit

/**
 The MMPGraphdataPlot  is one full sheet of a graph. 
 Contains all of the data sets that will be responsible for drawing the graph
 
 If there are more than one data set associated with this plot that means that there will be a segmented controller showing
 that allows for cycling between them
 */
class MMPGraphDataPlot: NSObject {
    
    var plotTitle = ""
    var primaryDataSet:MMPGraphDataSet
    var secondaryDataSet:MMPGraphDataSet?
    
    init(title:String, primaryDataSet:MMPGraphDataSet, secondaryDataSet:MMPGraphDataSet?)
    {
        self.plotTitle       = title
        self.primaryDataSet  = primaryDataSet
        self.secondaryDataSet = secondaryDataSet
    }
}

/**
 The MMPGraphDataSet is what drives a single line on the MMPGraphView
 It contains one set of datapoints and the title/color attributes associated with it
 */
class MMPGraphDataSet: NSObject {
    
    var dataTitle:String
    var dataPoints:[MMPGraphDataPoint]
    
    var color:UIColor
    
    init(title:String, dataPoints:[MMPGraphDataPoint], color:UIColor)
    {
        dataTitle       = title
        self.dataPoints = dataPoints
        self.color      = color
    }
    
    /**
     Responsible for getting the min and max values for a datasets
     
     - returns: A tuple of min max values
     */
    func maxMinElement()->(minValue:MMPGraphDataPoint, maxValue:MMPGraphDataPoint) {
        
        var maxValue = dataPoints.first!
        var minValue = dataPoints.last!
        
        if maxValue.mmpGraphValue() < minValue.mmpGraphValue() {
            maxValue = minValue
            minValue = dataPoints.first!
        }
        
        for i in 0..<(dataPoints.count/2)
        {
            let valueA = dataPoints[i*2]
            let valueB = dataPoints[i*2+1]
            
            if valueA.mmpGraphValue() <= valueB.mmpGraphValue() {
                
                if (valueA.mmpGraphValue() < minValue.mmpGraphValue()) {
                    minValue = valueA
                }
                
                if (valueB.mmpGraphValue() > maxValue.mmpGraphValue()) {
                    maxValue = valueB
                }
            }
            else {
                
                if valueA.mmpGraphValue() > maxValue.mmpGraphValue() {
                    maxValue = valueA
                }
                
                if valueB.mmpGraphValue() < minValue.mmpGraphValue() {
                    minValue = valueB
                }
            }
        }
        return (minValue, maxValue)
    }

}
