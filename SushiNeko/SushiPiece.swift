//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Jaeson Booker on 9/23/18.
//  Copyright © 2018 Jaeson Booker. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    //the chopsticks
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    //sushi type?
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                //show the chopstick
                leftChopstick.isHidden = false
            case .right:
                rightChopstick.isHidden = false
            case .none:
                //hise the chopsticks
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        //connecting chopsticks to child chopstick nodes
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        //set default
        side = .none
    }
}
