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
    var musicNode = SKAudioNode()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.184, alpha: 1.00)
        
        Scores.highScore = 0
        
        spawnNumbersForever()
        authPlayer()
        
        playTitle.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) * 0.80))
        playTitle.size = CGSize(width: playTitle.size.width - (playTitle.size.width * 0.1), height: playTitle.size.height - (playTitle.size.height * 0.1))
        playTitle.zPosition = 1
        addChild(playTitle)
        
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.50)
        playButton.size = CGSize(width: 200, height: 200)
        addChild(playButton)
        
        Labels.createLeaderBoardTitle()
        Labels.leaderBoard.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) * 0.25))
        Labels.leaderBoard.fontSize = CGRectGetMaxY(self.frame)/20
        addChild(Labels.leaderBoard)
        
        Labels.createMusicLabel()
        Labels.musicLabel.position = (CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) * 0.15))
        Labels.musicLabel.fontSize = CGRectGetMaxY(self.frame)/25
        addChild(Labels.musicLabel)
        
        musicNode = Music.introMusic()
        if MusicBool.musicIsOn == true {
            Labels.musicLabel.text = "Music: On"
            addChild(musicNode)
        } else {
            Labels.musicLabel.text = "Music: Off"
        }
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
            if self.nodeAtPoint(location) == Labels.musicLabel {
                if MusicBool.musicIsOn == true {
                    MusicBool.musicIsOn = false
                    Labels.musicLabel.text = "Music: Off"
                    for child in self.children as [SKNode] {
                        if child.name == "intro" {
                            self.removeChildrenInArray([child])
                        }
                    }
                } else if MusicBool.musicIsOn == false {
                    MusicBool.musicIsOn = true
                    Labels.musicLabel.text = "Music: On"
                    addChild(musicNode)
                }
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


