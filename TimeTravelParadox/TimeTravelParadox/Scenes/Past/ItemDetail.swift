//
//  ItemDetail.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 21/07/23.
//

import SpriteKit

class ItemDetail: SKSpriteNode {
    var itemName: String?
    // var text: SKSpriteNode
    
    init(item: SKSpriteNode) {
        itemName = item.name
        super.init(texture: item.texture, color: item.color, size: item.size)
        name = "itemDetail"
        zPosition = item.zPosition
        
        switch itemName {
        case "polaroid":
            size = CGSize(width: 100 * GameScene.shared.ratio!, height: 100 * GameScene.shared.ratio!)
        case "crumpledPaper":
            size = CGSize(width: 100 * GameScene.shared.ratio!, height: 100 * GameScene.shared.ratio!)

            
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interact() {
        switch itemName {
        case "polaroid":
            spin()
        case "crumpledPaper":
            let paper = SKSpriteNode(imageNamed: "paper")
            
            self.addChild(paper)
        default:
            return
        }
    }
    
    private func spin() {
        let spinPolaroid = SKAction.rotate(byAngle: .pi, duration: 0.2)
        run(spinPolaroid)
    }
}

