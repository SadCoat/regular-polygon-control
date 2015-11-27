//
//  SCRegularPolygonControl.swift
//  SCRegularPolygon
//
//  Created by Joel Costa on 26/11/15.
//  Copyright © 2015 SadCoat. All rights reserved.
//

import UIKit

extension Int {
    /// Convert the angle value to radian value
    var scDegreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

@IBDesignable
class SCRegularPolygonControl: UIControl {
    
    var _verticesCount:Int = 3
    /// Polygon certices quantity. Min: 3; Max: 1000
    @IBInspectable var verticesCount:Int {
        set(newValue) {
            _verticesCount = max(3, min(1000, newValue))
        }
        get {
            return _verticesCount
        }
    }
    
    /// Polygon fill color
    @IBInspectable var color:UIColor = UIColor.whiteColor()
    /// Polygon shadow color
    @IBInspectable var shadowColor:UIColor = UIColor.blackColor()
    /// Shadow blur radius
    @IBInspectable var shadowBlurRadius:CGFloat = 0
    /// Polygon shadow offset
    @IBInspectable var shadowOffset:CGSize = CGSizeZero
    /// Polygon rotation
    @IBInspectable var rotation:Int = 0

    /// Polygon translation
    @IBInspectable var translation:CGPoint = CGPointZero
    
    var _margin:CGFloat = 0
    /// Polygon margin
    @IBInspectable var margin:CGFloat {
        set(newValue) {
            _margin = max(0, newValue)
        }
        get {
            return _margin
        }
    }
    
    var _cornerRadius:CGFloat = 0
    /// Polygon corners radius
    @IBInspectable var cornerRadius:CGFloat {
        set(newValue) {
            _cornerRadius = max(0, newValue)
        }
        get {
            return _cornerRadius
        }
    }
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
        //self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }
    #endif
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        
        let center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
        CGContextTranslateCTM(context, center.x + translation.x, center.y + translation.y);
        
        /**
        *  Rotate the context to apply rotation, if necessary
        */
        if (rotation > 0) {
            CGContextRotateCTM(context, CGFloat(rotation.scDegreesToRadians));
        }
        
        /**
        *  Set context shadow, if necessary
        */
        if (shadowBlurRadius > 0) {
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
        }
        
        CGContextBeginPath(context)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        /**
         *  Calculate the angle for the custom vertices quantity
         */
        let angle = 2 * M_PI / Double(verticesCount)
        
        /**
         *  Calculate the edge length based on rect size and blur radius
         */
        let size:Double = (Double( min(rect.size.height, rect.size.width)) / 2.0) - Double(margin)
        
        /**
         *  Calculate all the necessary vertices coordinates
         */
        var points = [CGPoint]()
        for i in 1...verticesCount {
            points.append(CGPoint(x: CGFloat(size * sin(Double(i) * angle )), y: CGFloat(size * cos(Double(i) * angle))))
        }
        
        /**
        *  Set context path
        */
        CGContextMoveToPoint(context, (points[verticesCount-1].x + points[0].x) / 2, (points[verticesCount-1].y + points[0].y) / 2)
        for i in 0...verticesCount-2 {
            CGContextAddArcToPoint(context, points[i].x, points[i].y, points[i+1].x, points[i+1].y, cornerRadius)
        }
        CGContextAddArcToPoint(context, points[verticesCount-1].x, points[verticesCount-1].y, points[0].x, points[0].y, cornerRadius)
        
        /**
        *  Close the path
        */
        CGContextClosePath(context)
        
        /**
        *  Draw the path by filling the area within the path
        */
        CGContextDrawPath(context, CGPathDrawingMode.Fill);
        
        CGContextRestoreGState(context);
        
    }
    
}