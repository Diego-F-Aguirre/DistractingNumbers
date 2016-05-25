//
//  GameViewController.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 5/16/16.
//  Copyright (c) 2016 home. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
            skView.sizeToFit()
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
           UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    // Todo: Status white bar not showing up
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true 
    }
}
