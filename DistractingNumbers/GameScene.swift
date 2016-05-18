//
//  GameScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    
    override func didMoveToView(view: SKView) {
        //BG Game Scene Music
        let backgroundMusic = SKAudioNode(fileNamed: "menuSound.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //Falling Circle
        let fallingCircle = SKSpriteNode(imageNamed: "falling_circle")
        fallingCircle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 85)
        
        self.addChild(fallingCircle)
        
        //PlayButton
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        self.addChild(self.playButton)
        
        //TitleLabel
        let titleLabel = SKLabelNode(text: "Distraction")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.verticalAlignmentMode = .Top
        titleLabel.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 60))
        titleLabel.zPosition = 1
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontSize = 50
        
        self.addChild(titleLabel)
        
        //Highest Score Label
        let highScore = SKLabelNode(text: "Highest Score")
        highScore.fontName = "AvenirNext-Bold"
        highScore.verticalAlignmentMode = .Top
        highScore.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(playButton.frame) - 60))
        highScore.zPosition = 1
        highScore.fontColor = UIColor.whiteColor()
        highScore.fontSize = 36
        
        self.addChild(highScore)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}

