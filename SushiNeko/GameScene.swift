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

class GameScene: SKScene {
    var sushiBasePiece: SushiPiece!
    var cat: Character!
    var sushiTower: [SushiPiece] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        cat = childNode(withName: "Cat") as! Character
        //connect chopsticks
        sushiBasePiece.connectChopsticks()
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
}
