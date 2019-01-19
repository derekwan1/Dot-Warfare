//
//  Dot.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/12/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//
//TODO: Need to add more colored dots as well as color-specific movements/deaths.

import SpriteKit

class Dot: SKShapeNode {
    
    var radius: CGFloat!
    var gameScene: GameScene!
    var x: CGFloat!
    var splashDot: SKShapeNode!
    var whiteMask: SKShapeNode!
    var dying = false
    
    func initialize(color: String, scene: GameScene) {
        self.gameScene = scene
        self.isHidden = false
        self.name = "red"
        if color == "red" {
            self.fillColor = SKColor.red
        }
        let clickableDot = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 80, height: 80))
        clickableDot.zPosition = self.zPosition - 1
        self.addChild(clickableDot)
    }
    
    func grow() {
        self.run(SKAction.scale(to: 1, duration: 1))
    }
    
    func moveUp() {
        var randomX = Int(arc4random_uniform(UInt32((self.gameScene.frame.width / 2) - 75)))
        let left_or_right = arc4random_uniform(2)
        if left_or_right == 0 {
            randomX = -1 * randomX
        }
        let randomY = Int(arc4random_uniform(UInt32(150)))
        let currY = Int(self.position.y)
        let moveUp = SKAction.move(to: CGPoint(x: randomX, y: currY + randomY), duration: 0.75)
        self.run(moveUp)
    }
    
    func die(color: String) {
        self.removeAllActions()
        dying = true
        splashDot = SKShapeNode(circleOfRadius: self.radius)
        splashDot.zPosition = self.zPosition - 2
        splashDot.name = "splash"
        splashDot.isHidden = false
        splashDot.position = self.position
        gameScene.addChild(splashDot)
        
        if color == "red" {
            splashDot!.fillColor = SKColor(red: 200, green: 0.5, blue: 0.5, alpha: 0.5)
        }
        
        whiteMask = SKShapeNode(circleOfRadius: self.radius)
        whiteMask.zPosition = self.zPosition - 1
        whiteMask.name = "white splash"
        whiteMask.fillColor = SKColor.white
        whiteMask.isHidden = false
        whiteMask.position = self.position
        gameScene.addChild(whiteMask)
        
        self.run(SKAction.scale(to: 1.2, duration: 0.15)) {
            self.run(SKAction.scale(to: 0, duration: 0.6))
        }
        splashDot.run(SKAction.scale(to: 2, duration: 0.2)) {
            self.whiteMask.run(SKAction.scale(to: 2, duration: 0.4))
        }
        
        //Hacky thing to delay the removal from the scene. Otherwise the dots get removed
            //while the scaling animations are happening.
        self.run(SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.76)) {
            self.splashDot.removeFromParent()
            self.whiteMask.removeFromParent()
            self.removeFromParent()
        }
    }
}
