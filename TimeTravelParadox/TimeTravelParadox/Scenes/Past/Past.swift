import SpriteKit


class Past: SKNode{
    let clock = Clock()
     private let past = SKScene(fileNamed: "PastScene")
     private var pastBG: SKSpriteNode?

    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas

    let pastST = SKAction.repeatForever(SKAction.playSoundFileNamed("pastST.mp3", waitForCompletion: true))
    var pastStatus = false
    
    func spin() {
        pastBG?.run(SKAction.rotate(byAngle: -.pi/6, duration: 0.2))
    }

    override init(){
        super.init()
        self.zPosition = 1
        if let past {
            pastBG = (past.childNode(withName: "pastBG") as? SKSpriteNode)
            pastBG?.removeFromParent()
                        
            self.isUserInteractionEnabled = true
        }
        if let pastBG{
            self.addChild(pastBG)
        }
        self.isPaused = false
        self.addChild(clock)
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
        case "pastBG":
            print("plano de fundo")
        default:
            return
        }
    }
    
}

