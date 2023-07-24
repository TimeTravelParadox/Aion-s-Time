import SpriteKit
//1- mofer item details da past pra ca
//2- HUD ser avisado de eventos de zoom
//3- toda vez que um zoom acontecer reposicionar o elemento pro meio da tela realativo ao no da camera
//4-
class HUD: SKNode{
    
    static let shared = HUD()
    
  private let hud = SKScene(fileNamed: "HUDScene")
  private var travel: SKSpriteNode?
  private var qgButton: SKSpriteNode?

    var inventarioHUD: SKSpriteNode?
    var inventario: [SKSpriteNode] = []
  var isSelected : Bool = false
  var itemSelecionado : SKSpriteNode?
    
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
  
  override init(){
    super.init()
    if let hud {
      travel = (hud.childNode(withName: "travel") as? SKSpriteNode)
      travel?.removeFromParent()
      qgButton = (hud.childNode(withName: "qgButton") as? SKSpriteNode)
      qgButton?.removeFromParent()
      
      inventarioHUD = hud.childNode(withName: "inventarioHUD") as? SKSpriteNode
      inventarioHUD?.removeFromParent()
      //            self.isUserInteractionEnabled = true
    }
    if let travel, let qgButton, let inventarioHUD {
      self.addChild(travel)
      self.addChild(qgButton)
      self.addChild(inventarioHUD)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func addBorder(to node: SKSpriteNode) {
    // Calcula o retângulo da borda com base no tamanho do sprite node
    let borderRect = CGRect(x: -node.size.width/2, y: -node.size.height/2,
                            width: node.size.width, height: node.size.height)
    
    // Cria um shape node com a forma de um retângulo
    let borderNode = SKShapeNode(rect: borderRect)
    
    // Define as propriedades da borda
    borderNode.strokeColor = .white
    borderNode.lineWidth = 2 * GameScene.shared.ratio!
    // Adiciona o shape node à cena
    node.addChild(borderNode)
  }
  
  func removeBorder(from node: SKSpriteNode) {
      HUD.shared.itemSelecionado = nil
    // Percorre os nós filhos do sprite node
    for childNode in node.children {
      // Verifica se o nó filho é um shape node
      if let shapeNode = childNode as? SKShapeNode {
        // Remove o shape node da cena
        shapeNode.removeFromParent()
      }
    }
  }
    
    func positionNodeRelativeToCamera(_ node: SKSpriteNode, offsetX: CGFloat, offsetY: CGFloat) {
        if let camera = GameScene.shared.camera {
            let cameraPositionInScene = convert(camera.position, to: self)
            let newPosition = CGPoint(x: cameraPositionInScene.x + offsetX, y: cameraPositionInScene.y + offsetY)
            node.position = newPosition
        }
    }

    func reposiconarInvIn(ratio: CGFloat) {
        inventarioHUD?.size = CGSize(width: 320*ratio, height: 50*ratio)
        positionNodeRelativeToCamera(inventarioHUD!, offsetX: 80*ratio, offsetY: 145*ratio)
    }
    
    func reposiconarInvOut() {
        inventarioHUD?.size = CGSize(width: 320, height: 50)
        inventarioHUD?.position = CGPoint(x: 80, y: 145)
    }
    
    static func addOnInv(node: SKSpriteNode?){//inout é uma palavra-chave em Swift que permite que um parâmetro de função seja passado por referência.
        let nodeName = node?.name ?? "" // Obtém o nome do nó
        if HUD.shared.inventario.contains(where: { $0.name == nodeName }) {
            return // Se já existir, retorna sem adicionar o nó novamente
        }
        if HUD.shared.delegate?.didZoom == false {
            node?.size = CGSize(width: 30, height: 30) // padroniza o tamanho do node
        }else{
            node?.size = CGSize(width: 30*GameScene.shared.ratio!, height: 30*GameScene.shared.ratio!) // padroniza o tamanho do node
        }
        
        
        if HUD.shared.delegate?.didZoom == false {
            switch HUD.shared.inventario.count {       // posiciona o node de acordo com a quantidade e node dentro de inventario
            case 0:
              node?.position = CGPoint(x: -50, y: 144)
            case 1:
              node?.position = CGPoint(x: 0, y: 144)
            case 2:
              node?.position = CGPoint(x: 50, y: 144)
            case 3:
              node?.position = CGPoint(x: 100, y: 144)
            case 4:
              node?.position = CGPoint(x: 150, y: 144)
            default:
              return
            }
        }else{
            print(GameScene.shared.ratio!)
            switch HUD.shared.inventario.count {       // posiciona o node de acordo com a quantidade e node dentro de inventario
            case 0:
                node?.position = CGPoint(x: (-50*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.x, y: (144*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.y)
            case 1:
              node?.position = CGPoint(x: (0*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.x, y: (144*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.y)
            case 2:
              node?.position = CGPoint(x: (50*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.x, y: (144*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.y)
            case 3:
              node?.position = CGPoint(x: (100*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.x, y: (144*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.y)
            case 4:
              node?.position = CGPoint(x: (150*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.x, y: (144*GameScene.shared.ratio!) + GameScene.shared.cameraPosition.y)
            default:
              return
            }
        }
        
        HUD.shared.inventario.append(node!)
        node?.zPosition = 15
    }
  
}
