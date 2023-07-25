import SpriteKit

class TypeMachine: SKNode{
    let past = SKScene(fileNamed: "PastScene")
    
    
    private var clock: SKSpriteNode?
    private var hourHand: SKSpriteNode?
    private var minuteHand: SKSpriteNode?
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas

    
    let clockOpening =  SKAction.animate(with: [SKTexture(imageNamed: "clock1"), SKTexture(imageNamed: "clock2"), SKTexture(imageNamed: "clock3"), SKTexture(imageNamed: "clock4"), SKTexture(imageNamed: "clock5")], timePerFrame: 0.4)
    
    func spin(hand: SKSpriteNode?, degree: CGFloat) {
        hand?.isPaused = false
        let rotationAngleInRadians = CGFloat.pi * -degree / 180.0 // Converter graus em radianos
        var rotationRatio = -round(hand!.zRotation * 180.0 / CGFloat.pi) // Retornar um valor de rotação em 360 graus
        rotationRatio += degree // Atualizar o valor de rotação
        
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
    
    override init(){
        super.init()
        self.zPosition = 1
        if let past {
            clock = (past.childNode(withName: "clock") as? SKSpriteNode)
            clock?.removeFromParent()
            hourHand = (past.childNode(withName: "hourHand") as? SKSpriteNode)
            hourHand?.removeFromParent()
            minuteHand = (past.childNode(withName: "minuteHand") as? SKSpriteNode)
            minuteHand?.removeFromParent()
                        
            self.isUserInteractionEnabled = true
        }
        if let clock, let hourHand, let minuteHand{
            self.addChild(clock)
            self.addChild(hourHand)
            self.addChild(minuteHand)
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
        case "clock":
            return
        case "hourHand":
            spin(hand: hourHand, degree: 30)
            if minuteRotate == 30  && hourRotate == 60{
                minuteRotate -= 30
                hourRotate -= 60
                clock?.run(clockOpening)
                scene?.run(SKAction.wait(forDuration: 0.6)){
                    self.minuteHand?.isHidden = true
                    self.hourHand?.isHidden = true
                }

            }
        case "minuteHand":
            spin(hand: minuteHand, degree: 15)
            if minuteRotate == 30  && hourRotate == 60{
                minuteRotate -= 30
                hourRotate -= 60
                clock?.run(clockOpening)
                scene?.run(SKAction.wait(forDuration: 0.6)){
                    self.minuteHand?.isHidden = true
                    self.hourHand?.isHidden = true
                }
            }
        default:
            return
        }
    }
}
