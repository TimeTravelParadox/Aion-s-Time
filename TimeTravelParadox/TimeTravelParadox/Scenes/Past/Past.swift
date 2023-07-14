import SpriteKit


class Past: SKNode{
    
    var clock: Clock?
     private let past = SKScene(fileNamed: "PastScene")
     private var pastBG: SKSpriteNode?
    
    var delegate: ZoomProtocol?

    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas

    let pastST = SKAction.repeatForever(SKAction.playSoundFileNamed("pastST.mp3", waitForCompletion: true))
    
    func spin() {
        pastBG?.run(SKAction.rotate(byAngle: -.pi/6, duration: 0.2))
    }
    


    init(delegate: ZoomProtocol){
        self.delegate = delegate
        self.clock = Clock(delegate: delegate)
        super.init()
        self.zPosition = 1
        if let past, let clock {
            pastBG = (past.childNode(withName: "pastBG") as? SKSpriteNode)
            pastBG?.removeFromParent()
                        
            self.isUserInteractionEnabled = true
            
            if let pastBG{
                self.addChild(pastBG)
            }
            self.isPaused = false
            self.addChild(clock)
            clock.delegate = delegate
            
            self.removeAction(forKey: "futureST")
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
        case "pastBG":
            delegate?.zoom(isZoom: false, node: pastBG, ratio: 0)
            print("plano de fundo")
        default:
            return
        }
    }
    
}

