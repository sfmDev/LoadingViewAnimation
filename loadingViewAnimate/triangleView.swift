//
//  triangleView.swift
//  loadingViewAnimate
//
//  Created by 石峰铭 on 16/5/31.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit

class triangleView: UIView {
    
    override func drawRect(rect: CGRect) {
        
        let width = self.frame.size.width * 0.65
        let width2 = width / (sqrt(3))
        
        let centerX = self.frame.size.width/2
        let centerY = self.frame.size.height/2
        
        let pointA = CGPointMake(centerX + (width*2/3), centerY)
        let pointB = CGPointMake(pointA.x - width, pointA.y - width2)
        let pointC = CGPointMake(pointB.x, pointB.y + 2 * width2)
        
        let path = UIBezierPath()
        path.moveToPoint(pointA)
        path.addLineToPoint(pointB)
        path.addLineToPoint(pointC)
        
        path.closePath()
        
        let fillColor = UIColor(red: 0.52,green: 0.67,blue: 0.07,alpha: 1.00)
        
        fillColor.set()
        path.fill()
        
        path.stroke()
    }
}
