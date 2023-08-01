import SpriteKit

class QG: SKNode{
    let past = SKScene(fileNamed: "QGScene")

    var delegateHUD: ToggleTravel?
    
    var QGBG: SKSpriteNode?
    var shadowQG: SKSpriteNode?
    var textureQG: SKSpriteNode?
    var pipeQG: SKSpriteNode?
    var leftScreenQG: SKSpriteNode?
    var rightScreenQG: SKSpriteNode?
    var tv: SKSpriteNode?
    var display: SKSpriteNode?
    var botaoComecar: SKSpriteNode?

    var delegateDialogue: CallDialogue?
    var dialogueQG = false
    var dialogueStep = 0
    
    var step = 1
    
    let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
    
    lazy var startingTV = SKAction.animate(with: startingTVTextures, timePerFrame: 0.025)
    
    let startingTVTextures = [SKTexture(imageNamed: "display1"),SKTexture(imageNamed: "display2"),SKTexture(imageNamed: "display3"),SKTexture(imageNamed: "display4"),SKTexture(imageNamed: "display5"),SKTexture(imageNamed: "display6"),SKTexture(imageNamed: "display7"),SKTexture(imageNamed: "display8"),SKTexture(imageNamed: "display9"),SKTexture(imageNamed: "display10"),SKTexture(imageNamed: "display11"),SKTexture(imageNamed: "display12"),SKTexture(imageNamed: "display13"),SKTexture(imageNamed: "display14"),SKTexture(imageNamed: "display16"),SKTexture(imageNamed: "display17"),SKTexture(imageNamed: "display18"),SKTexture(imageNamed: "display19"),SKTexture(imageNamed: "display20")]
    
    let preparingMission = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "display29"),SKTexture(imageNamed: "display30"),SKTexture(imageNamed: "display31"),SKTexture(imageNamed: "display32")], timePerFrame: 0.3))
    
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
            botaoComecar = past.childNode(withName: "botaoComecar") as? SKSpriteNode
            botaoComecar?.removeFromParent()
            textureQG = past.childNode(withName: "textureQG") as? SKSpriteNode
            textureQG?.removeFromParent()
            pipeQG = past.childNode(withName: "pipeQG") as? SKSpriteNode
            pipeQG?.removeFromParent()
            leftScreenQG = past.childNode(withName: "leftScreenQG") as? SKSpriteNode
            leftScreenQG?.removeFromParent()
            rightScreenQG = past.childNode(withName: "rightScreenQG") as? SKSpriteNode
            rightScreenQG?.removeFromParent()
            
            self.isUserInteractionEnabled = true
        }
        if let QGBG, let botaoComecar, let tv, let display, let shadowQG, let textureQG, let pipeQG, let leftScreenQG, let rightScreenQG {
            self.addChild(QGBG)
            self.addChild(botaoComecar)
            self.addChild(tv)
            self.addChild(display)
            self.addChild(shadowQG)
            self.addChild(textureQG)
            self.addChild(pipeQG)
            self.addChild(leftScreenQG)
            self.addChild(rightScreenQG)
        }
        
        
        delegateHUD.desativarTravel()
        display?.isHidden = true
        
//        self.run(SKAction.wait(forDuration: 1)){
//            self.tv?.texture = SKTexture(imageNamed: "tv2")
//            self.run(SKAction.wait(forDuration: 1)){
//                self.tv?.texture = SKTexture(imageNamed: "tv")
//                self.addChild(self.botaoComecar!)
//            }
//        }
        self.run(SKAction.wait(forDuration: 1)) {
            self.display?.isHidden = false
            self.display?.isPaused = false
            self.display?.run(self.startingTV)
            self.run(SKAction.wait(forDuration: (Double(self.startingTVTextures.count) * 0.025) + 0.5)) {
                if UserDefaultsManager.shared.initializedQG == true {
                    self.step = 6
                    self.display?.removeAllActions()
                    self.display?.texture = SKTexture(imageNamed: "display28")
                    self.delegateHUD?.ativarTravel()
                } else {
                    self.run(SKAction.wait(forDuration: 1.5)){
                        self.display?.texture = SKTexture(imageNamed: "display22")
                    }
                }
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
                if dialogueStep == 0{
                    delegateDialogue?.dialogue(node: QGBG, texture: SKTexture(imageNamed: "dialogueQG01"), ratio: 1, isHidden: false)
                    dialogueQG = true
                    dialogueStep = 1
                }
                if dialogueStep != 3{
                    
                    self.display?.run(self.preparingMission)
                }

            default:
                return
            }
        default:
            break
        }
        
    }
    
}
