//
//  MMPGraphTableViewCell.swift
//  My Track
//
//  Created by Jason Loewy on 4/19/16.
//  Copyright © 2016 Jason Loewy. All rights reserved.
//

import UIKit

class MMPGraphTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MMP-Graph-Cell"
    static var token: dispatch_once_t = 0
    
    @IBOutlet var graphView: MMPGraphView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("AWAKE FROM NIB")
        graphView.titleAlignment   = .Left
        graphView.currentlyLoading = true
        graphView.setNeedsDisplay()
        // Initialization code
    }
    
    /**
     Responsible for configuring the graph table cell for a current array of dataplots
     
     - parameter dataPlots: The MMPGraphDataPlot array that is going to fuel this MMPGraphTableView
     */
    func configureWithData(dataPlots:[MMPGraphDataPlot], delegate:MMPGraphDelegate?)
    {
        graphView.delegate = delegate
        
        dispatch_once(&MMPGraphTableViewCell.token) { () -> Void in
            if 2 <= dataPlots.count {
                self.graphView.currentPlotIdx = 2
            }
        }
        graphView.finishLoading(dataPlots)
    }
    
}
