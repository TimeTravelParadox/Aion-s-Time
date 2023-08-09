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
    var thanksLabel: SKLabelNode?
    var specialThanksLabel: SKLabelNode?
    var creditLabel: SKLabelNode?
    var creditButtonLabel: SKLabelNode?
    var creditButtonNode: SKSpriteNode?
    var missionLabel: SKLabelNode?
  
  // Som que será reproduzido ao clicar em botões.
  let clickButtonsSound = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
    func hideCreditLabels(hide: Bool){
        thanksLabel?.isHidden = hide
        specialThanksLabel?.isHidden = hide
        creditLabel?.isHidden = hide
        if hide{
            thanksLabel?.zPosition = 0
            specialThanksLabel?.zPosition = 0
            creditLabel?.zPosition = 0
        }else{
            thanksLabel?.zPosition = 2
            specialThanksLabel?.zPosition = 2
            creditLabel?.zPosition = 2

        }
    }
    
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
        
      specialThanksLabel = creditos.childNode(withName: "specialThanksLabel") as? SKLabelNode
      specialThanksLabel?.removeFromParent()
      thanksLabel = creditos.childNode(withName: "thanksLabel") as? SKLabelNode
      thanksLabel?.removeFromParent()
      creditLabel = creditos.childNode(withName: "creditLabel") as? SKLabelNode
      creditLabel?.removeFromParent()
      creditButtonLabel = creditos.childNode(withName: "creditButtonLabel") as? SKLabelNode
      creditButtonLabel?.removeFromParent()
      missionLabel = creditos.childNode(withName: "missionLabel") as? SKLabelNode
      missionLabel?.removeFromParent()
      creditButtonNode = creditos.childNode(withName: "creditButtonNode") as? SKSpriteNode
      creditButtonNode?.removeFromParent()
      
      self.isUserInteractionEnabled = true

    }
    
    // Adiciona os nós à cena principal da classe
    if let telaFinal, let telaCreditos, let telaEmBreve, let botaoEmBreve, let setaVoltarFinal, let thanksLabel, let creditLabel, let specialThanksLabel, let creditButtonLabel, let missionLabel, let creditButtonNode {
      self.addChild(telaFinal)
      self.addChild(telaCreditos)
      self.addChild(telaEmBreve)
//      self.addChild(botaoCreditos)
      self.addChild(botaoEmBreve)
      self.addChild(setaVoltarFinal)
      self.addChild(thanksLabel)
      self.addChild(creditLabel)
      self.addChild(specialThanksLabel)
        self.addChild(creditButtonLabel)
        self.addChild(missionLabel)
        self.addChild(creditButtonNode)
    }
      creditButtonNode?.zPosition = 2
      creditButtonLabel?.zPosition = 3
      missionLabel?.zPosition = 2
      
      hideCreditLabels(hide: true)
      creditLabel?.fontName = "FiraCode-SemiBold"
      thanksLabel?.fontName = "FiraCode-SemiBold"
      specialThanksLabel?.fontName = "FiraCode-SemiBold"
      missionLabel?.fontName = "FiraCode-SemiBold"
      creditButtonLabel?.fontName = "FiraCode-SemiBold"
      specialThanksLabel?.text = NSLocalizedString("specialThanks", comment: "texto com o agradecimentos")
      thanksLabel?.text = NSLocalizedString("thanks", comment: "")
      creditLabel?.text = NSLocalizedString("credit", comment: "")
      specialThanksLabel?.preferredMaxLayoutWidth = 700
      specialThanksLabel?.numberOfLines = 10
      specialThanksLabel?.horizontalAlignmentMode = .center
      creditButtonLabel?.text = NSLocalizedString("credit", comment: "")
      missionLabel?.text = NSLocalizedString("mission", comment: "")
      missionLabel?.preferredMaxLayoutWidth = 600
      missionLabel?.numberOfLines = 2
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
    case "creditButtonNode", "creditButtonLabel":
      botaoCreditos?.isPaused = false
        creditButtonLabel?.isPaused = false
      botaoCreditos?.run(self.clickButtonsSound)
      creditButtonLabel?.run(self.clickButtonsSound)
      
      telaCreditos?.zPosition = 1
        hideCreditLabels(hide: false)
      setaVoltarFinal?.zPosition = 2
      telaFinal?.zPosition = 0
      telaEmBreve?.zPosition = 0
      botaoCreditos?.zPosition = 0
        creditButtonLabel?.zPosition = 0
        missionLabel?.zPosition = 0
        creditButtonNode?.zPosition = 0


      GameScene.shared.hud.hideResetButton(isHide: true)
      HUD.shared.hideFundoBotaoViajar(isHide: true)
      botaoEmBreve?.zPosition = 0
      
    case "botaoEmBreve":
        missionLabel?.text = NSLocalizedString("emBreve", comment: "")
      botaoEmBreve?.isPaused = false
      botaoEmBreve?.run(self.clickButtonsSound)
        missionLabel?.zPosition = 2
        missionLabel?.fontSize = 30
      
        hideCreditLabels(hide: true)
      telaCreditos?.zPosition = 0
      setaVoltarFinal?.zPosition = 2
      telaFinal?.zPosition = 0
      telaEmBreve?.zPosition = 1
        creditButtonNode?.zPosition = 2
        creditButtonLabel?.zPosition = 3


      botaoCreditos?.zPosition = 2
      GameScene.shared.hud.hideResetButton(isHide: false)
      HUD.shared.hideFundoBotaoViajar(isHide: true)
      botaoEmBreve?.zPosition = 0
      
    case "setaVoltarFinal":
        missionLabel?.fontSize = 38
        missionLabel?.text = NSLocalizedString("mission", comment: "")


      setaVoltarFinal?.isPaused = false
      setaVoltarFinal?.run(self.clickButtonsSound)
      
        hideCreditLabels(hide: true)

      telaCreditos?.zPosition = 0
      setaVoltarFinal?.zPosition = 0
      telaFinal?.zPosition = 1
        missionLabel?.zPosition = 2
        creditButtonLabel?.zPosition = 3
        creditButtonNode?.zPosition = 2
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
