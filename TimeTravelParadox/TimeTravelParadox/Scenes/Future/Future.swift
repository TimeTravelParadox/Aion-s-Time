import SpriteKit

class Future: SKNode, InventoryItemDelegate {

  private let futureScene = SKScene(fileNamed: "FutureScene")
  private var futureBG: SKSpriteNode?
  private var mesa: SKSpriteNode?
  private var monitorEsquerda: SKSpriteNode?
  
  var computer: Computer?
  var vault: Vault?
  var hologram: Hologram?
    
  let futureST = SKAction.repeatForever(SKAction.playSoundFileNamed("futureST.mp3", waitForCompletion: true))
  
  var delegate: ZoomProtocol?
  
  init(delegate: ZoomProtocol){
    super.init()
    self.delegate = delegate
    self.computer = Computer(delegate: delegate)
    self.vault = Vault(delegate: delegate)
    self.hologram = Hologram(delegate: delegate)
    vault?.setupCofre()
    vault?.zPosition()
    self.zPosition = 1
    
    if let futureScene, let computer, let vault, let hologram {
      futureBG = (futureScene.childNode(withName: "futureBG") as? SKSpriteNode)
      futureBG?.removeFromParent()
      mesa = futureScene.childNode(withName: "mesaFuturo") as? SKSpriteNode
      mesa?.removeFromParent()
      monitorEsquerda = futureScene.childNode(withName: "monitorEsquerda") as? SKSpriteNode
      monitorEsquerda?.removeFromParent()
      
      self.isUserInteractionEnabled = true
 
      if let futureBG, let mesa, let monitorEsquerda{
        self.addChild(mesa)
        self.addChild(monitorEsquerda)
        self.addChild(futureBG)
      }
      
      self.addChild(computer)
      computer.delegate = delegate
      self.addChild(vault)
      vault.delegate = delegate
      self.addChild(hologram)
      hologram.delegate = delegate
        
        computer.inventoryItemDelegate = self
        vault.inventoryItemDelegate = self
        hologram.inventoryItemDelegate = self
        
      
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return }
    
    switch tapped.name {
    case "futureBG":
      delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
      print("futuro plano de fundo")
        // Deselecionar o item
        if HUD.shared.isSelected {
            if HUD.shared.itemSelecionado != nil {
                HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
            }
        }
    case "itemDetail":
        GameScene.shared.itemDetail?.interact()
        return
    case "crumpledPaper":
        if let tapped = tapped as? SKSpriteNode { //isso eh um skspritenode?
            select(node: tapped)
            return
        }
    case "mesaFuturo":
      delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
      print("futuro plano de fundo")
        // Deselecionar o item
        if HUD.shared.isSelected {
            if HUD.shared.itemSelecionado != nil {
                HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
            }
        }
    case "monitorEsquerda":
      delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
      print("futuro plano de fundo")
        // Deselecionar o item
        if HUD.shared.isSelected {
            if HUD.shared.itemSelecionado != nil {
                HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
            }
        }
    default:
      break
    }
      clearItemDetail()
  }
    
    func clearItemDetail() {
        GameScene.shared.itemDetail?.removeFromParent()
        GameScene.shared.itemDetail = nil
    }
    
    func select(node: SKSpriteNode) {
        guard GameScene.shared.itemDetail == nil else {
            return
        }
        GameScene.shared.itemDetail = ItemDetail(item: node)
        GameScene.shared.itemDetail?.position = CGPoint(x: GameScene.shared.cameraPosition.x, y: GameScene.shared.cameraPosition.y)
        addChild(GameScene.shared.itemDetail!)
    }
  
}
