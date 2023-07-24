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
    var takenPolaroid: Bool = false
    
    let expand = SKAction.resize(toWidth: 1000, height: 1000, duration: 1)
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "shelf":
            delegate?.zoom(isZoom: true, node: shelf, ratio: 0.5)
            print("shelf")
        case "hiddenPolaroid":
            // se clicar na polaroid e tiver com zoom
            if delegate?.didZoom == true && takenPolaroid == false {
                polaroid?.isHidden = false
                
                let moveToInventary = SKAction.run {
                    HUD.addOnInv(node: self.polaroid)
                  
                    self.takenPolaroid = true
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
