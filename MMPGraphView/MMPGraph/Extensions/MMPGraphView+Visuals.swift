//
//  MMPGraphView+Visuals.swift
//  MMPGraphView
//
//  Created by Jason Loewy on 4/18/16.
//  Copyright © 2016 My Macros+, LLC. All rights reserved.
//

import Foundation
import UIKit

extension MMPGraphView {
    
    static func boldFont()->UIFont {
        return MMPGraphView.boldFont(14.0)
    }
    
    static func boldFont(pointSize:CGFloat)->UIFont {
        return UIFont.boldSystemFontOfSize(pointSize)
    }
    
    static func regularFont()->UIFont {
        return UIFont.systemFontOfSize(14.0)
    }
    
    static func lightFont()->UIFont {
        return UIFont.systemFontOfSize(14.0)
    }
    
}