import SpriteKit

 var inventario: [SKSpriteNode] = [] //classe global para ser pega na static func

class HUD: SKNode{
    
    static let shared = HUD()
    
  private let hud = SKScene(fileNamed: "HUDScene")
  private var travel: SKSpriteNode?
  private var qgButton: SKSpriteNode?
  
  private var inventarioHUD: SKSpriteNode?
  private var inventario: [SKSpriteNode] = []
  var isSelected : Bool = false
  var itemSelecionado : SKSpriteNode?
  
  var delegate: ZoomProtocol?
  
  func hideQGButton(isHide: Bool){
    qgButton?.isHidden = isHide
      inventarioHUD?.isHidden = isHide
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
    if delegate?.didZoom == true{
      borderNode.lineWidth = 1
    }else{
      borderNode.lineWidth = 2
    }
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
  
  func adicionarNoInv(item: SKSpriteNode, acao: SKAction) {
    
    item.removeFromParent()
    
    let button = SKButtonNodeImg(imagem: item) {
      
      item.run(acao)
      if let itemSelecionado = self.itemSelecionado {
        self.removeBorder(from: itemSelecionado)
      }
      
      self.addBorder(to: item)
      self.itemSelecionado = item
      self.isSelected = true
      
    }
    
    item.size = CGSize(width: 50, height: 50)
    
    switch inventario.count {
    case 0:
      item.position = CGPoint(x: 35, y: 124)
    case 1:
      item.position = CGPoint(x: 10, y: 124)
    case 2:
      item.position = CGPoint(x: -15, y: 124)
    case 3:
      item.position = CGPoint(x: -40, y: 124)
    case 4:
      item.position = CGPoint(x: -65, y: 124)
    default:
      return
    }
    
    addChild(button)
    inventario.append(item)
    
  }
    
    static func addOnInv(node: SKSpriteNode?, inventario: inout [SKSpriteNode]){//inout é uma palavra-chave em Swift que permite que um parâmetro de função seja passado por referência.
        let nodeName = node?.name ?? "" // Obtém o nome do nó
        if inventario.contains(where: { $0.name == nodeName }) {
            return // Se já existir, retorna sem adicionar o nó novamente
        }
        
        node?.size = CGSize(width: 30, height: 30) // padroniza o tamanho do node
        node?.zPosition = 30
        switch inventario.count {       // posiciona o node de acordo com a quantidade e node dentro de inventario
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
        inventario.append(node!)
    }
  
}
