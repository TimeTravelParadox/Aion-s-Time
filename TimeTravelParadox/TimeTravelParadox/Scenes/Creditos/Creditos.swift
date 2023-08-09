//
//  Creditos.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 29/07/23.
//

import SpriteKit

// Classe que representa a tela de créditos no jogo.
class Creditos: SKNode {
  
  private let creditos = SKScene(fileNamed: "Creditos")
  
  // Nodes da tela de créditos
  var telaFinal: SKSpriteNode?
  var telaCreditos: SKSpriteNode?
  var telaEmBreve: SKSpriteNode?
  var botaoCreditos: SKSpriteNode?
  var botaoEmBreve: SKSpriteNode?
  var setaVoltarFinal: SKSpriteNode?
  
  // Som que será reproduzido ao clicar em botões.
  let clickButtonsSound = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
  override init() {
    super.init()

    // Configuração dos nós da tela de créditos
    if let creditos {
      telaFinal = creditos.childNode(withName: "telaFinal") as? SKSpriteNode
      telaFinal?.removeFromParent()
      
      telaCreditos = creditos.childNode(withName: "telaCreditos") as? SKSpriteNode
      telaCreditos?.removeFromParent()
      
      telaEmBreve = creditos.childNode(withName: "telaEmBreve") as? SKSpriteNode
      telaEmBreve?.removeFromParent()

      botaoCreditos = creditos.childNode(withName: "botaoCreditos") as? SKSpriteNode
      botaoCreditos?.removeFromParent()
      
      botaoEmBreve = creditos.childNode(withName: "botaoEmBreve") as? SKSpriteNode
      botaoEmBreve?.removeFromParent()
      
      setaVoltarFinal = creditos.childNode(withName: "setaVoltarFinal") as? SKSpriteNode
      setaVoltarFinal?.removeFromParent()
      
      self.isUserInteractionEnabled = true

    }
    
    // Adiciona os nós à cena principal da classe
    if let telaFinal, let telaCreditos, let telaEmBreve, let botaoCreditos, let botaoEmBreve, let setaVoltarFinal {
      self.addChild(telaFinal)
      self.addChild(telaCreditos)
      self.addChild(telaEmBreve)
      self.addChild(botaoCreditos)
      self.addChild(botaoEmBreve)
      self.addChild(setaVoltarFinal)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Função que é chamada quando o usuário toca na tela.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // Se não estiver tocando, retorna.
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // Verifica se algum nó foi tocado.
    
    // Realiza ação de acordo com o nó tocado.
    switch tapped.name {
    case "botaoCreditos":
      botaoCreditos?.isPaused = false
      botaoCreditos?.run(self.clickButtonsSound)
      
      telaCreditos?.zPosition = 1
      setaVoltarFinal?.zPosition = 2
      telaFinal?.zPosition = 0
      telaEmBreve?.zPosition = 0
      botaoCreditos?.zPosition = 0
      GameScene.shared.hud.hideResetButton(isHide: true)
      HUD.shared.hideFundoBotaoViajar(isHide: true)
      botaoEmBreve?.zPosition = 0
      
    case "botaoEmBreve":
      botaoEmBreve?.isPaused = false
      botaoEmBreve?.run(self.clickButtonsSound)
      
      telaCreditos?.zPosition = 0
      setaVoltarFinal?.zPosition = 0
      telaFinal?.zPosition = 0
      telaEmBreve?.zPosition = 1
      botaoCreditos?.zPosition = 2
      GameScene.shared.hud.hideResetButton(isHide: false)
      HUD.shared.hideFundoBotaoViajar(isHide: true)
      botaoEmBreve?.zPosition = 0
      
    case "setaVoltarFinal":
      setaVoltarFinal?.isPaused = false
      setaVoltarFinal?.run(self.clickButtonsSound)
      
      telaCreditos?.zPosition = 0
      setaVoltarFinal?.zPosition = 0
      telaFinal?.zPosition = 1
      telaEmBreve?.zPosition = 0
      botaoCreditos?.zPosition = 2
      GameScene.shared.hud.hideResetButton(isHide: false)
      HUD.shared.hideFundoBotaoViajar(isHide: true)
      botaoEmBreve?.zPosition = 2
      
    default:
      return
      
    }
    
  }

}
