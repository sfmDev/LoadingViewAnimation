//
//  ViewController.swift
//  loadingViewAnimate
//
//  Created by 石峰铭 on 16/5/28.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pgv: LoadingProgressView?
    var progress: CGFloat = 0
    var image: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pgv = LoadingProgressView.init(frame: CGRectMake(10, 200, self.view.frame.size.width-20, 15))
        self.view.addSubview(pgv!)
        
        self.image = UIImageView.init(frame: CGRectMake(10, 200 - 20, 48, 48))
        self.image?.center = CGPointMake(10, 200-36/2)
        self.image?.image = UIImage(named: "5.pic_hd")
        self.view.addSubview(self.image!)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        NSTimer.scheduledTimerWithTimeInterval(1/10, target: self, selector: #selector(ViewController.animationTimerFired(_:)), userInfo: nil, repeats: true)
        
        let animationView = AnimationView(frame: CGRectMake(self.view.frame.size.width/2-38/2, 450, 38,38))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(resetLoadingAnimation))
        animationView.addGestureRecognizer(tap)
        self.view.addSubview(animationView)
    }
    
    func resetLoadingAnimation() {
        self.progress = 0.0
    }
    
    func animationTimerFired(theTimer: NSTimer) {
        
        let ret = arc4random()%10
        if ret > 3 {
            self.progress = self.progress + 0.02
            if self.progress <= 1 {
                pgv?.setProgress(progress)
                self.image?.frame = CGRectMake(self.progress * self.view.frame.size.width - 48/2, 200-20, 48, 48)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

