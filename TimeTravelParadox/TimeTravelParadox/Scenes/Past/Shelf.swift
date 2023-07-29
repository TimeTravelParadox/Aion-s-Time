//
//  Shelf.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit

class Shelf: SKNode{
  let past = SKScene(fileNamed: "PastScene")
  
  var delegate: ZoomProtocol?
  var inventoryItemDelegate: InventoryItemDelegate?
  
  var hiddenPolaroid: SKSpriteNode?
  var shelf: SKSpriteNode?
  var polaroid: SKSpriteNode?
  
  let expand = SKAction.resize(toWidth: 400, height: 400, duration: 1)
  
  let shake = SKAction.sequence([
    SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
    SKAction.rotate(byAngle: .pi/6, duration: 0.5),
    SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
  ])
  
  init(delegate: ZoomProtocol){
    self.delegate = delegate
    super.init()
    self.zPosition = 1
    if let past {
      shelf = (past.childNode(withName: "shelf") as? SKSpriteNode)
      shelf?.removeFromParent()
      polaroid = (past.childNode(withName: "polaroid") as? SKSpriteNode)
      polaroid?.removeFromParent()
      hiddenPolaroid = (past.childNode(withName: "hiddenPolaroid") as? SKSpriteNode)
      hiddenPolaroid?.removeFromParent()
      self.isUserInteractionEnabled = true
    }
    if let shelf, let polaroid, let hiddenPolaroid{
      self.addChild(shelf)
      self.addChild(polaroid)
      self.addChild(hiddenPolaroid)
      
      polaroid.isHidden = true
      polaroid.isPaused = false
      hiddenPolaroid.isPaused = false
    }
    isPaused = false
      
      if UserDefaultsManager.shared.takenPolaroid == true {
          
          hiddenPolaroid?.isHidden = true
          polaroid?.isHidden = false
          
//          paper?.isHidden = true
//          paperComplete?.isHidden = false
//          text?.isHidden = true
          HUD.addOnInv(node: polaroid)
          polaroid?.zPosition = 15
          polaroid?.size = CGSize(width: 30, height: 30)
          CasesPositions(node: polaroid)
      }
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
      
      inventoryItemDelegate?.clearItemDetail()
    
    switch tapped.name {
    case "shelf":
      delegate?.zoom(isZoom: true, node: shelf, ratio: 0.5)
      print("shelf")
    case "hiddenPolaroid":
      // se clicar na polaroid e tiver com zoom
        if delegate?.didZoom == true && UserDefaultsManager.shared.takenPolaroid == false {
        polaroid?.isHidden = false
            hiddenPolaroid?.isHidden = true
        
        let moveToInventary = SKAction.run {
          HUD.addOnInv(node: self.polaroid)
            UserDefaultsManager.shared.takenPolaroid = true
        }
        let sequence = SKAction.sequence([expand, shake, moveToInventary])
        polaroid?.run(sequence)
        self.polaroid?.zPosition = 3
        // se clicar na polaroid e nao tiver com zoom
      }else{
        delegate?.zoom(isZoom: true, node: shelf, ratio: 0.5)
      }
      print("hiddenPolaroid")
    case "polaroid":
      if let polaroid, HUD.shared.inventario.contains(where: { $0.name == "polaroid" }) {
        inventoryItemDelegate?.select(node: polaroid)
      }
    default:
      return
    }
  }
}
