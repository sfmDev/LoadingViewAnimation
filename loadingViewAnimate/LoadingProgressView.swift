//
//  LoadingProgressView.swift
//  loadingViewAnimate
//
//  Created by 石峰铭 on 16/5/28.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit
import QuartzCore

let gradientColor1 = UIColor(red: 29/255, green: 182/255, blue: 37/255, alpha: 1).CGColor
let gradientColor2 = UIColor(red: 87/255, green: 240/255, blue: 94/255, alpha: 1).CGColor
let gradientColor3 = UIColor(red: 29/255, green: 182/255, blue: 37/255, alpha: 1).CGColor
let kScreenWidth: CGFloat                    = UIScreen.mainScreen().bounds.width
let kScreenHeight: CGFloat                   = UIScreen.mainScreen().bounds.height
let BarInset: CGFloat                        = 1
let CORNERRADIUS: CGFloat                    = 2.5
var GradientWidth: CGFloat                   = 0.2
let AnimationFramesPerSec: Int               = 30

class LoadingProgressView: UIView {
    
    var mask: CAShapeLayer?
    var animationTimer: NSTimer?
    var animationTimerCount: Int = 0
    var gradientLocations: CGFloat = 0
    var gradientLocations1: CGFloat = 0
    var gradientLocations2: CGFloat = 0
    var innerRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        self.innerRect = CGRectMake(BarInset, BarInset, frame.size.width - 2 * BarInset, frame.size.height - 2 * BarInset)
        
        self.layer.cornerRadius = CORNERRADIUS
        self.layer.masksToBounds = true
        
        let colorArray = NSMutableArray()
        colorArray.addObject(gradientColor1)
        colorArray.addObject(gradientColor2)
        colorArray.addObject(gradientColor3)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = innerRect!
        gradient.colors = colorArray as [AnyObject]
        gradient.locations = [0,0.3,0.6]
        gradient.cornerRadius = CORNERRADIUS
        gradient.masksToBounds = true
        gradient.startPoint = CGPointMake(0, 0.5)
        gradient.endPoint = CGPointMake(1, 0.5)
        self.layer.addSublayer(gradient)
        
        let glossStart: CGColorRef = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.3).CGColor
        let glossEnd: CGColorRef = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.1).CGColor
        let glossArray = NSArray.init(array: [glossStart,glossEnd])
        
        let lay = CAGradientLayer()
        lay.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2)
        lay.colors = glossArray as [AnyObject]
        lay.startPoint = CGPointMake(0, 0)
        lay.endPoint = CGPointMake(0, 1)
        self.layer.addSublayer(lay)
        
        self.mask = CAShapeLayer()
        self.mask?.fillRule = kCAFillRuleEvenOdd
        self.mask?.fillColor = UIColor(red: 202/255, green: 202/255, blue: 202/255, alpha: 1).CGColor
        gradient.addSublayer(self.mask!)
        
        let maskPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, self.innerRect!.size.width, self.innerRect!.size.height), cornerRadius: CORNERRADIUS)
        let cutoutPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, 0, innerRect!.size.height), byRoundingCorners:[.TopLeft,.BottomLeft], cornerRadii: CGSizeMake(CORNERRADIUS, CORNERRADIUS))
        maskPath.appendPath(cutoutPath)
        mask?.path = maskPath.CGPath
        
        if self.animationTimer == nil {
            self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(1/30, target: self, selector: #selector(setNeedsDisplay), userInfo: nil, repeats: true)
        }
    }
    
    override func drawRect(rect: CGRect) {
        if ++animationTimerCount == 2*AnimationFramesPerSec {
            animationTimerCount = 0
        }
        self.setGradientLocation(CGFloat(animationTimerCount)/CGFloat(AnimationFramesPerSec) - GradientWidth)
    }
    
    func setGradientLocation(leftEdge: CGFloat) -> Void {
        
//        var left = leftEdge
//        left = left - GradientWidth
        self.gradientLocations = leftEdge < 0 ? 0 : (leftEdge > 1.0 ? 1.0 : leftEdge)
        self.gradientLocations1 = (leftEdge + GradientWidth) < 1 ? (leftEdge + GradientWidth) : 1
        self.gradientLocations2 = (gradientLocations1 + GradientWidth) < 1 ? (gradientLocations1 + GradientWidth) : 1
        
        let layer: CAGradientLayer = self.layer.sublayers![0] as! CAGradientLayer
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.locations = [self.gradientLocations,self.gradientLocations1,self.gradientLocations2]
        CATransaction.commit()
    }
    
    func setProgress(progress: CGFloat, animated: Bool) {
        progress < 0 ? 0 : progress
        progress > 1 ? 1 : progress
        let maskPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, innerRect!.size.width, innerRect!.size.height), cornerRadius: CORNERRADIUS)
        
        let width = (kScreenWidth - 2 * BarInset) * progress
        
        let cutoutPath = UIBezierPath.init(rect: CGRectMake(0, 0, width, self.innerRect!.size.height))
        maskPath.appendPath(cutoutPath)
        
        if animated == true {
            let anim = CABasicAnimation.init(keyPath: "path")
            anim.delegate = self
            anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            anim.duration = 0.3
            anim.removedOnCompletion = false
            anim.fillMode = kCAFillModeForwards
            anim.fromValue = mask?.path
            anim.toValue = maskPath.CGPath
            mask?.addAnimation(anim, forKey: "path")
            mask?.path = maskPath.CGPath
        }else {
            mask?.path = maskPath.CGPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setProgress(progress: CGFloat) {
        self.setProgress(progress, animated: true)
    }
}
