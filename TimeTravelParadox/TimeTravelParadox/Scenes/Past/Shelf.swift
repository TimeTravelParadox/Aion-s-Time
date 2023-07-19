//
//  Shelf.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit


class Shelf{
    var shelf: SKSpriteNode?
    var polaroid: SKSpriteNode?
    
    var enlarged = false
    
    let expand = SKAction.resize(toWidth: 1000, height: 1000, duration: 1)
    
    let shake = SKAction.sequence([
                SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
                SKAction.rotate(byAngle: .pi/6, duration: 0.5),
                SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
            ])
}
