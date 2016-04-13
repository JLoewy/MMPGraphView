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
    func averageCalculated(graphView:MMPGraphView, graphDataAverage:CGFloat, dataSet:MMPGraphDataSet);
}