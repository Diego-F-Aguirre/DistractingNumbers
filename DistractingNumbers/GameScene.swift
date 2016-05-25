//
//  GameScene.swift
//  DistractingNumbers
//
//  Created by Kaleo Kim on 5/16/16.
//  Copyright © 2016 home. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, GKGameCenterControllerDelegate {
    
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let playTitle = SKSpriteNode(imageNamed: "PlayTitle")
    var numContainer = SKSpriteNode()
    var numContainerSet = Set<SKSpriteNode>()
    
    override func didMoveToView(view: SKView) {
        Scores.highScore = 0
        
        addChild(Music.introMusic())
        
        spawnNumbersForever()
        authPlayer()
        
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60)
        backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        addChild(playButton)
        
        playTitle.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 160))
        playTitle.zPosition = 1
        addChild(playTitle)
        
        Labels.createLeaderBoardTitle()
        Labels.leaderBoard.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(playTitle.frame) - 525))
        addChild(Labels.leaderBoard)
    }
    
    func spawnNumbers() {
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 36
        let spawnPoint = CGFloat(arc4random_uniform(UInt32(maxValue - minValue)))
        let action = SKAction.moveToY(-160, duration: 2.8)
        let rand = CGFloat(arc4random_uniform(5))
        guard let numContainerParticles = SKEmitterNode(fileNamed: "CircleTrail.sks") else { return }
        
        numContainer = SKSpriteNode(imageNamed: "Circle")
        numContainer.name = "Circle"
        numContainer.size = CGSize(width: numContainer.frame.width / rand, height: numContainer.frame.height / rand)
        numContainer.position = CGPoint(x: spawnPoint, y: self.size.height)
        numContainer.runAction(SKAction.repeatActionForever(action))
        numContainer.zPosition = 2
        
        numContainerParticles.particleSize = numContainer.size
        
        addChild(numContainer)
        numContainer.addChild(numContainerParticles)
        numContainerSet.insert(numContainer)
    }
    
    func spawnNumbersForever() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnNumbers),SKAction.waitForDuration(0.7)])))
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
            if self.nodeAtPoint(location) == Labels.leaderBoard {
                self.postScoreToLeaderBoard()
            }
        }
    }
    
    func evictOffScreenNumNodes() {
        let results = numContainerSet.filter({$0.position.y < -$0.size.height / 2.0})
        
        results.forEach { (node) in
            node.removeFromParent()
            numContainerSet.remove(node)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        evictOffScreenNumNodes()
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
            }
        }
    }
    
    func postScoreToLeaderBoard() {
        
        guard let stringScore =  Scores.highScore?.stringValue else { return }
        
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "1.0")
            scoreReporter.value = Int64(stringScore)!
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
            print("Score sent to GameCenter")
            self.presentLeaderBoard()
        }
    }
    
    func presentLeaderBoard() {
        let viewController = self.view!.window?.rootViewController
        let leaderBoardVC = GKGameCenterViewController()
        leaderBoardVC.leaderboardIdentifier = "1.0"
        leaderBoardVC.gameCenterDelegate = self
        
        viewController!.presentViewController(leaderBoardVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}


