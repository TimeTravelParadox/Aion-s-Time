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
