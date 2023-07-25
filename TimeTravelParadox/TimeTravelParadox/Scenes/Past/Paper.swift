//
//  Paper.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 25/07/23.
//

//
//  Paper.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 25/07/23.
//

import SpriteKit

class Paper: SKNode {
    
    var paper = SKSpriteNode(fileNamed: "paper")
    var inventoryItemDelegate: InventoryItemDelegate?
    var crumpledPaper = SKSpriteNode(imageNamed: "crumpledPaper")
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        
        if let paper, HUD.shared.inventario.contains(where: { $0.name == "paper" }) {
            inventoryItemDelegate?.select(node: paper)
        }
        
    }
    
    
}

