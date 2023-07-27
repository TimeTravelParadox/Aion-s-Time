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
  
    init(parentNode: SKNode) {
    super.init()
    isUserInteractionEnabled = true
    paper.name = "paper"
    addChild(crumpledPaper)
      if UserDefaultsManager.shared.takenCrumpledPaper == true {
          parentNode.addChild(self)
          HUD.addOnInv(node: crumpledPaper)
          mode = .onInv
      }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    
    switch mode {
    case .onDrawer:
      position = .zero
      HUD.addOnInv(node: crumpledPaper)
      UserDefaultsManager.shared.takenCrumpledPaper = true
      mode = .onInv
    case .onInv:
      inventoryItemDelegate?.select(node: paper)
    }
  }
}
