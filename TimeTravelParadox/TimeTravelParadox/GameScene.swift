import SpriteKit

class GameScene: SKScene {
    
    private var futureBG: SKSpriteNode?
    private var pastBG: SKSpriteNode?
    private var toTravel: SKSpriteNode?
    private var watch: SKSpriteNode?
    private var QGButton: SKSpriteNode?
    private var QGBG: SKSpriteNode?
    
    
    func setupQG(){
        QGBG = childNode(withName: "QGBG") as? SKSpriteNode
    }
    
    func setupHUD(){
        toTravel = childNode(withName: "toTravel") as? SKSpriteNode
        QGButton = childNode(withName: "QGButton") as? SKSpriteNode
    }

    func setupFuture(){
        futureBG = childNode(withName: "future") as? SKSpriteNode


    }
    
    func setupPast(){
        pastBG = childNode(withName: "past") as? SKSpriteNode
        watch = childNode(withName: "watch") as? SKSpriteNode
    }
    
    override func didMove(to view: SKView) {
        setupFuture()
        setupPast()
        setupHUD()
        setupQG()
        QGBG?.zPosition = 2
        watch?.zPosition = 0
        pastBG?.zPosition = 0
        futureBG?.zPosition = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "QGButton":
            QGBG?.zPosition = 2
            watch?.zPosition = 0
            pastBG?.zPosition = 0
            futureBG?.zPosition = 0
        case "toTravel":
            if pastBG?.zPosition == 1 && futureBG?.zPosition == 0 || pastBG?.zPosition == 0 && futureBG?.zPosition == 0{
                watch?.zPosition = 0
                pastBG?.zPosition = 0
                futureBG?.zPosition = 1
                QGBG?.zPosition = 0
                
            }else{
                
                watch?.zPosition = 2
                pastBG?.zPosition = 1
                futureBG?.zPosition = 0
                QGBG?.zPosition = 0
                
            }
        default:
            return
        }
    }
}
