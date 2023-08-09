import SpriteKit

/// Classe que implementa o qg e seus componentes
class QG: SKNode{
  let past = SKScene(fileNamed: "QGScene")
  
  var delegateHUD: ToggleTravel?
  
  var QGBG: SKSpriteNode? // background do QG
  var shadowQG: SKSpriteNode?
  var textureQG: SKSpriteNode?
  var pipeQG: SKSpriteNode?
  var leftScreenQG: SKSpriteNode?
  var rightScreenQG: SKSpriteNode?
  var tv: SKSpriteNode?
  var display: SKSpriteNode?
  
  var delegateDialogue: CallDialogue?
  var dialogueQG = false
  var dialogueStep = 0
  
  var missao01: SKLabelNode?
  var textoMissaoNaTV: SKLabelNode?
  var novaMissao: SKLabelNode?
  var analiseLinhaTemporal: SKLabelNode?
  
  var step = 1
  
  // som de fundo do QG
  let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
  
  lazy var startingTV = SKAction.animate(with: startingTVTextures, timePerFrame: 0.025)
  
  // texturas do display da tv ligando
  let startingTVTextures = [SKTexture(imageNamed: "display1"),SKTexture(imageNamed: "display2"),SKTexture(imageNamed: "display3"),SKTexture(imageNamed: "display4"),SKTexture(imageNamed: "display5"),SKTexture(imageNamed: "display6"),SKTexture(imageNamed: "display7"),SKTexture(imageNamed: "display8"),SKTexture(imageNamed: "display9"),SKTexture(imageNamed: "display10"),SKTexture(imageNamed: "display11"),SKTexture(imageNamed: "display12"),SKTexture(imageNamed: "display13"),SKTexture(imageNamed: "display14"),SKTexture(imageNamed: "display16"),SKTexture(imageNamed: "display17"),SKTexture(imageNamed: "display18"),SKTexture(imageNamed: "display19"),SKTexture(imageNamed: "display20")]
  
  let preparingMission = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "display29"),SKTexture(imageNamed: "display30"),SKTexture(imageNamed: "display31"),SKTexture(imageNamed: "display32")], timePerFrame: 0.3))
  
  // inicializador da classe QG
  init(delegateHUD: ToggleTravel, delegateDialogue: CallDialogue){
    self.delegateHUD = delegateHUD
    self.delegateDialogue = delegateDialogue
    super.init()
    if let past {
      QGBG = (past.childNode(withName: "QGBG") as? SKSpriteNode)
      QGBG?.removeFromParent()
      tv = (past.childNode(withName: "tv") as? SKSpriteNode)
      tv?.removeFromParent()
      display = (past.childNode(withName: "display") as? SKSpriteNode)
      display?.removeFromParent()
      shadowQG = (past.childNode(withName: "shadowQG") as? SKSpriteNode)
      shadowQG?.removeFromParent()
      textureQG = past.childNode(withName: "textureQG") as? SKSpriteNode
      textureQG?.removeFromParent()
      pipeQG = past.childNode(withName: "pipeQG") as? SKSpriteNode
      pipeQG?.removeFromParent()
      leftScreenQG = past.childNode(withName: "leftScreenQG") as? SKSpriteNode
      leftScreenQG?.removeFromParent()
      rightScreenQG = past.childNode(withName: "rightScreenQG") as? SKSpriteNode
      rightScreenQG?.removeFromParent()
      
      missao01 = past.childNode(withName: "missao001") as? SKLabelNode
      missao01?.removeFromParent()
      textoMissaoNaTV = past.childNode(withName: "textoMissaoNaTV") as? SKLabelNode
      textoMissaoNaTV?.removeFromParent()
      novaMissao = past.childNode(withName: "novaMissao") as? SKLabelNode
      novaMissao?.removeFromParent()
      analiseLinhaTemporal = past.childNode(withName: "analiseLinhaTemporal") as? SKLabelNode
      analiseLinhaTemporal?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    
    if let QGBG, let tv, let display, let shadowQG, let textureQG, let pipeQG, let leftScreenQG, let rightScreenQG, let missao01, let textoMissaoNaTV, let novaMissao, let analiseLinhaTemporal {
      self.addChild(QGBG)
      self.addChild(tv)
      self.addChild(display)
      self.addChild(shadowQG)
      self.addChild(textureQG)
      self.addChild(pipeQG)
      self.addChild(leftScreenQG)
      self.addChild(rightScreenQG)
      self.addChild(missao01)
      self.addChild(textoMissaoNaTV)
      self.addChild(novaMissao)
      self.addChild(analiseLinhaTemporal)
    }
    
    
    delegateHUD.desativarTravel()
    display?.isHidden = true
    
    missao01?.isHidden = true
    novaMissao?.isHidden = true
    textoMissaoNaTV?.isHidden = true
    
    analiseLinhaTemporal?.isHidden = false
    analiseLinhaTemporal?.text = NSLocalizedString("analiseLinhaTemporal", comment: "texto da tela da direita do qg")
    analiseLinhaTemporal?.fontColor = .green
    analiseLinhaTemporal?.fontSize = 6
    analiseLinhaTemporal?.fontName = "FiraCode-SemiBold"
    
    self.display?.isUserInteractionEnabled = false
    
    // roda a animacao da tela de displays
    self.run(SKAction.wait(forDuration: 1)) {
      self.display?.isHidden = false
      self.display?.isPaused = false
      self.display?.run(self.startingTV)
      self.run(SKAction.wait(forDuration: (Double(self.startingTVTextures.count) * 0.025) + 0.5)) {
        if UserDefaultsManager.shared.initializedQG == true {
          self.step = 6
          self.display?.removeAllActions()
          self.display?.texture = SKTexture(imageNamed: "display21")
          
          self.novaMissao?.isHidden = false
          self.novaMissao?.text = NSLocalizedString("emAndamento", comment: "tela missao em andamento")
          self.novaMissao?.position = CGPoint(x: -28, y: 13)
          self.novaMissao?.fontColor = .green
          self.novaMissao?.fontSize = 15
          self.novaMissao?.fontName = "FiraCode-SemiBold"
          
          self.delegateHUD?.ativarTravel()
        } else {
          self.run(SKAction.wait(forDuration: 1.5)){
            self.display?.texture = SKTexture(imageNamed: "display22")
            self.novaMissao?.isHidden = false
            self.novaMissao?.position = CGPoint(x: -28, y: 14)
            self.novaMissao?.text = NSLocalizedString("novaMissao", comment: "tela de nova missao")
            self.novaMissao?.fontColor = .green
            self.novaMissao?.fontSize = 13
            self.novaMissao?.fontName = "FiraCode-SemiBold"
          }
        }
      }
    }
    display?.isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func textoMissaoNaTVCaracteristicas() {
    textoMissaoNaTV?.numberOfLines = 5
    textoMissaoNaTV?.preferredMaxLayoutWidth = 250
    textoMissaoNaTV?.lineBreakMode = .byWordWrapping
    textoMissaoNaTV?.fontColor = .green
    textoMissaoNaTV?.fontSize = 13
    textoMissaoNaTV?.fontName = "FiraCode-SemiBold"
  }
  
  func missao01Caracteristicas() {
    missao01?.text = NSLocalizedString("missao01", comment: "texto do topo da tv do qg")
    missao01?.fontColor = .green
    missao01?.fontSize = 12
    missao01?.fontName = "FiraCode-SemiBold"
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
    
    // switch case que define a animacao de abertura da tv na tela inicial do qg
    switch tapped.name {
    case "display", "textoMissaoNaTV", "novaMissao":
      print("display")
      print(display?.texture as Any)
      
      switch step{
      case 1:
        display?.texture = SKTexture(imageNamed: "display21")
        
        missao01Caracteristicas()
        missao01?.isHidden = false
        
        textoMissaoNaTV?.text = NSLocalizedString("texto1", comment: "primeiro texto")
        textoMissaoNaTV?.isHidden = false
        textoMissaoNaTVCaracteristicas()
        
        novaMissao?.isHidden = true
        
        step = 2
        
      case 2:
        display?.texture = SKTexture(imageNamed: "display21")
        
        missao01Caracteristicas()
        missao01?.isHidden = false
        
        textoMissaoNaTV?.text = NSLocalizedString("texto2", comment: "segundo texto")
        textoMissaoNaTV?.isHidden = false
        textoMissaoNaTVCaracteristicas()
        
        novaMissao?.isHidden = true
        
        step = 3
        
      case 3:
        display?.texture = SKTexture(imageNamed: "display21")
        
        missao01Caracteristicas()
        missao01?.isHidden = false
        
        textoMissaoNaTV?.text = NSLocalizedString("texto3", comment: "terceiro texto")
        textoMissaoNaTV?.isHidden = false
        textoMissaoNaTVCaracteristicas()
        
        novaMissao?.isHidden = true
        
        step = 4
        
      case 4:
        display?.texture = SKTexture(imageNamed: "display26")
        
        novaMissao?.text = NSLocalizedString("iniciarMissao", comment: "botao de iniciar missao")
        novaMissao?.position = CGPoint(x: -28, y: 10)
        novaMissao?.fontColor = .black
        novaMissao?.fontSize = 15
        novaMissao?.fontName = "FiraCode-SemiBold"
        novaMissao?.isHidden = false
        
        textoMissaoNaTV?.isHidden = true
        missao01?.isHidden = false
        
        step = 5
        
      case 5:
        if dialogueStep == 0{
          delegateDialogue?.dialogue(node: QGBG, text: "dialogueQG01", ratio: 1, isHidden: false)
          dialogueQG = true
          dialogueStep = 1
        }
        if dialogueStep != 3{
          
          display?.texture = SKTexture(imageNamed: "display21")
          
          novaMissao?.text = NSLocalizedString("preparando", comment: "tela de preparando viagem")
          novaMissao?.fontColor = .green
          novaMissao?.fontSize = 15
          novaMissao?.fontName = "FiraCode-SemiBold"
          
//          self.display?.run(self.run(SKAction.wait(forDuration: 0.5)){
//            self.display?.texture = SKTexture(imageNamed: "display21")
//            self.novaMissao?.text = NSLocalizedString("preparando1", comment: "tela de preparando viagem com um pontinho")
//          }
//                            self.run(SKAction.wait(forDuration: 0.5)){
//            self.display?.texture = SKTexture(imageNamed: "display21")
//            self.novaMissao?.text = NSLocalizedString("preparando2", comment: "tela de preparando viagem com dois pontinhos")
//          }
//                            self.run(SKAction.wait(forDuration: 0.5)){
//            self.display?.texture = SKTexture(imageNamed: "display21")
//            self.novaMissao?.text = NSLocalizedString("preparando3", comment: "tela de preparando viagem com tres pontinhos")
//          }
//          )
          
        }
        
      default:
        return
      }
    default:
      break
    }
    
  }
  
}
