//
//  JTExtension.swift
//  JTRefreshDemo
//
//  Created by jintao on 2018/3/11.
//  Copyright © 2018年 jintao. All rights reserved.
//

/**
   为了防止和项目其他扩展重命名，统一加前缀jt
 **/

import UIKit


// MARK: - UIView
extension UIView {
    
    var jt_maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    var jt_maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    var jt_x: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    
    var jt_y: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    
    var jt_width: CGFloat {
        get {
            return self.bounds.width
        }
    }
    
    var jt_height: CGFloat {
        get {
            return self.bounds.height
        }
    }
    
    var jt_size: CGSize {
        get {
            return self.bounds.size
        }
    }
    
    
    /// 设置圆角 (不能和layer.border同时设置。。。)
    func setCornerRadius(_ radius: CGFloat) {
        
        let cornerPath = UIBezierPath()
        cornerPath.move(to: CGPoint(x: 0, y: radius))
        cornerPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
        cornerPath.addLine(to: CGPoint(x: self.jt_width-radius, y: 0))
        cornerPath.addArc(withCenter: CGPoint(x: self.jt_width-radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi)*3/2, endAngle: 0, clockwise: true)
        cornerPath.addLine(to: CGPoint(x: self.jt_width, y: self.jt_height-radius))
        cornerPath.addArc(withCenter: CGPoint(x: self.jt_width-radius, y: self.jt_height-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi)/2, clockwise: true)
        cornerPath.addLine(to: CGPoint(x: radius, y: self.jt_height))
        cornerPath.addArc(withCenter: CGPoint(x: radius, y: self.jt_height-radius), radius: radius, startAngle: CGFloat(Double.pi)/2, endAngle: CGFloat(Double.pi), clockwise: true)
        cornerPath.addLine(to: CGPoint(x: 0, y: radius))
        cornerPath.close()
        
        let cornerLayer = CAShapeLayer()
        cornerLayer.path = cornerPath.cgPath
        self.layer.mask = cornerLayer
    }
    
}


// MARK: - Date
extension Date {
    
    func jt_isToday() -> Bool {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.string(from: self) == formater.string(from: Date())
    }
    
}


