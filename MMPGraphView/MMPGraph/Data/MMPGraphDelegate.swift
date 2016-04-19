//
//  MMPGraphDelegate.swift
//  MMPGraphView
//
//  Created by Jason Loewy on 4/12/16.
//  Copyright © 2016 My Macros+, LLC. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MMPGraphDelegate
{
    /**
     Resposnible for letting the delegate know that there is a new average value calculated
     
     - parameter graphView:        the currently active graph view
     - parameter graphDataAverage: the cgfloat value of the average
     - parameter dataSet:          the MMPGraphDataSet whos average was just calculated
     */
    optional func averageCalculated(graphView:MMPGraphView, graphDataAverage:CGFloat, dataSet:MMPGraphDataSet)
    
    /**
     Responsible for letting the delegate know that the user wants this graph to be presented in full screen mode
     
     - parameter graphView: The currently active MMPGraphView
     */
    optional func showFullScreenGraph(graphView:MMPGraphView)
}