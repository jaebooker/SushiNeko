//
//  GameScene.swift
//  SushiNeko
//
//  Created by Jaeson Booker on 9/23/18.
//  Copyright © 2018 Jaeson Booker. All rights reserved.
//

import SpriteKit

//enum to figure out if cat gets the fish or chopstick
enum Side {
    case left, right, none
}
enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    var levelCounter: Int = 0
    var state: GameState = .title
    var strength: CGFloat = 0.01 {
        didSet {
            //health bar between 0-1
            healthBar.xScale = strength
        }
    }
    var score: Int = 100 {
        didSet {
            scoreCard.text = String(score)
        }
    }
    var playButton: SKSpriteNode!
    var healthBar: SKSpriteNode!
    var scoreCard: SKLabelNode!
    var sushiBasePiece: SushiPiece!
    var cat: Character!
    var sushiTower: [SushiPiece] = []
    let turnGreen = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.50)
    let turnGold = SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.50)
    let turnBlue = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.50)
    let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
    let turnWhite = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.50)
    var backgroundSound = SKAudioNode(fileNamed: "itsGonnaMakeMeAMonsterThough.mp3")
    
    override func didMove(to view: SKView) {
        self.addChild(backgroundSound)
        super.didMove(to: view)
        playButton = childNode(withName: "playButton") as! SKSpriteNode
//        playButton.selectedHandler = {
//            self.state = .ready
//        }
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreCard = childNode(withName: "scoreCard") as! SKLabelNode
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        cat = childNode(withName: "Cat") as! Character
        //connect chopsticks
        sushiBasePiece.connectChopsticks()
        healthBar.run(turnWhite)
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
    }
    func addRandomPieces(total: Int) {
        //adding some randomish sushi
        for _ in 1...total {
            //get last piece
            let lastPiece = sushiTower.last!
            //so we don't make sushi structures that are impossible
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                let rand = arc4random_uniform(100)
                
                if rand < 45 {
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    func addTowerPiece(side: Side) {
        //copy the sushi
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        //get the properties of the previous piece
        let lastPiece = sushiTower.last
        //put on sushi piece on the last one
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        //add up that Z
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        //set the side
        newPiece.side = side
        //add some sushi to the scene!
        addChild(newPiece)
        //add the sushi to the tower's greatness!
        sushiTower.append(newPiece)
    }
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    func gameLevel() {
        
        for s in sushiTower {
            if levelCounter == 0 {
                s.run(turnGreen)
                //backgroundSound.removeFromParent()
                //backgroundSound = SKAudioNode(fileNamed: "gonnaFlyNow.mp3")
                //addChild(backgroundSound)
            }
            if levelCounter == 1 {
                s.run(turnBlue)
            }
            if levelCounter == 2 {
                s.run(turnRed)
            }
            if levelCounter == 3 {
                s.run(turnGold)
            }
        }
        if levelCounter == 0 {
            cat.run(turnGreen)
        }
        if levelCounter == 1 {
            cat.run(turnBlue)
        }
        if levelCounter == 2 {
            cat.run(turnRed)
        }
        if levelCounter == 3 {
            cat.run(turnGold)
        }
        if levelCounter == 4 {
            state = .gameOver
            var counting = 0
            for s in sushiTower {
                if counting == 0 {
                    s.run(turnGreen)
                }
                if counting == 1 {
                    s.run(turnBlue)
                }
                if counting == 2 {
                    s.run(turnRed)
                }
                if counting == 3 {
                    s.run(turnGold)
                }
                if counting == 4 {
                    s.run(turnGreen)
                }
                if counting == 5 {
                    s.run(turnBlue)
                }
                if counting == 6 {
                    s.run(turnRed)
                }
                if counting == 7 {
                    s.run(turnGold)
                }
                if counting == 8 {
                    s.run(turnGreen)
                }
                if counting == 9 {
                    s.run(turnBlue)
                }
                if counting == 10 {
                    s.run(turnRed)
                }
                if counting == 11 {
                    s.run(turnGold)
                }
                counting += 1
            }
        }
        strength = 0
//        playButton.selectedHandler = {
//            let skView = self.view as SKView?
//            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
//                return
//            }
//            scene.scaleMode = .aspectFill
//            skView?.presentScene(scene)
//        }
        levelCounter += 1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .gameOver {
            return
        }
        if state == .title {
            state = .playing
            playButton.removeFromParent()
        }
        //playButton.position.z = -1
        let touch = touches.first!
        //find touch location
        let location = touch.location(in: self)
        //find out if touch was left or right side
        if location.x > size.width / 2 {
            cat.side = .right
        } else {
            cat.side = .left
        }
        //gets sushi as first sushi on base
        if let firstPiece = sushiTower.first as SushiPiece? {
            if cat.side == firstPiece.side {
                strength -= 0.01
                score -= 20
            } else {
                strength += 0.01
                score += 10
                if strength > 1 {
                    gameLevel()
                }
            }
            //remove first sushi
            sushiTower.removeFirst()
            firstPiece.flip(cat.side)
            //add new sushi to top
            addRandomPieces(total: 1)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if state == .gameOver {
            cat.run(turnGreen)
            cat.run(turnBlue)
            cat.run(turnRed)
            cat.run(turnGold)
        } else {
            moveTowerDown()
            score -= 1
        }
    }
}
