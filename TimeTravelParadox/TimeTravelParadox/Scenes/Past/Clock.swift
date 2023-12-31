
import SpriteKit

var isPeca1Selected = false // variável global para saber se a peça 1 foi pega

/// Classe representando um objeto "Relógio" na cena do jogo.

class Clock: SKNode, RemoveProtocol{
    // MARK: - Properties
    /// instancia da cena "PastScene"
    let past = SKScene(fileNamed: "PastScene")
    
    // Delegates
    var delegate: ZoomProtocol?
    var delegateDialogue: CallDialogue?
    var inventoryItemDelegate: InventoryItemDelegate?
    
    //Nodes
    var clock: SKSpriteNode?
    var hourHand: SKSpriteNode?
    var minuteHand: SKSpriteNode?
    var peca1: SKSpriteNode?
    
    // Variáveis estados
    var dialogueClock = true
    var canTapAgain: Bool = true // evitar que ele toque muito ra'pido no ponteiro e bugue
    
    //Grau de rotação dos ponteiros de minuto e hora
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    // Arquivos de som
    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    let clockTickingSFX = SKAction.playSoundFileNamed("ticking.mp3", waitForCompletion: false)
    
    // Animação
    let clockOpening =  SKAction.animate(with: [SKTexture(imageNamed: "clock1"), SKTexture(imageNamed: "clock2"), SKTexture(imageNamed: "clock3"), SKTexture(imageNamed: "clock4"), SKTexture(imageNamed: "clock5"), SKTexture(imageNamed: "clock6"), SKTexture(imageNamed: "clock7"), SKTexture(imageNamed: "clock8"), SKTexture(imageNamed: "clock9"), SKTexture(imageNamed: "clock10"), SKTexture(imageNamed: "clock11"), SKTexture(imageNamed: "clock12"), SKTexture(imageNamed: "clock13"), SKTexture(imageNamed: "clock14"), SKTexture(imageNamed: "clock15"), SKTexture(imageNamed: "clock16"), SKTexture(imageNamed: "clock17")], timePerFrame: 0.16)
    
    // MARK: - Initialization
    
    /// Inicializador da classe.
    /// - Parameters:
    ///   - delegate: O delegado responsável por tratar o zoom do relógio.
    ///   - delegateDialogue: O delegado responsável por exibir diálogos relacionados ao relógio.
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
    
    // MARK: - Remover peça 1
    
    /// Para ser chamado em outras classes pra remover a peça 1 de seu parente
    func removePeca() {
        peca1?.removeFromParent()
    }
    
    // MARK: - Girar
    
    /// Chamado para girar o ponteiro
    /// - Parameters:
    ///   - hand: node do ponteiro
    ///   - degree: grau de rotaÇão
    func spin(hand: SKSpriteNode?, degree: CGFloat) {
        hand?.isPaused = false
        let rotationAngleInRadians = CGFloat.pi * -degree / 180.0 // Converter graus em radianos
        var rotationRatio = -round(hand!.zRotation * 180.0 / CGFloat.pi) // Retornar um valor de rotação em 360 graus
        
        if rotationRatio >= 0 && rotationRatio != 360 { // girar somente em 360 graus
            
            hand?.run(SKAction.rotate(byAngle:  rotationAngleInRadians , duration: 0.2))
        }else{
            hand?.run(SKAction.rotate(byAngle:  rotationAngleInRadians , duration: 0.2))
            hand?.zRotation = 0
            rotationRatio = 360
        }
        if hand == minuteHand {
            minuteRotate = rotationRatio + 30
        } else if hand == hourHand {
            hourRotate = rotationRatio + 30
        }
        
    }
    
    // MARK: - Touch Handling
    
    /// Método chamado quando ocorre um toque na tela.
    /// - Parameters:
    ///   - touches: Conjunto de objetos `UITouch` representando os toques na tela.
    ///   - event: Objeto `UIEvent` contendo informações sobre o evento de toque.
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
            print(hourRotate)
            if delegate?.didZoom == true && canTapAgain {
                canTapAgain = false
                hourHand?.run(clockTickingSFX)
                spin(hand: hourHand, degree: 30)
                if minuteRotate == 60 && hourRotate == 150 {
                    minuteRotate -= 60
                    hourRotate -= 150
                    openClock(animating: true)
                }
                self.run(SKAction.wait(forDuration: 0.2)) {
                    self.canTapAgain = true
                }
                if dialogueClock && minuteRotate == 300 && hourRotate == 30 || dialogueClock && minuteRotate == 300 && hourRotate == 390{
                    minuteRotate -= 300
                    hourRotate -= 30

                    delegateDialogue?.dialogue(node: clock, text: "dialogueClock", ratio: 0.18, isHidden: false)
                    dialogueClock = false
                }
            } else {
                delegate?.zoom(isZoom: true, node: clock, ratio: 0.18)
            }
        case "minuteHand":
            print(minuteRotate)
            if delegate?.didZoom == true && canTapAgain {
                canTapAgain = false
                minuteHand?.run(clockTickingSFX)
                spin(hand: minuteHand, degree: 30)
                if minuteRotate == 60 && hourRotate == 150 {
                    minuteRotate -= 60
                    hourRotate -= 150

                    openClock(animating: true)
                }
                self.run(SKAction.wait(forDuration: 0.2)) {
                    self.canTapAgain = true
                }
                if dialogueClock && minuteRotate == 300 && hourRotate == 30 || dialogueClock && minuteRotate == 300 && hourRotate == 390{
                    minuteRotate -= 300
                    hourRotate -= 30

                    delegateDialogue?.dialogue(node: clock, text: "dialogueClock", ratio: 0.18, isHidden: false)
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
    
    // MARK: - Abrir relogio
    
    /// Abrir o relogio e animar, se nao deixar o node dele já aberto
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
