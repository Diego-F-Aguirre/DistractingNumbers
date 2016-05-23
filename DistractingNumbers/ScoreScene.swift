//
//  ScoreScene.swift
//  DistractingNumbers
//
//  Created by Parker Donat on 5/17/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit
import GameKit

class ScoreScene: SKScene, GKGameCenterControllerDelegate {
    
    let playAgainButton = SKSpriteNode(imageNamed: "PlayAgain")
    let menuButton = SKSpriteNode(imageNamed: "Menu")
    
    override func didMoveToView(view: SKView) {
        
        guard let savedHighScore = NSUserDefaults.standardUserDefaults().objectForKey("savedHighScore") else { return }
        
        runAction(Music.gameOver())
        
        backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        Labels.createScoreTitle()
        Labels.scoreTitle.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 60))
        addChild(Labels.scoreTitle)
        
        Labels.createScoreLabel()
        Labels.scoreLabel.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(Labels.scoreTitle.frame) - 60))
        addChild(Labels.scoreLabel)
        
        playAgainButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 30)
        addChild(playAgainButton)
        
        menuButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60)
        addChild(menuButton)
        
        Labels.createHighScore()
        Labels.highScore.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(menuButton.frame) - 100))
        addChild(Labels.highScore)
        
        Labels.highestScore = SKLabelNode(text: "\(savedHighScore)")
        Labels.createHighestScore()
        Labels.highestScore.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(Labels.highScore.frame) - 60))
        addChild(Labels.highestScore)
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
    
    func userSavedHighScore(number: Int) {
        guard let getHighScore = NSUserDefaults.standardUserDefaults().objectForKey("savedHighScore") else { return }
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "1.0")
            
            scoreReporter.value = Int64(getHighScore as! String)!
            
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
            
            print("Score sent to GameCenter")
            
            self.presentLeaderBoard()
        }
        
    }
    
    func presentLeaderBoard() {
        let leaderBoardVC = GKGameCenterViewController()
        leaderBoardVC.leaderboardIdentifier = "1.0"
        leaderBoardVC.gameCenterDelegate = self
        // TODO PRESENT VIEW
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}