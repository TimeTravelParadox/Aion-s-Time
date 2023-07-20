import SpriteKit

class Clock: SKNode{
    let past = SKScene(fileNamed: "PastScene")
    
     var delegate: ZoomProtocol?

    var peca1Taken = false
    
    private var clock: SKSpriteNode?
    private var hourHand: SKSpriteNode?
    private var minuteHand: SKSpriteNode?
    private var peca1: SKSpriteNode?
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas

    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    let clockTickingSFX = SKAction.playSoundFileNamed("ticking.mp3", waitForCompletion: false)


    let clockOpening =  SKAction.animate(with: [SKTexture(imageNamed: "clock1"), SKTexture(imageNamed: "clock2"), SKTexture(imageNamed: "clock3"), SKTexture(imageNamed: "clock4"), SKTexture(imageNamed: "clock5"), SKTexture(imageNamed: "clock6"), SKTexture(imageNamed: "clock7"), SKTexture(imageNamed: "clock8"), SKTexture(imageNamed: "clock9"), SKTexture(imageNamed: "clock10"), SKTexture(imageNamed: "clock11"), SKTexture(imageNamed: "clock12")], timePerFrame: 0.2)
    
    func spin(hand: SKSpriteNode?, degree: CGFloat) {
        hand?.isPaused = false
        let rotationAngleInRadians = CGFloat.pi * -degree / 180.0 // Converter graus em radianos
        var rotationRatio = -round(hand!.zRotation * 180.0 / CGFloat.pi) + 30// Retornar um valor de rotação em 360 graus
        
        if rotationRatio >= 360 { // Verificar se ultrapassou 360 graus
            rotationRatio -= 360
        }
        
        let rotationAction = SKAction.rotate(byAngle: rotationAngleInRadians, duration: 0.2)
        hand?.run(rotationAction)
        
        if hand == minuteHand {
            minuteRotate = rotationRatio
        } else if hand == hourHand {
            hourRotate = rotationRatio
        }
    }
    
    init(delegate: ZoomProtocol){
        self.delegate = delegate
        super.init()
        self.zPosition = 1
        if let past {
            clock = (past.childNode(withName: "clock") as? SKSpriteNode)
            clock?.removeFromParent()
            hourHand = (past.childNode(withName: "hourHand") as? SKSpriteNode)
            hourHand?.removeFromParent()
            minuteHand = (past.childNode(withName: "minuteHand") as? SKSpriteNode)
            minuteHand?.removeFromParent()
            peca1 = (past.childNode(withName: "peca1") as? SKSpriteNode)
            peca1?.removeFromParent()
            self.isUserInteractionEnabled = true
        }
        if let clock, let hourHand, let minuteHand, let peca1{
            self.addChild(clock)
            self.addChild(hourHand)
            self.addChild(minuteHand)
            self.addChild(peca1)
        }
        peca1?.isHidden = true
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
        case "peca1":
                HUD.addOnInv(node: peca1, inventario: &inventario)
        case "clock":
            delegate?.zoom(isZoom: true, node: clock, ratio: 0.26)
        case "hourHand":
            if delegate?.didZoom == true {
                hourHand?.run(clockTickingSFX)
                spin(hand: hourHand, degree: 30)
                if minuteRotate == 60  && hourRotate == 330{
                    clock?.isPaused = false
                    clock?.run(clockOpening)
                    self.minuteHand?.isHidden = true
                    self.hourHand?.isHidden = true
                    clock?.run(clockOpeningSFX)
                    peca1?.isHidden = false
                }
            }else{
                delegate?.zoom(isZoom: true, node: clock, ratio: 0.26)
            }
        case "minuteHand":
            if delegate?.didZoom == true{
                minuteHand?.run(clockTickingSFX)
                spin(hand: minuteHand, degree: 30)
                if minuteRotate == 60  && hourRotate == 330{
                    clock?.isPaused = false
                    clock?.run(clockOpening)
                    self.minuteHand?.isHidden = true
                    self.hourHand?.isHidden = true
                    clock?.run(clockOpeningSFX)
                    peca1?.isHidden = false
                }
            }else{
                //zoom aqui
                delegate?.zoom(isZoom: true, node: clock, ratio: 0.26)
            }
        default:
            return
        }
    }
}
