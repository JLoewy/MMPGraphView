//
//  MMPTestData.swift
//  MMPGraphView
//
//  Created by Jason Loewy on 4/10/16.
//  Copyright © 2016 My Macros+, LLC. All rights reserved.
//

import Foundation
import UIKit

class MMPTestData: NSObject, MMPGraphDataPoint {

    var title:String
    var value:CGFloat
    
    init(title:String, value:CGFloat)
    {
        self.title = title
        self.value = value
    }
    
    // MARK: - MMPGraphDataPoint Methods
    
    func mmpGraphTitle() -> String {
        return self.title
    }
    
    func mmpGraphValue() -> CGFloat {
        return self.value
    }
    
    
}
