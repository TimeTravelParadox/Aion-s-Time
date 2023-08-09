import SpriteKit

/// Classe que implementa e cria a HUD do jogo, com o inventario, e os botoes de viajar e do QG
class HUD: SKNode, ToggleTravel{
  
  var delegateHUD: ToggleTravel?
  
  static var shared = HUD()
  
  private let hud = SKScene(fileNamed: "HUDScene")
  var travel: SKSpriteNode?
  var qgButton: SKSpriteNode?
  var fadeHUD: SKSpriteNode?
  var fundoBotaoViajar: SKSpriteNode?
  var inventarioHUD: SKSpriteNode?
  var inventario: [SKSpriteNode] = []
  var isSelected : Bool = false
  var itemSelecionado : SKSpriteNode?
  
  var reset: SKSpriteNode?
    var resetLabel: SKLabelNode?
  
  var peca1: SKSpriteNode?
  var peca2: SKSpriteNode?
  
  var delegate: ZoomProtocol?
  
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
      
      fundoBotaoViajar = hud.childNode(withName: "fundoBotaoViajar") as? SKSpriteNode
      fundoBotaoViajar?.removeFromParent()
        
      resetLabel = hud.childNode(withName: "resetLabel") as? SKLabelNode
      resetLabel?.removeFromParent()
      
    }
    if let travel, let qgButton, let inventarioHUD, let reset, let fadeHUD, let fundoBotaoViajar, let resetLabel{
      self.addChild(travel)
      self.addChild(qgButton)
      self.addChild(inventarioHUD)
      self.addChild(reset)
      self.addChild(fadeHUD)
      self.addChild(fundoBotaoViajar)
      self.addChild(resetLabel)
    }
      resetLabel?.fontName = "FiraCode-SemiBold"
      resetLabel?.text = NSLocalizedString("reset", comment: "")
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /// Função que ativa o botao de viajar no QG
  func ativarTravel() {
    travel?.alpha = 1
    travel?.isUserInteractionEnabled = false
    travel?.zPosition = 15
    fundoBotaoViajar?.isHidden = false
    fundoBotaoViajar?.alpha = 1
  }
  
  /// Função que desativa o botao de viajar do QG
  func desativarTravel() {
    travel?.alpha = 0.5
    travel?.isUserInteractionEnabled = true
    travel?.zPosition = 15
    fundoBotaoViajar?.isHidden = true
  }
  
  /// Oculta ou exibe o botão do QG e o inventário na tela.
  ///
  /// - Parameters:
  ///   - isHide: Um valor booleano que determina se o botão do QG e o inventário devem ser ocultados ou exibidos.
  ///            - true: O botão do QG e o inventário serão ocultados.
  ///            - false: O botão do QG e o inventário serão exibidos.
  func hideQGButton(isHide: Bool) {
    qgButton?.isHidden = isHide
    inventarioHUD?.isHidden = isHide
  }
  
  /// Oculta ou exibe o botão de viajar e o botão do QG
  ///
  /// - Parameters:
  ///   - isHide: Um valor booleano que determina se o botão de viajar e o botão do QG devem ser ocultados ou exibidos.
  ///            - true: O botão de viajar e o botão do QG serão ocultados.
  ///            - false: O botão de viajar e o botão do QG serão exibidos.
  func hideTravelQG(isHide: Bool){//esconde tudo mas o inv n
    travel?.isHidden = isHide
    qgButton?.isHidden = isHide
  }
  
  /// Oculta ou exibe o botão de resetar o jogo
  ///
  /// - Parameters:
  ///   - isHide: Um valor booleano que determina se o botão de resetar deve ser ocultado ou exibido.
  ///            - true: O botão de resetar será ocultado.
  ///            - false: O botão de resetar será exibido.
  func hideResetButton(isHide: Bool){
    reset?.isHidden = isHide
      resetLabel?.isHidden = isHide
  }
  
  /// Oculta ou exibe o botão de viajar entre as eras do jogo
  ///
  /// - Parameters:
  ///   - isHide: Um valor booleano que determina se o botão de viajar deve ser ocultado ou exibido.
  ///            - true: O botão de viajar será ocultado.
  ///            - false: O botão de viajar será exibido.
  func hideFundoBotaoViajar(isHide: Bool) {
    fundoBotaoViajar?.isHidden = isHide
  }
  
  /// Define a propriedade alpha do SKSpriteNode fornecido como 0.5, fazendo ele ser semi-transparente.
  ///
  /// - Parameters:
  ///     - node: O SKSpriteNode ao qual o efeito de borda será adicionado.
  ///
  func addBorder(to node: SKSpriteNode) {
    node.alpha = 0.5
  }
  
  /// Remove o efeito de borda restaurando a propriedade alpha do SKSpriteNode fornecido para 1, tornando-o totalmente opaco.
  ///
  /// - Parameters:
  ///     - node: O SKSpriteNode do qual o efeito de borda será removido.
  ///
  func removeBorder(from node: SKSpriteNode) {
    HUD.shared.itemSelecionado = nil
    node.alpha = 1
  }
  
  /// Posiciona o SKSpriteNode fornecido em relação à posição da câmera dentro da cena.
  ///
  /// - Parameters:
  ///     - node: O SKSpriteNode a ser posicionado em relação à câmera.
  ///     - offsetX: O eixo X em relação à posição da câmera.
  ///     - offsetY: O eixo Y em relação à posição da câmera.
  ///
  func positionNodeRelativeToCamera(_ node: SKSpriteNode, offsetX: CGFloat, offsetY: CGFloat) {
    if let camera = GameScene.shared.camera {
      let cameraPositionInScene = convert(camera.position, to: self)
      let newPosition = CGPoint(x: cameraPositionInScene.x + offsetX, y: cameraPositionInScene.y + offsetY)
      node.position = newPosition
    }
  }
  
  /// Redimensiona e reposiciona o nó do inventário do HUD (inventarioHUD) com base na proporção fornecida.
  ///
  /// - Parameters:
  ///     - ratio: A proporção pela qual o inventário do HUD será dimensionado.
  ///
  func reposiconarInvIn(ratio: CGFloat) {
    inventarioHUD?.size = CGSize(width: 260*ratio, height: 50*ratio)
    positionNodeRelativeToCamera(inventarioHUD!, offsetX: 0*ratio, offsetY: -135*ratio)
  }
  
  /// Restaura o tamanho e posição padrão do inventário do HUD (inventarioHUD).
  ///
  func reposiconarInvOut() {
    inventarioHUD?.size = CGSize(width: 260, height: 50)
    inventarioHUD?.position = CGPoint(x: 0, y: -135)
  }
  
  /// Adiciona o SKSpriteNode fornecido ao inventário do HUD (inventarioHUD).
  ///
  /// - Parameters:
  ///     - node: O SKSpriteNode a ser adicionado ao inventário.
  ///
  /// - Nota: Essa função ajusta o tamanho do nó e o posiciona com base no número de nós já existentes no inventário e no nível atual de zoom da câmera.
  ///
  static func addOnInv(node: SKSpriteNode?){
    // inout é uma palavra-chave em Swift que permite que um parâmetro de função seja passado por referência.
    let nodeName = node?.name ?? "" // Obtém o nome do nó
    let maior = max((node?.size.width)!, (node?.size.height)!)
    let widthMaior = maior == node?.size.width ? true : false
    
    if HUD.shared.inventario.contains(where: { $0.name == nodeName }) {
      return // Se já existir, retorna sem adicionar o nó novamente
    }
    node?.zRotation = 0
    if HUD.shared.delegate?.didZoom == false {
      // padroniza o tamanho do node
      if widthMaior {
        node?.size = CGSize(width: 25, height: (25*(node?.size.height)!)/(node?.size.width)!)
      }else{
        node?.size = CGSize(width: (25*(node?.size.width)!)/(node?.size.height)!, height: 25)
      }
    } else {
      if widthMaior {
        node?.size = CGSize(width: 25*GameScene.shared.ratio, height: (25*(node?.size.height)!)/(node?.size.width)!*GameScene.shared.ratio)
      } else {
        node?.size = CGSize(width: (25*(node?.size.width)!)/(node?.size.height)!*GameScene.shared.ratio, height: 25*GameScene.shared.ratio)
      }
    }
    
    if HUD.shared.delegate?.didZoom == false {
      switch HUD.shared.inventario.count { // posiciona o node de acordo com a quantidade e node dentro de inventario
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
    } else {
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
