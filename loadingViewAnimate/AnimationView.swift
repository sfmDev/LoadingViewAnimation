//
//  AnimationView.swift
//  loadingViewAnimate
//
//  Created by 石峰铭 on 16/6/1.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit

class AnimationView: UIView {
    
    var NSTimeInterval: Double = 0.65
    
    lazy var centerImage: triangleView = {
        
        var centerImage = triangleView(frame: CGRectMake(0,0, self.bounds.size.width*0.5, self.bounds.size.width*0.5))
        centerImage.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2)
        return centerImage
    }()
    
    var maskLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not been implemented")
    }
    
    private func setUp() {
        self.addSubview(centerImage)
        
        let path = UIBezierPath.init(ovalInRect: self.bounds)
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clearColor().CGColor
        maskLayer.path = path.CGPath
        maskLayer.strokeColor = UIColor(red: 0.52, green: 0.76, blue: 0.07, alpha: 1.00).CGColor
        maskLayer.lineWidth = 1
        maskLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(maskLayer)
        
        maskLayer.transform = CATransform3DRotate(maskLayer.transform, CGFloat(-M_PI_2), 0, 0, 1)
        maskLayer.transform = CATransform3DTranslate(maskLayer.transform, -self.bounds.size.width, 0, 0)
        
        self.maskLayer = maskLayer
        
        animationOne()
    }
    
    func animationOne() {
        self.maskLayer?.strokeStart = 0
        self.maskLayer?.strokeEnd = 1
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.duration = NSTimeInterval
        basicAnimation.delegate = self
        basicAnimation.setValue("BasicAnimationEnd", forKey: "animationName")
        self.maskLayer?.addAnimation(basicAnimation, forKey: "BasicAnimationEnd")
    }
    
    func animationTwo() {
        self.maskLayer?.strokeStart = 1
        
        let basic = CABasicAnimation(keyPath: "strokeStart")
        basic.fromValue = 0
        basic.duration = NSTimeInterval
        basic.delegate = self
        basic.setValue("BasicAnimationStart", forKey: "animationName")
        self.maskLayer?.addAnimation(basic, forKey: "BasicAnimationStart")
    }
}

extension AnimationView {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim.valueForKey("animationName") as! String == "BasicAnimationEnd" {
            let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            basicAnimation.toValue = CGFloat(2*M_PI)
            basicAnimation.duration = NSTimeInterval
            basicAnimation.delegate = self
            
            basicAnimation.setValue("BasicAnimationRotation", forKey: "animationName")
            centerImage.layer.addAnimation(basicAnimation, forKey:"BasicAnimationRotation")
            //开始圆消失的动画
            animationTwo()
        }else if anim.valueForKey("animationName") as! String == "BasicAnimationStart" {
            self.maskLayer?.removeAllAnimations()
            centerImage.layer.removeAllAnimations()
            animationOne()
        }
    }
}
