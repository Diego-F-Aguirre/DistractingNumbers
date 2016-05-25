//
//  Labels.swift
//  DistractingNumbers
//
//  Created by Diego Aguirre on 5/20/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import SpriteKit

class Labels: SKLabelNode {
    
    static var scoreTitle = SKLabelNode()
    static var scoreLabel = SKLabelNode()
    static var highScore = SKLabelNode()
    static var highestScore = SKLabelNode()
    static var leaderBoard = SKLabelNode()
    
    static func createScoreTitle() -> SKLabelNode {
        scoreTitle = SKLabelNode(text: "Score:")
        scoreTitle.fontName = "AvenirNext-Bold"
        scoreTitle.verticalAlignmentMode = .Top
        scoreTitle.zPosition = 1
        scoreTitle.fontColor = UIColor.whiteColor()
        scoreTitle.fontSize = 60
        
        return scoreTitle
    }
    
    static func createScoreLabel() -> SKLabelNode {
        scoreLabel = SKLabelNode(text: "\(Scores.score)")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.verticalAlignmentMode = .Top
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.fontSize = 55
        
        return scoreLabel
    }
    
    static func createHighScore() -> SKLabelNode {
        highScore = SKLabelNode(text: "Your High Score:")
        highScore.fontName = "AvenirNext-Bold"
        highScore.verticalAlignmentMode = .Top
        highScore.zPosition = 1
        highScore.fontColor = UIColor.whiteColor()
        highScore.fontSize = 32
        
        return highScore
    }
    
    static func createHighestScore() -> SKLabelNode {
        highestScore.fontName = "AvenirNext-Bold"
        highestScore.verticalAlignmentMode = .Top
        highestScore.zPosition = 1
        highestScore.fontColor = UIColor.whiteColor()
        highestScore.fontSize = 28
        
        return highScore
    }
    
    static func createLeaderBoardTitle() -> SKLabelNode {
        leaderBoard = SKLabelNode(text: "Leaderboard")
        leaderBoard.fontName = "AvenirNext-Bold"
        leaderBoard.verticalAlignmentMode = .Top
        leaderBoard.zPosition = 1
        leaderBoard.fontColor = UIColor.whiteColor()
        //leaderBoard.fontSize = 32
        
        return leaderBoard
    }
    
}