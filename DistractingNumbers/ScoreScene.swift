//
//  ScoreScene.swift
//  DistractingNumbers
//
//  Created by Parker Donat on 5/17/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit

class ScoreScene: SKScene {
    
    let playAgainButton = SKSpriteNode(imageNamed: "PlayAgain")
    let menuButton = SKSpriteNode(imageNamed: "Menu")
    
    override func didMoveToView(view: SKView) {
        
        runAction(SKAction.playSoundFileNamed("gameEnded.wav", waitForCompletion: false))
        
        guard let savedHighScore = NSUserDefaults.standardUserDefaults().objectForKey("savedHighScore") else {return}
        
        self.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        // SCORE TITLE
        let scoreTitle = SKLabelNode(text: "Score:")
        scoreTitle.fontName = "AvenirNext-Bold"
        scoreTitle.verticalAlignmentMode = .Top
        scoreTitle.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 60))
        scoreTitle.zPosition = 1
        scoreTitle.fontColor = UIColor.whiteColor()
        scoreTitle.fontSize = 60
        
        self.addChild(scoreTitle)
        
        // SCORE LABEL
        let scoreLabel = SKLabelNode(text: "\(Scores.score)")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.verticalAlignmentMode = .Top
        scoreLabel.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(scoreTitle.frame) - 60))
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.fontSize = 55
        
        self.addChild(scoreLabel)
        
        // PLAY AGAIN BUTTON
        playAgainButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 30)
        //playAgainButton.size = CGSize(width: 250, height: 250)
        self.addChild(playAgainButton)
        
        // MENU BUTTON
        menuButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60)
        self.addChild(menuButton)
        
        //HIGH SCORE LABEL
        let highScore = SKLabelNode(text: "Your High Score:")
        highScore.fontName = "AvenirNext-Bold"
        highScore.verticalAlignmentMode = .Top
        highScore.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(menuButton.frame) - 100))
        highScore.zPosition = 1
        highScore.fontColor = UIColor.whiteColor()
        highScore.fontSize = 32
        
        self.addChild(highScore)
        
        // SCORE LABEL 2
        let highestScore = SKLabelNode(text: "\(savedHighScore)")
        highestScore.fontName = "AvenirNext-Bold"
        highestScore.verticalAlignmentMode = .Top
        highestScore.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(highScore.frame) - 60))
        highestScore.zPosition = 1
        highestScore.fontColor = UIColor.whiteColor()
        highestScore.fontSize = 28
        
        self.addChild(highestScore)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playAgainButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
            
            if self.nodeAtPoint(location) == self.menuButton {
                let scene = GameScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
    }
}