import SpriteKit

class QG: SKNode{
  let past = SKScene(fileNamed: "QGScene")
  
    private let hud = HUD()
    
  var QGBG: SKSpriteNode?
    var botaoMissao: SKSpriteNode?
    var botaoComecar: SKSpriteNode?
    var texto: SKLabelNode?
  
  let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
  
    
  override init(){
    super.init()
    if let past {
      QGBG = (past.childNode(withName: "QGBG") as? SKSpriteNode)
      QGBG?.removeFromParent()
        botaoMissao = past.childNode(withName: "botaoMissao") as? SKSpriteNode
        botaoMissao?.removeFromParent()
        botaoComecar = past.childNode(withName: "botaoComecar") as? SKSpriteNode
        botaoComecar?.removeFromParent()
        texto = past.childNode(withName: "texto1") as? SKLabelNode
        texto?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    if let QGBG, let botaoMissao, let botaoComecar, let texto{
      self.addChild(QGBG)
        self.addChild(botaoMissao)
        self.addChild(botaoComecar)
        self.addChild(texto)
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
        
        
        switch tapped.name {
        case "botaoMissao":
            botaoMissao?.isHidden = true
            botaoComecar?.isHidden = false
            texto?.isHidden = false
        case "botaoComecar":
            hud.hideTravelButton(isHide: false)
//            HUD.shared.hideTravelButton(isHide: false)
        default:
            break
        }
        
    }
  
}
