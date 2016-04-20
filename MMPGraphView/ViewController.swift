//
//  ViewController.swift
//  MMPGraphView
//
//  Created by Jason Loewy on 4/10/16.
//  Copyright © 2016 My Macros+, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MMPGraphDelegate {

    @IBOutlet var storyboardGraphView: MMPGraphView!
    var programmaticGraphView:MMPGraphView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the first data set and associate it with the graph in the storyboard
        let primaryDataSet = MMPGraphDataSet(title: "Weight",
                                             dataPoints: [MMPTestData(title: "5", value: 365),
                                                MMPTestData(title: "8", value: 365),
                                                MMPTestData(title: "10", value: 385),
                                                MMPTestData(title: "7", value: 385),
                                                MMPTestData(title: "8", value: 405)],
                                             color: UIColor.whiteColor())
        
        let secondaryDataSet = MMPGraphDataSet(title: "Reps",
                                               dataPoints: [MMPTestData(title: "5", value: 6),
                                                MMPTestData(title: "8", value: 4),
                                                MMPTestData(title: "10", value: 6),
                                                MMPTestData(title: "7", value: 4),
                                                MMPTestData(title: "8", value: 2)],
                                               color: UIColor.blueColor())
        
        let dataPlot = MMPGraphDataPlot(title: "Weight vs Reps", primaryDataSet: primaryDataSet, secondaryDataSet:secondaryDataSet)
        storyboardGraphView.dataPlots = [dataPlot]
        
        
        // Create the second, manual graph view example
        let TWOprimaryDataSet = MMPGraphDataSet(title: "One",
                                             dataPoints: [MMPTestData(title: "5", value: 365),
                                                MMPTestData(title: "8", value: 365),
                                                MMPTestData(title: "10", value: 385),
                                                MMPTestData(title: "7", value: 385),
                                                MMPTestData(title: "8", value: 405)],
                                             color: UIColor.whiteColor())
        
        let TWOsecondaryDataSet = MMPGraphDataSet(title: "Two",
                                               dataPoints: [MMPTestData(title: "5", value: 6),
                                                MMPTestData(title: "8", value: 4),
                                                MMPTestData(title: "10", value: 6),
                                                MMPTestData(title: "7", value: 4),
                                                MMPTestData(title: "8", value: 2)],
                                               color: UIColor.blueColor())
        let TWOdataPlot = MMPGraphDataPlot(title: "Plot 1", primaryDataSet: TWOprimaryDataSet, secondaryDataSet:TWOsecondaryDataSet)
        
        let THRprimaryDataSet = MMPGraphDataSet(title: "Three",
                                                dataPoints: [MMPTestData(title: "1/10", value: 1029),
                                                    MMPTestData(title: "1/11", value: 987),
                                                    MMPTestData(title: "1/14", value: 350),
                                                    MMPTestData(title: "1/18", value: 444),
                                                    MMPTestData(title: "1/22", value: 605)],
                                                color: UIColor.whiteColor())
        
        let THRsecondaryDataSet = MMPGraphDataSet(title: "Four",
                                                  dataPoints: [MMPTestData(title: "5", value: 6),
                                                    MMPTestData(title: "8", value: 4),
                                                    MMPTestData(title: "10", value: 6),
                                                    MMPTestData(title: "7", value: 4),
                                                    MMPTestData(title: "8", value: 2)],
                                                  color: UIColor.blueColor())
        let THRdataPlot = MMPGraphDataPlot(title: "Plot 2", primaryDataSet: THRsecondaryDataSet, secondaryDataSet:THRprimaryDataSet)
        
        let FVprimaryDataSet = MMPGraphDataSet(title: "Five",
                                                  dataPoints: [MMPTestData(title: "5", value: 6),
                                                    MMPTestData(title: "8", value: 4),
                                                    MMPTestData(title: "10", value: 6),
                                                    MMPTestData(title: "7", value: 4),
                                                    MMPTestData(title: "8", value: 2)],
                                                  color: UIColor.whiteColor())
        let FVdataPlot = MMPGraphDataPlot(title: "Single Plot", primaryDataSet: FVprimaryDataSet, secondaryDataSet:nil)
        
        

        let graphFrame  = CGRect(x: 20.0, y: CGRectGetMaxY(storyboardGraphView.frame) + 50.0, width: CGRectGetWidth(self.view.bounds)-40.0, height: 300)
//        programmaticGraphView = MMPGraphView.newGraphView(graphFrame, dataPlots: [TWOdataPlot, THRdataPlot], delegate: nil)
        
        programmaticGraphView = MMPGraphView.newLoadingGraphView(graphFrame, delegate: self)
        programmaticGraphView.titleAlignment = .Left
        view.addSubview(programmaticGraphView)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.programmaticGraphView.finishLoading([TWOdataPlot, THRdataPlot, FVdataPlot])
        }
        
        storyboardGraphView.layer.cornerRadius   = 6.0
        storyboardGraphView.clipsToBounds        = true
        programmaticGraphView.layer.cornerRadius = 6.0
        programmaticGraphView.clipsToBounds      = true
    }
    
    // MARK: - MMPGraphDelegate Methods

    func showFullScreenGraph(graphView: MMPGraphView) {
        
        let graphViewController = MMPGraphViewController(graphView: graphView) // MMPGraphViewController(dataPlots: graphView.dataPlots)
        showViewController(graphViewController, sender: self)
        
    }
}

