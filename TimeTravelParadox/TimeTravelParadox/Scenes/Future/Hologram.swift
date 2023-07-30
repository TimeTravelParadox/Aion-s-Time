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
  
  var holograma1peca = false
  
  var delegateRemove: RemoveProtocol?
  var delegateRemove2: RemoveProtocol2?
  
  let hologramaAnimate =  SKAction.animate(with: [SKTexture(imageNamed: "cartazCompleto"), SKTexture(imageNamed: "cartaz1"), SKTexture(imageNamed: "cartaz2"), SKTexture(imageNamed: "cartaz3"), SKTexture(imageNamed: "cartaz4"), SKTexture(imageNamed: "cartaz5"), SKTexture(imageNamed: "cartaz6")], timePerFrame: 0.1)
  
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
      
      self.isUserInteractionEnabled = true
    }
    
    if let hologram, let monitorDireita{
      self.addChild(hologram)
      self.addChild(monitorDireita)
    }
    
    monitorDireita?.isPaused = false
    startBlinkAnimation()
    
      if UserDefaultsManager.shared.hologramComplete1 == true {
          hologram?.run(.setTexture(SKTexture(imageNamed: "cartazComChip")))
          delegateRemove.removePeca()
          hologram?.texture = SKTexture(imageNamed: "cartazComChip")
          holograma1peca = true
          
      }
      
      if UserDefaultsManager.shared.hologramComplete2 == true {
          hologram?.run(.setTexture(SKTexture(imageNamed: "cartazComPeca")))
          delegateRemove2.removePeca()
          hologram?.texture = SKTexture(imageNamed: "cartazComPeca")
          holograma1peca = true
          
      }
      
      if UserDefaultsManager.shared.hologramComplete3 == true {
          hologram?.run(.setTexture(SKTexture(imageNamed: "cartazCompleto")))
          monitorDireita?.isHidden = true
          delegateRemove.removePeca()
          delegateRemove2.removePeca()
          hologram?.texture = SKTexture(imageNamed: "cartazCompleto")

      }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startBlinkAnimation() {
    let duration = 0.5 // Duração de cada ciclo de animação em segundos
    let fadeInAction = SKAction.fadeIn(withDuration: duration / 2.0)
    let fadeOutAction = SKAction.fadeOut(withDuration: duration / 2.0)
    
    // Cria uma sequência de ações para o efeito de aparecer e desaparecer
    let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
    
    // Repete a sequência para a animação continuar indefinidamente
    let repeatAction = SKAction.repeatForever(blinkAction)
    
    // Executa a animação no nó
    monitorDireita?.run(repeatAction)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
    
    switch tapped.name {
    case "monitorDireita":
      delegate?.zoom(isZoom: true, node: hologram, ratio: 0.4)
    case "hologram":
      
      if delegate?.didZoom == true && (HUD.shared.itemSelecionado == HUD.shared.peca1 || HUD.shared.itemSelecionado == HUD.shared.peca2) && holograma1peca && HUD.shared.itemSelecionado != nil{
        print("pecas completas colocada")
          hologram?.run(hologramaAnimate)
        monitorDireita?.isHidden = true
        delegateRemove?.removePeca()
        delegateRemove2?.removePeca()
          UserDefaultsManager.shared.hologramComplete3 = true
        
        scene?.run(SKAction.wait(forDuration: 5)){
          self.delegate?.zoom(isZoom: false, node: self.hologram, ratio: 0)
         
          GameScene.shared.creditos.zPosition = 21
          GameScene.shared.creditos.setScale(0.9)
          GameScene.shared.past?.zPosition = 0
          GameScene.shared.qg?.zPosition = 0
          GameScene.shared.future?.zPosition = 0
          GameScene.shared.hud.hideQGButton(isHide: true)
          GameScene.shared.hud.hideTravelQG(isHide: true)
          GameScene.shared.audioPlayerQGST?.pause()
          GameScene.shared.audioPlayerPastST?.pause()
          GameScene.shared.audioPlayerFutureST?.pause()
          GameScene.shared.past?.light?.isHidden = true
          
          GameScene.shared.hud.hideResetButton(isHide: false)
          
        }
        
      }
      if delegate?.didZoom == true && HUD.shared.itemSelecionado == HUD.shared.peca1 && !holograma1peca && HUD.shared.itemSelecionado != nil{
        print("peca1 colocada")
        hologram?.run(.setTexture(SKTexture(imageNamed: "cartazComChip")))
        delegateRemove?.removePeca()
        holograma1peca = true
          UserDefaultsManager.shared.hologramComplete1 = true
      }
      if delegate?.didZoom == true && HUD.shared.itemSelecionado == HUD.shared.peca2 && !holograma1peca && HUD.shared.itemSelecionado != nil{
        print("peca2 colocada")
        hologram?.run(.setTexture(SKTexture(imageNamed: "cartazComPeca")))
        delegateRemove2?.removePeca()
        holograma1peca = true
          UserDefaultsManager.shared.hologramComplete2 = true
      }
      if let selectedItem = HUD.shared.itemSelecionado {
        HUD.shared.removeBorder(from: selectedItem)
      }
      delegate?.zoom(isZoom: true, node: hologram, ratio: 0.4)
      
    default:
      return
    }
    inventoryItemDelegate?.clearItemDetail()
  }
  
}
