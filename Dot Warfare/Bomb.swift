//
//  Bomb.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/13/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//
//TODO:
//1. Bomb explosion needs to be specific to a particular color
//2. Need to incorporate collision detection for more satisying dot death after the bomb.

import SpriteKit

class Bomb: SKSpriteNode {
    
    init(scene: GameScene) {
        let image = UIImage(named: "redBomb")
        let texture = SKTexture(image: image!)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.setScale(0.75)
        self.zPosition = 200000
        self.isHidden = false
        self.name = "bomb"
        scene.addChild(self)
        self.run(SKAction.repeatForever(SKAction.rotate(byAngle: 2 * .pi, duration: 4)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func explode(scene: GameScene) {
        let firstRing = SKShapeNode(circleOfRadius: 55)
        firstRing.zPosition = 199998
        firstRing.fillColor = UIColor(red: 0, green: 255, blue: 255, alpha: 0.75)
        firstRing.isHidden = true
        firstRing.setScale(0.75)
        scene.addChild(firstRing)
        
        let whiteMask = SKShapeNode(circleOfRadius: 54.5)
        whiteMask.zPosition = 199999
        whiteMask.fillColor = SKColor.white
        whiteMask.isHidden = true
        whiteMask.setScale(0.75)
        scene.addChild(whiteMask)
        
        self.run(SKAction.scale(to: 1, duration: 0.5)) {
            firstRing.isHidden = false
            firstRing.run(SKAction.scale(to: 1, duration: 0.1)) {
                whiteMask.isHidden = false
                firstRing.run(SKAction.scale(to: 15, duration: 20))
                whiteMask.run(SKAction.scale(to: 15, duration: 20))
            }
        }
    }
}
