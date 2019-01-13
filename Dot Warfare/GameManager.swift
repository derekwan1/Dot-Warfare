//
//  GameManager.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/11/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//

import SpriteKit

class GameManager {
    var scene: GameScene!
    var nextTime: Double?
    var timeExtension: Double = 0.75
    var currentScore: Int = 0
    var previousLane: Int?
    var dotArray: [Dot] = []
    var gameStarted = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initGame() {
        renderChange()
        gameStarted = true
    }
    
    func generateDot() {
        let dot = Dot(circleOfRadius: CGFloat(25))
        dot.radius = 25
        var laneNumber = Int(CGFloat(arc4random_uniform(7)))
        if previousLane != nil {
            while previousLane == laneNumber {
                laneNumber = Int(CGFloat(arc4random_uniform(7)))
            }
        }
        var x: CGFloat!
        switch (laneNumber) {
        case 0:
            x = -(scene.frame.size.width / 2) * 3/4
        case 1:
            x = -(scene.frame.size.width / 2) * 2/4
        case 2:
            x = -(scene.frame.size.width / 2) * 1/4
        case 3:
            x = 0
        case 4:
            x = (scene.frame.size.width / 2) * 1/4
        case 5:
            x = (scene.frame.size.width / 2) * 2/4
        case 6:
            x = (scene.frame.size.width / 2) * 3/4
        default:
            x = 0
        }
        dot.position = CGPoint(x: x, y: -(scene.frame.size.height / 2) + 80)
        dot.x = x
        dot.setScale(0)
        dot.initialize(color: "red", scene: scene)
        scene.addChild(dot)
        dot.isHidden = false
        dot.grow()
        dot.moveUp()
        dotArray.append(dot)
        previousLane = laneNumber
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! && gameStarted {
                nextTime = time + timeExtension
                if !scene.is_paused {
                    generateDot()
                }
            }
        }
    }
    
    //Code from SNAKE below this comment
    //______________________________________________________________________
    
    func renderChange() {
    }
    
    private func contains(a: [(Int, Int)], v: (x: Int, y: Int)) -> Bool {
        for (X, Y) in a {
            if X == v.0 && Y == v.1 {
                return true
            }
        }
        return false
    }
    
    private func generateNewPoint() {
        var randomX = CGFloat(arc4random_uniform(39))
        var randomY = CGFloat(arc4random_uniform(19))
        while contains(a: scene.playerPositions, v: (Int(randomX), Int(randomY))) {
            randomX = CGFloat(arc4random_uniform(39))
            randomY = CGFloat(arc4random_uniform(19))
        }
        scene.scorePos = CGPoint(x: randomX, y: randomY)
    }
    
    private func checkForScore() {
        if scene.scorePos != nil {
            let x = scene.playerPositions[0].1 //column index. scorePos's x is the row number
            let y = scene.playerPositions[0].0 //row index
            if Int((scene.scorePos?.x)!) == Int(y) && Int((scene.scorePos?.y)!) == Int(x) {
                currentScore += 1
                scene.currentScore.text = "Score: \(currentScore)"
                generateNewPoint()
                scene.playerPositions.append(scene.playerPositions.last!)
            }
        }
    }
    
    private func updateScore() {
        if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currentScore, forKey: "bestScore")
        }
        currentScore = 0
        scene.currentScore.text = "Score: 0"
        scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    private func finishAnimation() {
    }
}
