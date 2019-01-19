//
//  Bomb.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/13/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//

import SpriteKit

class Bomb: SKSpriteNode {
    
    var exploding = false
    var gameScene: GameScene!
    
    init(scene: GameScene) {
        self.gameScene = scene
        let image = UIImage(named: "redBomb")
        let texture = SKTexture(image: image!)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.setScale(0.75)
        self.zPosition = 3004
        self.isHidden = true
        scene.addChild(self)
        self.rotate()
        let touchable = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 120, height: 120))
        self.addChild(touchable)
        touchable.name = "bomb"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func rotate() {
        self.run(SKAction.repeatForever(SKAction.rotate(byAngle: 2 * .pi, duration: 4)))
    }
    
    func explode(scene: GameScene) {
        exploding = true
        let firstRing = SKShapeNode(circleOfRadius: 55)
        firstRing.zPosition = 3002
        firstRing.fillColor = UIColor(red: 0, green: 255, blue: 255, alpha: 0.75)
        firstRing.isHidden = true
        firstRing.setScale(0.75)
        firstRing.position = self.position
        scene.addChild(firstRing)
        
        let whiteMask = SKShapeNode(circleOfRadius: 54.5)
        whiteMask.zPosition = 3003
        whiteMask.fillColor = SKColor.white
        whiteMask.isHidden = true
        whiteMask.setScale(0.75)
        whiteMask.position = self.position
        scene.addChild(whiteMask)
        
        self.run(SKAction.scale(to: 1.5, duration: 0.5)) {
            firstRing.isHidden = false
            firstRing.run(SKAction.scale(to: 1, duration: 0.1)) {
                whiteMask.isHidden = false
                firstRing.run(SKAction.scale(to: 30, duration: 1)) {
                    firstRing.removeFromParent()
                }
                whiteMask.run(SKAction.scale(to: 30, duration: 1)) {
                    for dot in scene.game.dotArray {
                        dot.removeFromParent()
                        (self.gameScene.game as GameManager).currScore += 1
                    }
                    let score = (self.gameScene.game as GameManager).currScore
                    self.gameScene.currentScore.text = "Score: " + String(score)
                    scene.game.dotArray.removeAll()
                    whiteMask.removeFromParent()
                    (self.gameScene.game as GameManager).bombExists = false
                }
                self.run(SKAction.scale(to: 0, duration: 0.3)) {
                    //Hacky way to make sure the bomb disappears after its effect
                    self.run(SKAction.scale(to: 0, duration: 0.71)) {
                        self.removeFromParent()
                    }
                }
                
            }
        }
    }
    
    func moveUp() {
        self.run(SKAction.move(to: CGPoint(x: self.position.x, y: self.gameScene.frame.size.height), duration: 25)) {
            self.removeFromParent()
        }
    }
}
