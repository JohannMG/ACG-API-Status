//
//  StatusBarView.swift
//  CCMStatus
//
//  Created by Johann Garces on 12/12/16.
//  Copyright © 2016 johannmg. All rights reserved.
//

import UIKit

class StatusBarView: UIView {
    
    typealias SimpleRange = (min: Int, max: Int)
    
    let overlayView = UIView()
    
    let greenColor = UIColor(red: 0.17, green: 0.63, blue: 0.08, alpha: 1.00)
    let yellowColor = UIColor(red: 0.94, green: 0.75, blue: 0.45, alpha: 1.00)
    let redColor = UIColor(red: 0.61, green: 0.04, blue: 0.08, alpha: 1.00)
    
    let greenMax = 999
    let yellowMax = 1999
    
    //green 0ms - 999ms
    //yellow 10001ms - 1999ms
    //red 2000ms
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawAndColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawAndColor()
    }
    
    
    var currentRange = 50 {
        didSet {
            drawAndColor()
        }
    }
    
    func drawAndColor(){
        
        overlayView.frame = CGRect(origin: CGPointZero, size: CGSize(width: CGFloat( getProportionalWidthForCurrentRange() ), height: frame.height))
        overlayView.backgroundColor = getColorForCurrentRange()
        
        if overlayView.superview == nil {
            self.addSubview(overlayView)
        }
        
        
    }
    
    func getProportionalWidthForCurrentRange() -> Int {
        return linearMap(currentRange, fromRange: (0,2000), toRange: (0, Int(frame.width)) )
    }
    
    private func linearMap( value: Int, fromRange: SimpleRange, toRange: SimpleRange ) -> Int {
        if value < fromRange.min {
            return toRange.min
        } else if value > fromRange.max {
            return toRange.max
        }
        
        let offset = value - fromRange.min
        let originalRangeSize = fromRange.max - fromRange.min
        let newRangeSize = toRange.max - toRange.min
        
        let interpolated = ((offset * newRangeSize) / originalRangeSize ) + toRange.min
        return interpolated
        
    }
    
    
    func getColorForCurrentRange() -> UIColor{
        
        var color = redColor
        
        if currentRange <= yellowMax {
            color = yellowColor
        }
        
        if currentRange <= greenMax {
            color = greenColor
        }
        
        return color
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawAndColor()
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
     
    }
    */
    
    
    
    
    
    
    

}
