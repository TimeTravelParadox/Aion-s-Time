//
//  Hologram.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

class Hologram: SKNode {
    
    
    private let future = SKScene(fileNamed: "FutureScene")
    
    var delegate: ZoomProtocol?
    private var hologram: SKSpriteNode?
    var inventoryItemDelegate: InventoryItemDelegate?
    
    var monitorDireita: SKSpriteNode?
    var cartaz: SKSpriteNode?
    
    var holograma1peca = false
    
    var delegateRemove: RemoveProtocol?
    var delegateRemove2: RemoveProtocol2?
    
    let hologramaAnimate =  SKAction.animate(with: [SKTexture(imageNamed: "hologramaUmaPeca"), SKTexture(imageNamed: "holograma0"), SKTexture(imageNamed: "holograma1"), SKTexture(imageNamed: "holograma2"), SKTexture(imageNamed: "holograma3")], timePerFrame: 0.4)
    
    init(delegate: ZoomProtocol, delegateRemove: RemoveProtocol, delegateRemove2: RemoveProtocol2) {
        super.init()
        self.delegate = delegate
        self.delegateRemove = delegateRemove
        self.delegateRemove2 = delegateRemove2
        self.zPosition = 1
        
        
        
        if let future {
            hologram = future.childNode(withName: "hologram") as? SKSpriteNode
            hologram?.removeFromParent()
            monitorDireita = future.childNode(withName: "monitorDireita") as? SKSpriteNode
            monitorDireita?.removeFromParent()
            cartaz = future.childNode(withName: "cartaz") as? SKSpriteNode
            cartaz?.removeFromParent()
            
            self.isUserInteractionEnabled = true
        }
        
        if let hologram, let monitorDireita, let cartaz{
            self.addChild(hologram)
            self.addChild(monitorDireita)
            self.addChild(cartaz)
        }
        
        cartaz?.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "monitorDireita":
            delegate?.zoom(isZoom: true, node: hologram, ratio: 0.5)
        case "hologram":
            
            
//            if delegate?.didZoom == true && (HUD.shared.itemSelecionado == HUD.shared.peca1 || HUD.shared.itemSelecionado == HUD.shared.peca2) && holograma1peca{
//                print("pecas completas colocada")
//                hologram?.run(.setTexture(SKTexture(imageNamed: "hologramaCompleto")))
//                monitorDireita?.isHidden = true
//                cartaz?.isHidden = false
//                delegateRemove?.removePeca()
//            }
            if delegate?.didZoom == true && (HUD.shared.itemSelecionado == HUD.shared.peca2 || HUD.shared.itemSelecionado == HUD.shared.peca2) && holograma1peca && HUD.shared.itemSelecionado != nil{
                print("pecas completas colocada")
                hologram?.run(.setTexture(SKTexture(imageNamed: "hologramaCompleto")))
                monitorDireita?.isHidden = true
                cartaz?.isHidden = false
                delegateRemove?.removePeca()
                delegateRemove2?.removePeca()
            }
            if delegate?.didZoom == true && HUD.shared.itemSelecionado == HUD.shared.peca1 && !holograma1peca && HUD.shared.itemSelecionado != nil{
                print("peca1 colocada")
                hologram?.run(.setTexture(SKTexture(imageNamed: "hologramaUmaPeca")))
                delegateRemove?.removePeca()
                holograma1peca = true
            }
            if delegate?.didZoom == true && HUD.shared.itemSelecionado == HUD.shared.peca2 && !holograma1peca && HUD.shared.itemSelecionado != nil{
                print("peca2 colocada")
                hologram?.run(.setTexture(SKTexture(imageNamed: "hologramaPeca2")))
                delegateRemove2?.removePeca()
                holograma1peca = true
            }
            if let selectedItem = HUD.shared.itemSelecionado {
                HUD.shared.removeBorder(from: selectedItem)
            }
            delegate?.zoom(isZoom: true, node: hologram, ratio: 0.5)
            
        default:
            return
        }
        inventoryItemDelegate?.clearItemDetail()
    }
    
}
