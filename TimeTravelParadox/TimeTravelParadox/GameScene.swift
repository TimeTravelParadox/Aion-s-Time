import SpriteKit

class GameScene: SKScene {
    
    private var futureBG: SKSpriteNode?
    private var pastBG: SKSpriteNode?
    private var toTravel: SKSpriteNode?
    private var clock: SKSpriteNode?
    private var QGButton: SKSpriteNode?
    private var QGBG: SKSpriteNode?
    private var hourHand: SKSpriteNode?
    private var minuteHand: SKSpriteNode?
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    let clockOpening =  SKAction.animate(with: [SKTexture(imageNamed: "clock1"), SKTexture(imageNamed: "clock2"), SKTexture(imageNamed: "clock3"), SKTexture(imageNamed: "clock4"), SKTexture(imageNamed: "clock5")], timePerFrame: 0.4)
    
    var pastState = false
    var qgState = false
    var futureState = false
    var clockState = false
    
    let cameraNode = SKCameraNode()
    var cameraPosition = CGPoint(x: 0, y: 0)
    
    func setupQG(){
        QGBG = childNode(withName: "QGBG") as? SKSpriteNode
    }
    func setupCamera(){
        cameraNode.position = cameraPosition
        addChild(cameraNode)
        camera = cameraNode
    }
    func setupHUD(){
        toTravel = childNode(withName: "toTravel") as? SKSpriteNode
        QGButton = childNode(withName: "QGButton") as? SKSpriteNode
    }

    func setupFuture(){
        futureBG = childNode(withName: "future") as? SKSpriteNode
    }
    
    func spin(hand: SKSpriteNode?, degree: CGFloat){
        let rotationAngleInRadians = CGFloat.pi * -degree / 180.0 // transformar graus em radianos
        var rotationRatio =  -round(hand!.zRotation * 180.0 / CGFloat.pi) // retornar um valor de rotação em 360 graus
        
        if rotationRatio >= 0 && rotationRatio != 360 { // girar somente em 360 graus
            
            hand?.run(SKAction.rotate(byAngle:  rotationAngleInRadians , duration: 0.2))
        }else{
            hand?.run(SKAction.rotate(byAngle:  rotationAngleInRadians , duration: 0.2))
            hand?.zRotation = 0
            rotationRatio = 360
        }
        if hand == minuteHand{
            return minuteRotate = rotationRatio + degree
        } else if hand == hourHand{
            return hourRotate = rotationRatio + degree
        }
    }
    
    func zoomIn(zoom: CGFloat, node: SKSpriteNode?){
            cameraNode.run(SKAction.scale(to: zoom, duration: 0))
            cameraPosition = node?.position ?? cameraNode.position
            cameraNode.position = cameraPosition
    }
    
    func zoomOut(){
        cameraNode.run(SKAction.scale(to: 1, duration: 0))
        cameraPosition = pastBG?.position ?? cameraNode.position
        cameraNode.position = cameraPosition
    }
    
    func setupPast(){
        pastBG = childNode(withName: "past") as? SKSpriteNode
        clock = childNode(withName: "clock") as? SKSpriteNode
        hourHand = childNode(withName: "hourHand") as? SKSpriteNode
        minuteHand = childNode(withName: "minuteHand") as? SKSpriteNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        if minuteRotate == 30  && hourRotate == 60{
            minuteRotate -= 30
            hourRotate -= 60
            clock?.run(clockOpening)
            self.hourHand?.removeFromParent()
            self.minuteHand?.removeFromParent()
        }
    }
    
    override func didMove(to view: SKView) {
        setupFuture()
        setupPast()
        setupHUD()
        setupQG()
        setupCamera()
        qgState = true
        QGBG?.zPosition = 1
        clock?.zPosition = 0
        pastBG?.zPosition = 0
        futureBG?.zPosition = 0
        hourHand?.zPosition = 0
        minuteHand?.zPosition = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "QGButton":
            qgState = true
            pastState = false
            futureState = false
            QGBG?.zPosition = 2
            clock?.zPosition = 0
            pastBG?.zPosition = 0
            futureBG?.zPosition = 0
            hourHand?.zPosition = 0
            minuteHand?.zPosition = 0
        case "toTravel":
            if pastBG?.zPosition == 1 && futureBG?.zPosition == 0 || pastBG?.zPosition == 0 && futureBG?.zPosition == 0{
                futureState = true
                pastState = false
                qgState = false
                clock?.zPosition = 0
                pastBG?.zPosition = 0
                futureBG?.zPosition = 1
                QGBG?.zPosition = 0
                hourHand?.zPosition = 0
                minuteHand?.zPosition = 0
                clock?.zPosition = 0
            }else{
                pastState = true
                qgState = false
                futureState = false
                hourHand?.zPosition = 4
                minuteHand?.zPosition = 3
                clock?.zPosition = 2
                pastBG?.zPosition = 1
                futureBG?.zPosition = 0
                QGBG?.zPosition = 0
            }
            
        case "clock":
            if pastState == true{
                zoomIn(zoom: 0.5, node: clock)
            }
        case "past":
            print("pastbg tocado")
            if pastState == true{
                zoomOut()
            }
        case "hourHand":
            if pastState == true{
                print("ponteiro de hora tocado")
                spin(hand: hourHand, degree: 30)
            }
        case "minuteHand":
            if pastState == true{
                print("ponteiro de minuto tocado")
                spin(hand: minuteHand, degree: 15)
            }
        default:
            return
        }
    }
}
