import SpriteKit

class QG: SKNode{
    let past = SKScene(fileNamed: "QGScene")
    
    var hud = HUD()
    
    var delegateHUD: ToggleTravel?
    
    var QGBG: SKSpriteNode?
    var tv: SKSpriteNode?
    var botaoMissao: SKSpriteNode?
    var botaoComecar: SKSpriteNode?
    var texto1: SKLabelNode?
    var texto2: SKLabelNode?
    var texto3: SKLabelNode?
    var texto4: SKLabelNode?
    var texto5: SKLabelNode?
    var texto6: SKLabelNode?
    
    let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
    
    let startingTV = SKAction.animate(with: [SKTexture(imageNamed: "tv1"),SKTexture(imageNamed: "tv2"),SKTexture(imageNamed: "tv3"),SKTexture(imageNamed: "tv4"),SKTexture(imageNamed: "tv5"),SKTexture(imageNamed: "tv6"),SKTexture(imageNamed: "tv7"),SKTexture(imageNamed: "tv8"),SKTexture(imageNamed: "tv9"),SKTexture(imageNamed: "tv10")], timePerFrame: 0.4)
    
    init(hudScene: HUD, delegateHUD: ToggleTravel){
        self.delegateHUD = delegateHUD
        self.hud = hudScene
        super.init()
        if let past {
            QGBG = (past.childNode(withName: "QGBG") as? SKSpriteNode)
            QGBG?.removeFromParent()
            tv = (past.childNode(withName: "tv") as? SKSpriteNode)
            tv?.removeFromParent()
            botaoMissao = past.childNode(withName: "botaoMissao") as? SKSpriteNode
            botaoMissao?.removeFromParent()
            botaoComecar = past.childNode(withName: "botaoComecar") as? SKSpriteNode
            botaoComecar?.removeFromParent()
            texto1 = past.childNode(withName: "texto1") as? SKLabelNode
            texto1?.removeFromParent()
            texto2 = past.childNode(withName: "texto2") as? SKLabelNode
            texto2?.removeFromParent()
            texto3 = past.childNode(withName: "texto3") as? SKLabelNode
            texto3?.removeFromParent()
            texto4 = past.childNode(withName: "texto4") as? SKLabelNode
            texto4?.removeFromParent()
            texto5 = past.childNode(withName: "texto5") as? SKLabelNode
            texto5?.removeFromParent()
            texto6 = past.childNode(withName: "texto6") as? SKLabelNode
            texto6?.removeFromParent()
            
            self.isUserInteractionEnabled = true
        }
        if let QGBG, let botaoMissao, let botaoComecar, let texto1, let texto2, let texto3, let texto4, let texto5, let texto6, let tv{
            self.addChild(QGBG)
            self.addChild(botaoMissao)
            self.addChild(botaoComecar)
            self.addChild(texto1)
            self.addChild(texto2)
            self.addChild(texto3)
            self.addChild(texto4)
            self.addChild(texto5)
            self.addChild(texto6)
            self.addChild(tv)
        }
        delegateHUD.desativarTravel()
//        tv?.run(startingTV)
        tv?.texture = SKTexture(imageNamed: "tv1")
        
//        self.run(SKAction.wait(forDuration: 1)){
//            self.tv?.texture = SKTexture(imageNamed: "tv2")
//            self.run(SKAction.wait(forDuration: 1)){
//                self.tv?.texture = SKTexture(imageNamed: "tv")
//                self.addChild(self.botaoComecar!)
//            }
//        }
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
            texto1?.isHidden = false
            texto2?.isHidden = false
            texto3?.isHidden = false
            texto4?.isHidden = false
            texto5?.isHidden = false
            texto6?.isHidden = false
        case "botaoComecar":
            print("botao cmecár")
//            hud.hideTravelButton(isHide: false)
            delegateHUD?.ativarTravel()
            //            HUD.shared.hideTravelButton(isHide: false)
        default:
            break
        }
        
    }
    
}
