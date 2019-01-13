//
//  Dot.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/12/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//

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
        self.zPosition = 4
        self.isHidden = false
        self.name = "red"
        if color == "red" {
            self.fillColor = SKColor.red
        }
        
    }
    
    func grow() {
        self.run(SKAction.scale(to: 0.35, duration: 0.2)) {
            self.run(SKAction.scale(to: 0.6, duration: 0.2)) {
                self.run(SKAction.scale(to: 0.8, duration: 0.25)) {
                    self.run(SKAction.scale(to: 1, duration: 0.4))
                }
            }
        }
    }
    
    func moveUp() {
        self.run(SKAction.move(to: CGPoint(x: self.x, y: self.gameScene.frame.size.height), duration: 25)) {
            self.removeFromParent()
        }
    }
    
    func die(color: String) {
        self.removeAllActions()
        dying = true
        splashDot = SKShapeNode(circleOfRadius: self.radius)
        splashDot.zPosition = 2
        splashDot.name = "splash"
        splashDot.isHidden = false
        splashDot.position = self.position
        gameScene.addChild(splashDot)
        
        if color == "red" {
            splashDot!.fillColor = SKColor(red: 200, green: 0.5, blue: 0.5, alpha: 0.5)
        }
        
        whiteMask = SKShapeNode(circleOfRadius: self.radius)
        whiteMask.zPosition = 3
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