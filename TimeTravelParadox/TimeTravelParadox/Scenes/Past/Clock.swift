
import SpriteKit

var isPeca1Selected = false

class Clock: SKNode, RemoveProtocol{
    let past = SKScene(fileNamed: "PastScene")
    
    var delegate: ZoomProtocol?
    var delegateDialogue: CallDialogue?
    var inventoryItemDelegate: InventoryItemDelegate?
    
    var clock: SKSpriteNode?
    var hourHand: SKSpriteNode?
    var minuteHand: SKSpriteNode?
    var peca1: SKSpriteNode?
    
    var dialogueClock = true
    
    var canTapAgain: Bool = true // evitar que ele toque muito ra'pido no ponteiro e bugue
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    let clockTickingSFX = SKAction.playSoundFileNamed("ticking.mp3", waitForCompletion: false)
    
    let clockOpening =  SKAction.animate(with: [SKTexture(imageNamed: "clock1"), SKTexture(imageNamed: "clock2"), SKTexture(imageNamed: "clock3"), SKTexture(imageNamed: "clock4"), SKTexture(imageNamed: "clock5"), SKTexture(imageNamed: "clock6"), SKTexture(imageNamed: "clock7"), SKTexture(imageNamed: "clock8"), SKTexture(imageNamed: "clock9"), SKTexture(imageNamed: "clock10"), SKTexture(imageNamed: "clock11"), SKTexture(imageNamed: "clock12"), SKTexture(imageNamed: "clock13"), SKTexture(imageNamed: "clock14"), SKTexture(imageNamed: "clock15"), SKTexture(imageNamed: "clock16"), SKTexture(imageNamed: "clock17")], timePerFrame: 0.16)
    
    init(delegate: ZoomProtocol, delegateDialogue: CallDialogue){
        self.delegate = delegate
        self.delegateDialogue = delegateDialogue
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
        
        if UserDefaultsManager.shared.peca1Taken == true {
            openClock(animating: false)
            HUD.addOnInv(node: peca1)
            peca1?.zPosition = 15
            peca1?.size = CGSize(width: 25, height: 25)
            CasesPositions(node: peca1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removePeca() {
        peca1?.removeFromParent()
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        if let node = atPoint(location) as? SKSpriteNode, node == peca1 {
            // O toque ocorreu no nó específico
            print("Toque no nó específico")
        } else {
            // O toque ocorreu fora do nó específico
            isPeca1Selected = false
            print("a peca 1\(isPeca1Selected)")
        }
        
        
        switch tapped.name {
        case "peca1":
            if !UserDefaultsManager.shared.peca1Taken{
                HUD.addOnInv(node: peca1)
                UserDefaultsManager.shared.peca1Taken = true
            }else {
                if let itemSelecionado = HUD.shared.itemSelecionado {
                    HUD.shared.removeBorder(from: itemSelecionado)
                }
                HUD.shared.addBorder(to: peca1!)
                HUD.shared.itemSelecionado = peca1
                HUD.shared.isSelected = true
                HUD.shared.peca1 = peca1
                isPeca1Selected = true
            }
            
        case "clock":
            delegate?.zoom(isZoom: true, node: clock, ratio: 0.18)
        case "hourHand":
            if delegate?.didZoom == true && canTapAgain {
                canTapAgain = false
                hourHand?.run(clockTickingSFX)
                spin(hand: hourHand, degree: 30)
                if minuteRotate == 60 && hourRotate == 150 {
                    openClock(animating: true)
                }
                self.run(SKAction.wait(forDuration: 0.2)) {
                    self.canTapAgain = true
                }
                if dialogueClock && minuteRotate == 300 && hourRotate == 30{
                    delegateDialogue?.dialogue(node: clock, texture: SKTexture(imageNamed: "dialogueClock"), ratio: 0.18, isHidden: false)
                    dialogueClock = false
                }
            } else {
                delegate?.zoom(isZoom: true, node: clock, ratio: 0.18)
            }
        case "minuteHand":
            if delegate?.didZoom == true && canTapAgain {
                canTapAgain = false
                minuteHand?.run(clockTickingSFX)
                spin(hand: minuteHand, degree: 30)
                if minuteRotate == 60 && hourRotate == 150 {
                    openClock(animating: true)
                }
                self.run(SKAction.wait(forDuration: 0.2)) {
                    self.canTapAgain = true
                }
                if dialogueClock && minuteRotate == 300 && hourRotate == 30{
                    delegateDialogue?.dialogue(node: clock, texture: SKTexture(imageNamed: "dialogueClock"), ratio: 0.18, isHidden: false)
                    dialogueClock = false
                }
            } else {
                delegate?.zoom(isZoom: true, node: clock, ratio: 0.18)
            }
        default:
            break
        }
        
        inventoryItemDelegate?.clearItemDetail()
    }
    
    func openClock(animating: Bool) {
        clock?.isPaused = false
        minuteHand?.isHidden = true
        hourHand?.isHidden = true
        
        if animating {
            clock?.run(clockOpening)
            clock?.run(clockOpeningSFX)
            
            guard let peca1 = peca1 else { return }
            
            let waitAction = SKAction.wait(forDuration: 2.5)
            clock?.run(waitAction) {
                peca1.isHidden = false
            }
        } else {
            clock?.texture = SKTexture(imageNamed: "clock17")
            peca1?.isHidden = false
        }
    }
}
