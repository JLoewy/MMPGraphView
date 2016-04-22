//
//  MMPGraphDataPoint.swift
//  My Workout
//
//  Created by Jason Loewy on 4/8/16.
//  Copyright © 2016 My Macros LLC. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MMPGraphDataPoint {
    
    /**
     Responsible for getting the value associated with this data point
     
     - returns: The CGFloat representation of the data point
     */
    func mmpGraphValue()->CGFloat
    
    /**
     Responsible for getting the title associated with this data point
     
     - returns: The string representation of the data point
     */
    func mmpGraphTitle()->String
    
}

/// Generic data object that is designed to feed the GraphDataPoint data source
class MMPGraphData <MMPGraphDataPoint> {
    
    private let title:String
    private let value:CGFloat
    
    init(title:String, value:CGFloat)
    {
        self.title = title;
        self.value = value;
    }
    
    func mmpGraphTitle() -> String {
        return self.title
    }
    
    func mmpGraphValue() -> CGFloat {
        return self.value
    }
}