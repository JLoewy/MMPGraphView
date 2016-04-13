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