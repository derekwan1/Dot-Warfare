//
//  GameManager.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/11/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//
//TODO:
//      Need to find criteria for making bomb appear
//      Need to add magnet bomb (attract all dots to one area so you can tap quickly)
//      Need to add electrocutor (electrocutes every dot in a lane)

import SpriteKit

class GameManager {
    var scene: GameScene!
    var nextTime: Double?
    var timeExtension: Double = 0.75
    var currentScore: Int = 0
    var previousLane: Int?
    var dotArray: [Dot] = []
    var gameStarted = false
    var numDots = 0
    var boom = 1
    var currScore = 0
    var bomb: Bomb!
    var bombExists = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initGame() {
        gameStarted = true
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! && gameStarted {
                nextTime = time + timeExtension
                if !scene.is_paused {
                    if boom == 1 {
                        generateBomb()
                        boom = 0
                    } else if !(bombExists && bomb.exploding) {
                        generateDot()
                    }
                    for dot in dotArray {
                        if !dot.dying {
                            dot.moveUp()
                        }
                    }
                    if bombExists && !bomb.exploding {
                        bomb.moveUp()
                    }
                }
            }
        }
    }
    
    func generateDot() {
        //This makes sure we don't hit the zPosition limit
        if numDots == 1000 {
            numDots = 0
        }
        let dot = Dot(circleOfRadius: CGFloat(25))
        numDots += 1
        dot.radius = 25
        // This makes sure that dot explosions don't overlap
        dot.zPosition = CGFloat(4 + (numDots * 3))
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
        dotArray.append(dot)
        previousLane = laneNumber
    }
    
    func generateBomb() {
        bomb = Bomb(scene: scene)
        bombExists = true
        bomb.isHidden = false
        var randomX = Int(arc4random_uniform(UInt32((scene.frame.width / 2) - 200)))
        let left_or_right = arc4random_uniform(2)
        if left_or_right == 0 {
            randomX = -1 * randomX
        }
        bomb.position = CGPoint(x: CGFloat(randomX), y: -(scene.frame.size.height / 2) + 80)
        bomb.setScale(0)
        bomb.grow()
    }
    
    func moveBomb() {
        var randomX = Int(arc4random_uniform(UInt32((scene.frame.width / 2) - 200)))
        let left_or_right = arc4random_uniform(2)
        if left_or_right == 0 {
            randomX = -1 * randomX
        }
        let new_pos = CGPoint(x: CGFloat(randomX), y: -(scene.frame.size.height / 2) + 55)
        bomb.run(SKAction.move(to: new_pos, duration: 2))
    }
    
    func updateScore() {
        if currScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currScore, forKey: "bestScore")
        }
        scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
}
