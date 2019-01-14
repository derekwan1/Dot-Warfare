//
//  GameScene.swift
//  Dot Warfare
//
//  Created by Derek Wan on 1/11/19.
//  Copyright © 2019 Derek Wan. All rights reserved.
//
//TODO: Need to convert all dots to sprites to optimize.

import SpriteKit
import GameplayKit

//Something to consider in the future to make stuff run faster
//let texture = SKView().texture(from: desiredNode)
//let newSprite = SKSpriteNode(texture: texture)
class GameScene: SKScene {
    
    //1
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var pauseButtonA: SKShapeNode!
    var pauseButtonB: SKShapeNode!
    var pauseBtn: SKShapeNode!
    var playButton2: SKShapeNode!
    var game: GameManager!
    
    var currentScore: SKLabelNode!
    var paused_status: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBG: SKShapeNode!
    var pauseBG: SKShapeNode!
    
    var scorePos: CGPoint?
    var is_paused: Bool!
    
    override func didMove(to view: SKView) {
        //2
        initializeMenu()
        game = GameManager(scene: self)
        initializeGameView()
    }
    
    private func initializeGameView() {
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        
        let width = frame.size.width
        let height = frame.size.height
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.white
        gameBG.zPosition = 0
        gameBG.isHidden = true
        self.addChild(gameBG)
        
        paused_status = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        paused_status.zPosition = 1.1
        paused_status.position = CGPoint(x: 0, y: (frame.size.height / 2) - 80)
        paused_status.fontSize = 40
        paused_status.isHidden = true
        paused_status.text = "Paused"
        paused_status.fontColor = SKColor.black
        self.addChild(paused_status)
    }
    
    //3
    private func initializeMenu() {
        //Initialize paused
        is_paused = false
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKE"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
        //Create left pause line
        pauseButtonA = SKShapeNode()
        pauseButtonA.name = "left_pause_button"
        pauseButtonA.zPosition = 999999999999
        pauseButtonA.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        pauseButtonA.fillColor = SKColor.black
        let topRight = CGPoint(x: (frame.size.width / -2) + 96, y: frame.size.height - 230)
        let bottomRight = CGPoint(x: (frame.size.width / -2) + 96, y: frame.size.height - 270)
        let topLeft = CGPoint(x: (frame.size.width / -2) + 106, y: frame.size.height - 230)
        let bottomLeft = CGPoint(x: (frame.size.width / -2) + 106, y: frame.size.height - 270)
        let path1 = CGMutablePath()
        path1.addLine(to: topRight)
        path1.addLines(between: [topRight, bottomRight, bottomLeft, topLeft])
        pauseButtonA.path = path1
        pauseButtonA.isHidden = true
        self.addChild(pauseButtonA)
        //Create right pause line
        pauseButtonB = SKShapeNode()
        pauseButtonB.name = "right_pause_button"
        pauseButtonB.zPosition = 999999999999
        pauseButtonB.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        pauseButtonB.fillColor = SKColor.black
        let topRight2 = CGPoint(x: (frame.size.width / -2) + 126, y: frame.size.height - 230)
        let bottomRight2 = CGPoint(x: (frame.size.width / -2) + 126, y: frame.size.height - 270)
        let topLeft2 = CGPoint(x: (frame.size.width / -2) + 116, y: frame.size.height - 230)
        let bottomLeft2 = CGPoint(x: (frame.size.width / -2) + 116, y: frame.size.height - 270)
        let path2 = CGMutablePath()
        path2.addLine(to: topRight2)
        path2.addLines(between: [topRight2, bottomRight2, bottomLeft2, topLeft2])
        pauseButtonB.path = path2
        pauseButtonB.isHidden = true
        self.addChild(pauseButtonB)
        //Create mini play button
        playButton2 = SKShapeNode()
        playButton2.name = "play_button2"
        playButton2.zPosition = 1
        playButton2.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton2.fillColor = SKColor.black
        let play_top = CGPoint(x: (frame.size.width / -2) + 100, y: frame.size.height - 230)
        let play_bottom = CGPoint(x: (frame.size.width / -2) + 100, y: frame.size.height - 270)
        let play_middle = CGPoint(x: (frame.size.width / -2) + 130, y: frame.size.height - 250)
        let play_path = CGMutablePath()
        play_path.addLine(to: topCorner)
        play_path.addLines(between: [play_top, play_bottom, play_middle])
        playButton2.path = play_path
        playButton2.isHidden = true
        self.addChild(playButton2)
        //Create rectangle behind pause button
        let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
        pauseBtn = SKShapeNode(rect: rect, cornerRadius: 10)
        pauseBtn.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        pauseBtn.position = CGPoint(x: (frame.size.width / -2) + 72.5, y: (frame.size.height / 2) - 90)
        pauseBtn.zPosition = 999999999999
        pauseBtn.name = "pause_button"
        pauseBtn.isHidden = true
        self.addChild(pauseBtn)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        game.update(time: currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
                
                if (node.name == "pause_button" && !is_paused) {
                    is_paused = true
                    self.pauseButtonA.isHidden = true
                    self.pauseButtonB.isHidden = true
                    self.playButton2.isHidden = false
                    self.paused_status.isHidden = false
                    for dot in game.dotArray {
                        dot.isPaused = true
                        if dot.dying {
                            dot.whiteMask.isPaused = true
                            dot.splashDot.isPaused = true
                        }
                    }
                    let width = frame.size.width
                    let height = frame.size.height
                    let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
                    pauseBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
                    pauseBG.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.2)
                    pauseBG.isHidden = false
                    self.addChild(pauseBG)
                    pauseBG.position = CGPoint(x: 0, y: height)
                    pauseBG.zPosition = 100001
                    pauseBG.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.3))
                } else if node.name == "pause_button" && is_paused {
                    is_paused = false
                    self.pauseButtonA.isHidden = false
                    self.pauseButtonB.isHidden = false
                    self.playButton2.isHidden = true
                    self.paused_status.isHidden = true
                    for dot in game.dotArray {
                        dot.isPaused = false
                        if dot.dying {
                            dot.whiteMask.isPaused = false
                            dot.splashDot.isPaused = false
                        }
                    }
                    pauseBG.run(SKAction.move(to: CGPoint(x: 0, y: frame.size.height), duration: 0.3)) {
                        self.pauseBG.isHidden = true
                    }
                }
                
                if node.name == "bomb" {
                    //bomb labels are given to the touchable clear nodes
                    let bomb = node.parent as? Bomb
                    bomb?.removeAllActions()
                    bomb?.explode(scene: self)
                }

                if node.name == "red" && !is_paused {
                    let dot = node as? Dot
                    dot!.die(color: "red")
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func startGame() {
        gameLogo.run(SKAction.move(by: CGVector(dx: 0, dy: 600), duration: 0.4)) {
            self.gameLogo.isHidden = true
        }
        
        playButton.run(SKAction.scale(to: 0, duration: 0.4)) {
            self.playButton.isHidden = true
        }
        
        pauseButtonA.run(SKAction.scale(to: 1, duration: 1)) {
            self.pauseButtonA.isHidden = false
        }
        
        pauseButtonB.run(SKAction.scale(to: 1, duration: 1)) {
            self.pauseButtonB.isHidden = false
        }
        
        pauseBtn.run(SKAction.scale(to: 1, duration: 1)) {
            self.pauseBtn.isHidden = false
        }
        
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
            self.currentScore.setScale(0)
            self.gameBG.isHidden = false
//            self.currentScore.isHidden = false
            self.bestScore.isHidden = true
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            
            self.game.initGame()
        }
    }
}
