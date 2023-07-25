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

enum PaperMode {
    case onDrawer
    case onInv
}

class Paper: SKNode {
    var mode: PaperMode = .onDrawer
    var paper = SKSpriteNode(imageNamed: "paper")
    var inventoryItemDelegate: InventoryItemDelegate?
    var crumpledPaper = SKSpriteNode(imageNamed: "crumpledPaper")
    
    override init() {
        super.init()
        isUserInteractionEnabled = true
        paper.name = "paper"
        addChild(crumpledPaper)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        switch mode {
        case .onDrawer:
            position = .zero
            HUD.addOnInv(node: crumpledPaper)
            mode = .onInv
        case .onInv:
            inventoryItemDelegate?.select(node: paper)
        }
    }
}

