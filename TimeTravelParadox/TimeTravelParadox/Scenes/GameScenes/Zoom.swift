import SpriteKit

protocol ZoomProtocol {
  var didZoom: Bool { get set }
  func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat)
}

protocol RemoveProtocol{
  func removePeca()
}

protocol RemoveProtocol2{
  func removePeca()
}

func CasesPositions(node: SKSpriteNode?){
    for (index, item) in HUD.shared.inventario.enumerated() {
      item.size = CGSize(width: 25, height: 25)
      switch index {
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
    }
}
