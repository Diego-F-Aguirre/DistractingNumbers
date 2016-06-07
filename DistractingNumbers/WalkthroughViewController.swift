//
//  WalkthroughViewController.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 6/6/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    var index = 0
    var imageName = ""
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        
        startButton.hidden = (index == 1) ? false : true
        startButton.layer.cornerRadius = 6.0
        startButton.layer.masksToBounds = true

    }
    
    @IBAction func startButtonClicked(sender: AnyObject) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "DisplayedWalkthrough")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
