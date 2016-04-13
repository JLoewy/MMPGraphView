//
//  MMPGraphView.swift
//  My Track
//
//  Created by Jason Loewy on 3/15/15.
//  Copyright (c) 2015 Jason Loewy. All rights reserved.
//

import UIKit

extension NSString
{
    /**
     Responsible for returning a single precision representation of the provided CGFloat
     
     - parameter currentFloat: The CGFloat being represented
     - parameter trim:         A boolean flag that tells if you want to trim any trailing .0 or not
     
     - returns: a string that representation of the cgfloat in the parameters
     */
    static func singlePrecisionFloat(currentFloat:CGFloat, attemptToTrim trim:Bool)->String {
        
        let string = NSString(format: "%.1f", currentFloat)
        return (trim && string.containsString(".0")) ? string.stringByReplacingOccurrencesOfString(".0", withString: "") : string as String
    }

}

@IBDesignable class MMPGraphView: UIView {
    
    /// MARK: - Main UI Properties
    var boldFont    = UIFont.boldSystemFontOfSize(14.0)
    var regularFont = UIFont.systemFontOfSize(14.0)
    var lightFont   = UIFont.systemFontOfSize(14.0)
    
    @IBInspectable var startColor:UIColor = UIColor(red: 128.0/255.0, green: 182.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    @IBInspectable var endColor:UIColor   = UIColor(red: 50.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    var delegate:MMPGraphDelegate?;
    
    var showTouchTitle  = true
    var graphInsetFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // MARK: – Main Title Objects
    var titleLabel:UILabel = UILabel()
    var mainTitleText      = NSAttributedString(string: "")
    
    var dataPlots:[MMPGraphDataPlot]!
    var currentPlotIdx = 0
    var plotSegmentedController:UISegmentedControl?
    
    // MARK: - Initialize Methods
    
    /**
     Responsible for getting a new graph view
     
     - parameter frame:      The frame of the graph view
     - parameter dataPoints: The datapoints that will be used in creating this graph
     - parameter delegate:   The object that conforms to the delegate (optional)
     
     - returns: A newly initialized MMPGraphView
     */
    static func newGraphView(frame: CGRect, dataPlots:[MMPGraphDataPlot], delegate:MMPGraphDelegate?)->MMPGraphView
    {
        return MMPGraphView(frame: frame, dataPlots: dataPlots, delegate: delegate)
    
    }
    
    private init(frame: CGRect, dataPlots:[MMPGraphDataPlot], delegate:MMPGraphDelegate?) {
        
        super.init(frame: frame)
        self.dataPlots = dataPlots
        self.delegate  = delegate
        initializeSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataPlots = []
        initializeSubViews()
    }
    
    // Responsble for initializing all of the subviews associated with this graphview instance
    func initializeSubViews()
    {
        // Configure and add the title label
        titleLabel.font           = regularFont
        titleLabel.textColor      = UIColor.whiteColor()
        titleLabel.textAlignment  = .Center
        titleLabel.attributedText = mainTitleText
        addSubview(titleLabel)
        
        if dataPlots.count > 1 {
            // Initialize, configure and add the plot switching segmented controller
            var plotTitles = [String]()
            for currentPlot in dataPlots {
                plotTitles.append(currentPlot.plotTitle)
            }
            plotSegmentedController            = UISegmentedControl(items: plotTitles)
            plotSegmentedController!.tintColor = UIColor.whiteColor()
            plotSegmentedController!.setTitleTextAttributes([NSFontAttributeName : lightFont], forState: .Normal)
            plotSegmentedController!.setTitleTextAttributes([NSFontAttributeName : boldFont], forState: .Selected)
            plotSegmentedController!.addTarget(self, action: #selector(MMPGraphView.activePlotValueChanged(_:)), forControlEvents: .ValueChanged)
            plotSegmentedController!.selectedSegmentIndex = 0
            addSubview(plotSegmentedController!)
        }
    }
    
    
    // MARK: - View Layout Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let labelWidth            = CGRectGetWidth(bounds) * 0.5
        let titleYPadding:CGFloat = 8.0
        let labelHeight:CGFloat   = 26.0
        titleLabel.frame          = CGRect(x: (CGRectGetWidth(bounds)*0.25), y: titleYPadding, width: labelWidth, height: labelHeight)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Set up the title text
        // This is in draw rect becuase it needs to get reset everytime that the segmented controller value changes
        if let secondaryData = dataPlots[currentPlotIdx].secondaryDataSet
        {
            let primaryDataSet = dataPlots[currentPlotIdx].primaryDataSet
            let titleAttributeText = NSMutableAttributedString(string: "\(primaryDataSet.dataTitle) vs \(secondaryData.dataTitle)",
                                                               attributes: [NSFontAttributeName : boldFont,
                                                                NSForegroundColorAttributeName : UIColor.whiteColor()])
            titleAttributeText.addAttributes([NSForegroundColorAttributeName:primaryDataSet.color], range: NSMakeRange(0, primaryDataSet.dataTitle.characters.count))
            titleAttributeText.addAttributes([NSForegroundColorAttributeName:secondaryData.color], range: NSMakeRange(primaryDataSet.dataTitle.characters.count + 4, secondaryData.dataTitle.characters.count))
            mainTitleText = titleAttributeText
        }
        titleLabel.attributedText = mainTitleText
        
        // Calculate the boundaries
        graphInsetFrame.origin.y    = bounds.height * 0.25
        if dataPlots.count > 1 {
            graphInsetFrame.origin.y -= 20.0
        }
        
        graphInsetFrame.size.height = bounds.height - graphInsetFrame.origin.y*2.0
        if dataPlots.count > 1 {
            graphInsetFrame.size.height -= 40.0
        }
        graphInsetFrame.origin.x    = bounds.width  * 0.125
        graphInsetFrame.size.width  = CGRectGetWidth(bounds) - (graphInsetFrame.origin.x * 2.0)
        let columnWidth:CGFloat     = graphInsetFrame.width / max(1,(CGFloat(dataPlots[currentPlotIdx].primaryDataSet.dataPoints.count)) - 1.0)
        
        // Now that you have the inset bounds calculated you can layout the segmented controller to sit right underneath it
        if let segmentedController = plotSegmentedController {
            segmentedController.frame = CGRect(x: graphInsetFrame.origin.x, y: (graphInsetFrame.origin.y + graphInsetFrame.size.height) + 45, width: graphInsetFrame.size.width, height: segmentedController.frame.size.height)
        }
        
        // Draw the background gradient
        let context:CGContext?  = UIGraphicsGetCurrentContext()
        let colorRGB = CGColorSpaceCreateDeviceRGB()
        let gradiant = CGGradientCreateWithColors(colorRGB,
            [startColor.CGColor, endColor.CGColor], [0.0,1.0])
        CGContextDrawLinearGradient(context, gradiant, CGPointZero, CGPoint(x: 0, y: self.bounds.height), .DrawsBeforeStartLocation)
        
        // MARK: - column X|Y positioning closures
        
        let columnXPosition = {(dataPoints:[MMPGraphDataPoint], xColumn:CGFloat)->CGFloat in
            return (dataPoints.count > 1) ? self.graphInsetFrame.origin.x + columnWidth*xColumn : CGRectGetWidth(self.bounds)/2.0
        }
        
        let columnYPosition = {(graphValue:CGFloat, minValue:MMPGraphDataPoint, maxValue:MMPGraphDataPoint)->CGFloat in
            
            let normalizedCurrentValue = graphValue - minValue.mmpGraphValue()
            let yPosition              = (self.graphInsetFrame.size.height + self.graphInsetFrame.origin.y) - ((normalizedCurrentValue/(maxValue.mmpGraphValue() - minValue.mmpGraphValue())) * self.graphInsetFrame.size.height)
            return isnan(yPosition) ? self.graphInsetFrame.origin.y + self.graphInsetFrame.size.height/2.0 : yPosition
        }
        
        // Draw the actual data plots
        if dataPlots[currentPlotIdx].primaryDataSet.dataPoints.count > 0
        {
            var dataSets = [self.dataPlots[currentPlotIdx].primaryDataSet];
            if let secondDataSet = self.dataPlots[currentPlotIdx].secondaryDataSet {
                dataSets.append(secondDataSet)
            }
            
            var index = -1
            for currentDataSet in dataSets
            {
                index += 1
                let minMaxValues = maxMinElement(currentDataSet.dataPoints)
                let maxValue     = minMaxValues.maxValue
                let minValue     = minMaxValues.minValue
                
                // Move to the start add the main graph plot
                let graphPath = UIBezierPath()
                graphPath.moveToPoint(CGPoint(x: columnXPosition(currentDataSet.dataPoints, 0),
                                              y: columnYPosition(currentDataSet.dataPoints[0].mmpGraphValue(), minValue, maxValue)))
                for i in 1..<currentDataSet.dataPoints.count
                {
                    graphPath.addLineToPoint(CGPoint(x: columnXPosition(currentDataSet.dataPoints, CGFloat(i)),
                                                     y: columnYPosition(currentDataSet.dataPoints[i].mmpGraphValue(), minValue, maxValue)))
                }
                
                // Stroke the main graph plot
                currentDataSet.color.setStroke()
                graphPath.lineWidth = 3.0
                graphPath.stroke()
                CGContextSaveGState(context)
                
                
                // Create the under graph gradient - only if
                if dataSets.count == 1 || (dataSets.count == 2 && index == 0)
                {
                    let shadowBezier = graphPath.copy() as! UIBezierPath
                    shadowBezier.addLineToPoint(CGPoint(x: columnXPosition(currentDataSet.dataPoints, CGFloat(currentDataSet.dataPoints.count) - 1.0), y: bounds.height - graphInsetFrame.origin.y))
                    shadowBezier.addLineToPoint(CGPoint(x: columnXPosition(currentDataSet.dataPoints, 0.0), y: bounds.height - graphInsetFrame.origin.y))
                    shadowBezier.closePath()
                    shadowBezier.addClip()
                    CGContextDrawLinearGradient(context, gradiant, CGPoint(x: 0, y: graphInsetFrame.origin.y), CGPoint(x: 0, y: bounds.height), CGGradientDrawingOptions.DrawsBeforeStartLocation)
                }
                
                // Cycle through all the points drawing the data circles
                CGContextRestoreGState(context)
                currentDataSet.color.setFill()
                currentDataSet.color.setStroke()
                var counter             = 0;
                var dataAverage:CGFloat = 0.0
                var dotRadius:CGFloat   = 0.0
                if currentDataSet.dataPoints.count < 10 {
                    dotRadius = 8.0
                }
                else if currentDataSet.dataPoints.count < 30 {
                    dotRadius = 6.0
                }
                else if currentDataSet.dataPoints.count < 45 {
                    dotRadius = 4.0
                }
                else if currentDataSet.dataPoints.count < 60 {
                    dotRadius = 2.5
                }
                
                // Cycle through all of the datapoints and draw the dots
                for currentPt in currentDataSet.dataPoints
                {
                    let dotCenter = CGPoint(x: columnXPosition(currentDataSet.dataPoints, CGFloat(counter)) - dotRadius/2,
                                            y: columnYPosition(currentPt.mmpGraphValue(), minValue, maxValue) -   dotRadius/2)
                    counter += 1
                    let graphDotPath = UIBezierPath(ovalInRect: CGRect(origin: dotCenter, size: CGSize(width: dotRadius, height: dotRadius)))
                    graphDotPath.fill()
                    dataAverage += currentPt.mmpGraphValue()
                }
                
                // Calculate and tell the delegate the average
                dataAverage /= CGFloat(currentDataSet.dataPoints.count)
                delegate?.averageCalculated(self, graphDataAverage: dataAverage, dataSet: currentDataSet)
                
                // Draw the 3 horizontal lines and the indicator lablese
                let graphMidPtY   = graphInsetFrame.origin.y + graphInsetFrame.size.height/2.0
                let averageWeight = (maxValue.mmpGraphValue() + minValue.mmpGraphValue())/2.0
                var bgLinePoints  = [graphInsetFrame.origin.y+graphInsetFrame.size.height, graphMidPtY, graphInsetFrame.origin.y]
                var bgLabelValues:[NSString] = [NSString.singlePrecisionFloat(minValue.mmpGraphValue(), attemptToTrim: true),
                                                NSString.singlePrecisionFloat(averageWeight, attemptToTrim: true),
                                                NSString.singlePrecisionFloat(maxValue.mmpGraphValue(), attemptToTrim: true)]
                
                // Enter here if there are a lot of graph points and you could have more than just 3 lines
                if currentDataSet.dataPoints.count > 30
                {
                    bgLinePoints.insert(graphMidPtY + graphInsetFrame.size.height/4.0, atIndex: 1)
                    bgLabelValues.insert(NSString.singlePrecisionFloat((averageWeight + minValue.mmpGraphValue()) / 2.0, attemptToTrim: true), atIndex: 1)
                    
                    bgLinePoints.insert(graphMidPtY - graphInsetFrame.size.height/4.0, atIndex: 3)
                    bgLabelValues.insert(NSString.singlePrecisionFloat((averageWeight + maxValue.mmpGraphValue()) / 2.0, attemptToTrim: true), atIndex: 3)
                }
                
                // Draw side markers
                let bgLinePath    = UIBezierPath()
                let bgLineWidth   = bounds.width-graphInsetFrame.origin.x
                counter           = 0
                for currentBGYPoint in bgLinePoints
                {
                    bgLinePath.moveToPoint(CGPoint(x: graphInsetFrame.origin.x, y: currentBGYPoint))
                    bgLinePath.addLineToPoint(CGPoint(x: bgLineWidth, y: currentBGYPoint))
                    
                    let currentLabel  = UILabel()
                    currentLabel.text = bgLabelValues[counter] as String
                    counter += 1
                    currentLabel.textColor = UIColor.whiteColor()
                    currentLabel.font      = lightFont
                    
                    // Primary data points are drawn on the right margin, secondary on the left
                    let xOrigin = (index == 0) ? (bgLineWidth+5.0) : 3.0
                    currentLabel.drawTextInRect(CGRect(x: xOrigin, y: currentBGYPoint-10, width: bounds.width-(bgLineWidth + 5), height: 20))
                }
                
                UIColor(white: 1.0, alpha: 0.5).setStroke()
                bgLinePath.lineWidth = 1.0
                bgLinePath.stroke()
                
                // Draw the x axis labels
                let xLabelWidth:CGFloat = 80.0
                let xLabelCount:Int     = min(currentDataSet.dataPoints.count, 6)
                if xLabelCount > 1 && index == 0 // Currently only draw the primary data plots x label
                {
                    for i in 0..<xLabelCount
                    {
                        let xIndex:Int       = min(Int((CGFloat(i)/CGFloat(xLabelCount-1)) * CGFloat(currentDataSet.dataPoints.count)), currentDataSet.dataPoints.count - 1)
                        let titleLabel       = UILabel()
                        titleLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
                        titleLabel.font      = boldFont
                        titleLabel.text      = currentDataSet.dataPoints[xIndex].mmpGraphTitle()
                        titleLabel.textAlignment = .Center

                        let xOrigin:CGFloat = columnXPosition(currentDataSet.dataPoints, CGFloat(xIndex)) - (xLabelWidth/2.0)
                        let yOrigin:CGFloat = CGRectGetMaxY(graphInsetFrame) + 10.0
                        titleLabel.drawTextInRect(CGRect(x: xOrigin, y: yOrigin, width: xLabelWidth, height: 20.0))
                    }
                }
            }
        }
        else
        {
            // Enter here if there are no qualifying data points
            let borderBezier = UIBezierPath()
            borderBezier.moveToPoint(CGPoint(x: graphInsetFrame.origin.x, y: graphInsetFrame.origin.y))
            borderBezier.addLineToPoint(CGPoint(x: graphInsetFrame.origin.x, y: graphInsetFrame.origin.y + graphInsetFrame.size.height))
            borderBezier.addLineToPoint(CGPoint(x: CGRectGetWidth(bounds) - graphInsetFrame.origin.x, y: graphInsetFrame.origin.y + graphInsetFrame.size.height))
            
            UIColor(white: 1.0, alpha: 0.5).setStroke()
            borderBezier.lineWidth = 1.0
            borderBezier.stroke()
            
            let noneLabel       = UILabel()
            noneLabel.text      = "No Data Available"
            noneLabel.textColor = UIColor.whiteColor()
            noneLabel.font      = UIFont.systemFontOfSize(30.0)
            noneLabel.sizeToFit()
            noneLabel.drawTextInRect(CGRect(x: bounds.width / 2.0 - noneLabel.bounds.width / 2.0, y: bounds.height / 2.0 - noneLabel.bounds.height, width: noneLabel.bounds.width, height: noneLabel.bounds.height))
        }
    }
    
    /**
     Responsible for getting the min and max values for a datasets
     
     - parameter curArray: The current array of datapoints
     
     - returns: A tuple of min max values
     */
    func maxMinElement(curArray:[MMPGraphDataPoint])->(minValue:MMPGraphDataPoint, maxValue:MMPGraphDataPoint) {
        
        var maxValue = curArray.first!
        var minValue = curArray.last!
        
        if maxValue.mmpGraphValue() < minValue.mmpGraphValue() {
            maxValue = minValue
            minValue = curArray.first!
        }
        
        for i in 0..<(curArray.count/2)
        {    
            let valueA = curArray[i*2]
            let valueB = curArray[i*2+1]
            
            if valueA.mmpGraphValue() <= valueB.mmpGraphValue() {
                
                if (valueA.mmpGraphValue() < minValue.mmpGraphValue()) {
                    minValue = valueA
                }
                
                if (valueB.mmpGraphValue() > maxValue.mmpGraphValue()) {
                    maxValue = valueB
                }
            }
            else {
                
                if valueA.mmpGraphValue() > maxValue.mmpGraphValue() {
                    maxValue = valueA
                }
                
                if valueB.mmpGraphValue() < minValue.mmpGraphValue() {
                    minValue = valueB
                }
            }
        }
        return (minValue, maxValue)
    }
    
    // MARK: - Data Plot Mutation Methods
    
    func activePlotValueChanged(segmentedController:UISegmentedControl)
    {
        currentPlotIdx = segmentedController.selectedSegmentIndex
        setNeedsDisplay()
    }
    
    // MARK: - Touch Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouch(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouch(touches, withEvent: event)
    }
    
    /// Responsible for reacting to the touch inside of the graph inset view - Updates the top label
    func handleTouch(touches: Set<UITouch>, withEvent event:UIEvent?) {
        
        if showTouchTitle {
            
            // If the touch point is in the drawn graph (or a little outside of it) handle it as a data touch
            let locationPoint = touches.first!.locationInView(self)
            let touchArea     = CGRectInset(graphInsetFrame, -10, -10)
            if CGRectContainsPoint(touchArea, locationPoint)
            {
                let normalizedX      = locationPoint.x - touchArea.origin.x
                let insetPercentage  = normalizedX / touchArea.size.width
                let index            = Int(floor(CGFloat(dataPlots[currentPlotIdx].primaryDataSet.dataPoints.count) * insetPercentage))
                let dataPointTouched = dataPlots[currentPlotIdx].primaryDataSet.dataPoints[index]

                titleLabel.attributedText = NSAttributedString(string: "\(dataPointTouched.mmpGraphTitle()):\(dataPointTouched.mmpGraphValue())")
            }
            else {
                titleLabel.attributedText = mainTitleText
            }
        }
    }
    
}
