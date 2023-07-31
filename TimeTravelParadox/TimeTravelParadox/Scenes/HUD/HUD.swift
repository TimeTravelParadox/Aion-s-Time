import SpriteKit

class HUD: SKNode, ToggleTravel{
    func ativarTravel() {
        travel?.alpha = 1
        travel?.isUserInteractionEnabled = false
        travel?.zPosition = 15

    }
    
    func desativarTravel() {
        travel?.alpha = 0.5
        travel?.isUserInteractionEnabled = true
        travel?.zPosition = 15
    }
    
    var delegateHUD: ToggleTravel?
    
    static var shared = HUD()
    
    private let hud = SKScene(fileNamed: "HUDScene")
     var travel: SKSpriteNode?
    private var qgButton: SKSpriteNode?
    private var fadeHUD: SKSpriteNode?
    
    var inventarioHUD: SKSpriteNode?
    var inventario: [SKSpriteNode] = []
    var isSelected : Bool = false
    var itemSelecionado : SKSpriteNode?
  
  var reset: SKSpriteNode?
    
    var peca1: SKSpriteNode?
    var peca2: SKSpriteNode?
    
    var delegate: ZoomProtocol?
    
    func hideQGButton(isHide: Bool){
        qgButton?.isHidden = isHide
        inventarioHUD?.isHidden = isHide
    }
    
    func hideTravelQG(isHide: Bool){//esconde tudo mas o inv n
        travel?.isHidden = isHide
        qgButton?.isHidden = isHide
    }
  
  func hideResetButton(isHide: Bool){
    reset?.isHidden = isHide
  }
    
    override init(){
        super.init()
        if let hud {
            travel = (hud.childNode(withName: "travel") as? SKSpriteNode)
            travel?.removeFromParent()
            qgButton = (hud.childNode(withName: "qgButton") as? SKSpriteNode)
            qgButton?.removeFromParent()
            
            inventarioHUD = hud.childNode(withName: "inventarioHUD") as? SKSpriteNode
            inventarioHUD?.removeFromParent()
          
          reset = hud.childNode(withName: "reset") as? SKSpriteNode
          reset?.removeFromParent()
            
            fadeHUD = hud.childNode(withName: "fadeHUD") as? SKSpriteNode
            fadeHUD?.removeFromParent()
          
        }
        if let travel, let qgButton, let inventarioHUD, let reset, let fadeHUD {
            self.addChild(travel)
            self.addChild(qgButton)
            self.addChild(inventarioHUD)
          self.addChild(reset)
            self.addChild(fadeHUD)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addBorder(to node: SKSpriteNode) {
        node.alpha = 0.5
    }
    
    func removeBorder(from node: SKSpriteNode) {
        HUD.shared.itemSelecionado = nil
        node.alpha = 1
    }
    
    
    func positionNodeRelativeToCamera(_ node: SKSpriteNode, offsetX: CGFloat, offsetY: CGFloat) {
        if let camera = GameScene.shared.camera {
            let cameraPositionInScene = convert(camera.position, to: self)
            let newPosition = CGPoint(x: cameraPositionInScene.x + offsetX, y: cameraPositionInScene.y + offsetY)
            node.position = newPosition
        }
    }
    
    func reposiconarInvIn(ratio: CGFloat) {
        inventarioHUD?.size = CGSize(width: 260*ratio, height: 50*ratio)
        positionNodeRelativeToCamera(inventarioHUD!, offsetX: 0*ratio, offsetY: -135*ratio)
    }
    
    func reposiconarInvOut() {
        inventarioHUD?.size = CGSize(width: 260, height: 50)
        inventarioHUD?.position = CGPoint(x: 0, y: -135)
    }
    
    static func addOnInv(node: SKSpriteNode?){//inout é uma palavra-chave em Swift que permite que um parâmetro de função seja passado por referência.
        let nodeName = node?.name ?? "" // Obtém o nome do nó
        if HUD.shared.inventario.contains(where: { $0.name == nodeName }) {
            return // Se já existir, retorna sem adicionar o nó novamente
        }
        node?.zRotation = 0
        if HUD.shared.delegate?.didZoom == false {
            node?.size = CGSize(width: 25, height: 25) // padroniza o tamanho do node
        }else{
            node?.size = CGSize(width: 25*GameScene.shared.ratio, height: 25*GameScene.shared.ratio) // padroniza o tamanho do node
        }
        
        
        if HUD.shared.delegate?.didZoom == false {
            switch HUD.shared.inventario.count {       // posiciona o node de acordo com a quantidade e node dentro de inventario
            case 0:
                node?.position = CGPoint(x: -94, y: -128.5)
            case 1:
                node?.position = CGPoint(x: -47, y: -128.5)
            case 2:
                node?.position = CGPoint(x: 0, y: -128.5)
            case 3:
                node?.position = CGPoint(x: 47, y: -128.5)
            case 4:
                node?.position = CGPoint(x: 94, y: -128.5)
            default:
                return
            }
        }else{
            print(GameScene.shared.ratio)
            switch HUD.shared.inventario.count {       // posiciona o node de acordo com a quantidade e node dentro de inventario
            case 0:
                node?.position = CGPoint(x: (-94*GameScene.shared.ratio) + GameScene.shared.cameraPosition.x, y: (-128.5*GameScene.shared.ratio) + GameScene.shared.cameraPosition.y)
            case 1:
                node?.position = CGPoint(x: (-47*GameScene.shared.ratio) + GameScene.shared.cameraPosition.x, y: (-128.5*GameScene.shared.ratio) + GameScene.shared.cameraPosition.y)
            case 2:
                node?.position = CGPoint(x: (0*GameScene.shared.ratio) + GameScene.shared.cameraPosition.x, y: (-128.5*GameScene.shared.ratio) + GameScene.shared.cameraPosition.y)
            case 3:
                node?.position = CGPoint(x: (47*GameScene.shared.ratio) + GameScene.shared.cameraPosition.x, y: (-128.5*GameScene.shared.ratio) + GameScene.shared.cameraPosition.y)
            case 4:
                node?.position = CGPoint(x: (94*GameScene.shared.ratio) + GameScene.shared.cameraPosition.x, y: (-128.5*GameScene.shared.ratio) + GameScene.shared.cameraPosition.y)
            default:
                return
            }
        }
        
        HUD.shared.inventario.append(node!)
        node?.zPosition = 15
    }
    
}
