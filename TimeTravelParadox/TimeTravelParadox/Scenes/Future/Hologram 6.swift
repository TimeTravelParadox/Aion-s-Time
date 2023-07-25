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
    
    var holograma1peca = false
    
    var clock: Clock?
    var vault: Vault?
    
    var delegateRemove: removeFromParent?
  
  let hologramaAnimate =  SKAction.animate(with: [SKTexture(imageNamed: "hologramaUmaPeca"), SKTexture(imageNamed: "holograma0"), SKTexture(imageNamed: "holograma1"), SKTexture(imageNamed: "holograma2"), SKTexture(imageNamed: "holograma3")], timePerFrame: 0.4)
  
    init(delegate: ZoomProtocol, clock: Clock) {
      self.delegate = delegate
      self.clock = clock

    super.init()
    self.delegate = delegate
    self.zPosition = 1
    
    if let future {
      hologram = future.childNode(withName: "hologram") as? SKSpriteNode
      hologram?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    
    if let hologram{
      self.addChild(hologram)
    }
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
    case "hologram":
        clock?.removeClock()
        if delegate?.didZoom == true && (HUD.shared.itemSelecionado == HUD.shared.peca1 || HUD.shared.itemSelecionado == HUD.shared.peca2) && holograma1peca{
            print("peca2 colocada")
            hologram?.run(hologramaAnimate)
            if HUD.shared.itemSelecionado == HUD.shared.peca1{
                if let clock = clock {
                    clock.peca1?.removeFromParent()
                }
            }else{
                if let vault = vault {
                    vault.peca2?.removeFromParent()
                }
            }
        }
        if delegate?.didZoom == true && (HUD.shared.itemSelecionado == HUD.shared.peca1 || HUD.shared.itemSelecionado == HUD.shared.peca2) && !holograma1peca{
            print("peca1 colocada")
            hologram?.run(.setTexture(SKTexture(imageNamed: "hologramaUmaPeca")))
            if HUD.shared.itemSelecionado == HUD.shared.peca1{
//                if let clock = clock {
//                    clock.peca1?.removeFromParent()
//                }
                print("peca do clock colocada")
//                clock?.removerPeca1()
            }else{
//                if let vault = vault {
//                    vault.peca2?.removeFromParent()
//                }
                print("peca do vault colocada")
                vault!.removerPeca2()
            }
            holograma1peca = true
        }
        if let selectedItem = HUD.shared.itemSelecionado {
            HUD.shared.removeBorder(from: selectedItem)
        }
      delegate?.zoom(isZoom: true, node: hologram, ratio: 0.5)
      
    default:
      return
    }
    
  }
  
}
