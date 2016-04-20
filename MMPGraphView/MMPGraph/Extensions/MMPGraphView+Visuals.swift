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
        return MMPGraphView.regularFont(14.0)
    }
    
    static func regularFont(pointSize:CGFloat)->UIFont {
        return UIFont.systemFontOfSize(pointSize)
    }
    
    static func lightFont()->UIFont {
        return UIFont.systemFontOfSize(14.0)
    }
    
    /**
     arrows example image is made by Vaadin http://www.flaticon.com/authors/vaadin 
     distributed on http://www.flaticon.com
     
     - returns: The UIImage to be used in the full screen button
     */
    static func fullScreenImage()->UIImage {
        return UIImage(named: "arrows")!
    }
    
}