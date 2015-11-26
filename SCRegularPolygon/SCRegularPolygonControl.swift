//
//  SCRegularPolygonControl.swift
//  SCRegularPolygon
//
//  Created by Joel Costa on 26/11/15.
//  Copyright © 2015 SadCoat. All rights reserved.
//

import UIKit

extension Int {
    var scDegreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

@IBDesignable
class SCRegularPolygonControl: UIControl {
    
    @IBInspectable var color:UIColor = UIColor.whiteColor()
    @IBInspectable var shadowColor:UIColor = UIColor.blackColor()
    @IBInspectable var blurRadius:CGFloat = 0
    @IBInspectable var rotation:Int = 0
    
    var _cornerRadius:CGFloat = 0
    @IBInspectable var cornerRadius:CGFloat {
        set(newValue) {
            _cornerRadius = max(0, newValue)
        }
        get {
            return _cornerRadius
        }
    }
    
    var _verticesCount:Int = 3
    @IBInspectable var verticesCount:Int {
        set(newValue) {
            _verticesCount = max(3, newValue)
        }
        get {
            return _verticesCount
        }
    }
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false    
    }
    #endif
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        
        let center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
        CGContextTranslateCTM(context, center.x, center.y);
        
        // Rotation
        if (rotation > 0) {
            CGContextRotateCTM(context, CGFloat(rotation.scDegreesToRadians));
        }
        
        // Shadow
        if (blurRadius > 0) {
            CGContextSetShadowWithColor(context, CGSizeZero, blurRadius, shadowColor.CGColor);
        }
        
        //Begin drawing setup
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        //Start drawing polygon
        let angle = 2 * M_PI / Double(verticesCount)
        var points = [CGPoint]()
        let size:Double = (Double( min(rect.size.height, rect.size.width)) / 2.0) - 5.0
        
        for i in 1...verticesCount {
            points.append(CGPoint(x: CGFloat(size * sin(Double(i) * angle )), y: CGFloat(size * cos(Double(i) * angle))))
        }
        
        CGContextMoveToPoint(context, (points[verticesCount-1].x + points[0].x) / 2, (points[verticesCount-1].y + points[0].y) / 2)
        for i in 0...verticesCount-2 {
          CGContextAddArcToPoint(context, points[i].x, points[i].y, points[i+1].x, points[i+1].y, cornerRadius)
        }
        CGContextAddArcToPoint(context, points[verticesCount-1].x, points[verticesCount-1].y, points[0].x, points[0].y, cornerRadius)
        
        //Finish Drawing
        CGContextClosePath(context)
        CGContextDrawPath(context, CGPathDrawingMode.Fill);
        
        CGContextRestoreGState(context);
        
    }
    
}