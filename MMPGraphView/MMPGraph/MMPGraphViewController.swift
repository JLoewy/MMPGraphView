//
//  MMPGraphViewController.swift
//  MMPGraphView
//
//  Created by Jason Loewy on 4/18/16.
//  Copyright © 2016 My Macros+, LLC. All rights reserved.
//

import UIKit

class MMPGraphViewController: UIViewController {
    
    private var graphView = MMPGraphView.newLoadingGraphView(CGRectZero, delegate: nil)
    let dataPlots:[MMPGraphDataPlot]
    let closeButton = UIButton(type: .Custom)
    
    init(graphView:MMPGraphView)
    {
        self.graphView.copyGraphAttributes(graphView)
        self.graphView.isFullScreen = true
        self.dataPlots = graphView.dataPlots
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.finishLoading(dataPlots)
        graphView.allowFullScreen = false
        graphView.fullScreenButton?.removeFromSuperview()
        view.addSubview(graphView)
        
        // Add the close button
        closeButton.frame            = CGRect(x: 20.0, y: 20.0, width: 15.0, height: 15.0)
        closeButton.autoresizingMask = [.FlexibleRightMargin, .FlexibleBottomMargin]
        closeButton.setBackgroundImage(UIImage(named: "MMPBackIcon")!, forState: .Normal)
        closeButton.addTarget(self, action: #selector(MMPGraphViewController.closeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        graphView.frame = view.bounds
    }
    
    func closeButtonTapped(sender:UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
