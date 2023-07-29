import SpriteKit

class QG: SKNode{
    let past = SKScene(fileNamed: "QGScene")
    
    var hud = HUD()
    
    var delegateHUD: ToggleTravel?
    
    var QGBG: SKSpriteNode?
    var tv: SKSpriteNode?
    var botaoMissao: SKSpriteNode?
    var display: SKSpriteNode?
    var botaoComecar: SKSpriteNode?
    
    var step = 1
    
    let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
    
    let startingTV = SKAction.animate(with: [SKTexture(imageNamed: "display1"),SKTexture(imageNamed: "display2"),SKTexture(imageNamed: "display3"),SKTexture(imageNamed: "display4"),SKTexture(imageNamed: "display5"),SKTexture(imageNamed: "display6"),SKTexture(imageNamed: "display7"),SKTexture(imageNamed: "display8"),SKTexture(imageNamed: "display9"),SKTexture(imageNamed: "display10"),SKTexture(imageNamed: "display11"),SKTexture(imageNamed: "display12"),SKTexture(imageNamed: "display13"),SKTexture(imageNamed: "display14"),SKTexture(imageNamed: "display16"),SKTexture(imageNamed: "display17"),SKTexture(imageNamed: "display18"),SKTexture(imageNamed: "display19"),SKTexture(imageNamed: "display20")], timePerFrame: 0.025)
    
    let preparingMission = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "display29"),SKTexture(imageNamed: "display30"),SKTexture(imageNamed: "display31"),SKTexture(imageNamed: "display32")], timePerFrame: 0.5))
    
    init(hudScene: HUD, delegateHUD: ToggleTravel){
        self.delegateHUD = delegateHUD
        self.hud = hudScene
        super.init()
        if let past {
            QGBG = (past.childNode(withName: "QGBG") as? SKSpriteNode)
            QGBG?.removeFromParent()
            tv = (past.childNode(withName: "tv") as? SKSpriteNode)
            tv?.removeFromParent()
            display = (past.childNode(withName: "display") as? SKSpriteNode)
            display?.removeFromParent()
            botaoMissao = past.childNode(withName: "botaoMissao") as? SKSpriteNode
            botaoMissao?.removeFromParent()
            botaoComecar = past.childNode(withName: "botaoComecar") as? SKSpriteNode
            botaoComecar?.removeFromParent()
            
            self.isUserInteractionEnabled = true
        }
        if let QGBG, let botaoMissao, let botaoComecar, let tv, let display{
            self.addChild(QGBG)
            self.addChild(botaoMissao)
            self.addChild(botaoComecar)
            self.addChild(tv)
            self.addChild(display)
        }
        
        
        delegateHUD.desativarTravel()
        display?.isHidden = true
        self.run(SKAction.wait(forDuration: 1)){
            self.display?.isHidden = false
            self.display?.isPaused = false
            self.display?.run(self.startingTV)
            self.run(SKAction.wait(forDuration: 1.5)){
                self.display?.texture = SKTexture(imageNamed: "display22")
            }
        }
        
//        self.run(SKAction.wait(forDuration: 1)){
//            self.tv?.texture = SKTexture(imageNamed: "tv2")
//            self.run(SKAction.wait(forDuration: 1)){
//                self.tv?.texture = SKTexture(imageNamed: "tv")
//                self.addChild(self.botaoComecar!)
//            }
//        }
        
        if UserDefaultsManager.shared.initializedQG == true {
            step = 5
            self.display?.run(self.preparingMission)
            run(SKAction.wait(forDuration: 5)){
                self.display?.removeAllActions()
                self.display?.texture = SKTexture(imageNamed: "display28")
                self.delegateHUD?.ativarTravel()
            }
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
        case "display":
            print("display")
            print(display?.texture as Any)
            
            switch step{
            case 1:
                display?.texture = SKTexture(imageNamed: "display23")
                step = 2

            case 2:
                display?.texture = SKTexture(imageNamed: "display24")
                step = 3

            case 3:
                display?.texture = SKTexture(imageNamed: "display25")
                step = 4

            case 4:
                display?.texture = SKTexture(imageNamed: "display26")
                step = 5
            case 5:
                self.display?.run(self.preparingMission)
                run(SKAction.wait(forDuration: 5)){
                    self.display?.removeAllActions()
                    self.display?.texture = SKTexture(imageNamed: "display27")
                    self.delegateHUD?.ativarTravel()
                    UserDefaultsManager.shared.initializedQG = true
                }
            default:
                return
            }
        default:
            break
        }
        
    }
    
}
