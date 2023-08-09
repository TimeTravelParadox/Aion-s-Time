//
//  Paper.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 25/07/23.
//

import SpriteKit

// Enumeração de modos do papel (Paper).
enum PaperMode {
    case onDrawer
    case onInv
}

class Paper: SKNode {
    // Propriedade que define o modo atual do papel.
    var mode: PaperMode = .onDrawer
    
    // Nó do SpriteKit que representa o papel no estado de gaveta.
    var paper = SKSpriteNode(imageNamed: "paper")
    
    // Delegate para gerenciar interações com o inventário.
    var inventoryItemDelegate: InventoryItemDelegate?
    
    // Nó do SpriteKit que representa o papel amassado.
    var crumpledPaper = SKSpriteNode(imageNamed: "crumpledPaper")
    
    init(parentNode: SKNode) {
        super.init()
        isUserInteractionEnabled = true
        paper.name = "paper"
        addChild(crumpledPaper)
        
        // Quando a variável 'takenCrumpledPaper' no UserDefaults estiver definida como true,
        // o papel amassado é adicionado ao inventário.
        if UserDefaultsManager.shared.takenCrumpledPaper == true {
            parentNode.addChild(self)
            HUD.addOnInv(node: crumpledPaper)
            mode = .onInv
            CasesPositions(node: crumpledPaper)
            inventoryItemDelegate?.select(node: crumpledPaper)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        _ = touch.location(in: self)
        
        switch mode {
        // Quando estiver no modo de gaveta, essas ações podem ocorrer:
        case .onDrawer:
            position = .zero
            HUD.addOnInv(node: crumpledPaper)
            UserDefaultsManager.shared.takenCrumpledPaper = true
            mode = .onInv
        // Quando estiver no modo de inventário, esse delegate será notificado da seleção do nó do papel.
        case .onInv:
            inventoryItemDelegate?.select(node: paper)
        }
    }
}
