//
//  Drawer.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit

class Drawer {
  
  enum Size {
    case large
    case small
    
    var prefix: String {
      switch self {
      case .large:
        return "larger"
      case .small:
        return "smaller"
      }
    }
  }
  
  let drawerOpening = SKAction.playSoundFileNamed("gavetaAbrindo", waitForCompletion: false)
  
  var spriteNode: SKSpriteNode
  let drawerSize: Size
  var isOpened: Bool
  // para dar pra clicar só quando a animação estiver false
  private var isAnimating = false
  
  //inicializando os objetos
  init(drawerSize: Size, spriteNode: SKSpriteNode) {
    self.drawerSize = drawerSize
    self.spriteNode = spriteNode
    self.isOpened = false
    spriteNode.removeFromParent()
    spriteNode.isPaused = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // onde a gaveta abre e fecha
  func toggle(completion: @escaping () -> Void) {
    guard isAnimating == false else {
      return
    }
    
    isAnimating = true
    
    let textures: [SKTexture]
    if isOpened {
      textures = animationTextures().reversed()
    } else {
      textures = animationTextures()
    }
    
    let duration = 0.2
    var animations = [SKAction]()
    for texture in textures {
      let size = texture.size()
      animations.append(SKAction.group([
        SKAction.animate(with: [texture], timePerFrame: duration),
        SKAction.resize(toWidth: size.width, height: size.height, duration: duration / 2)
      ]))
    }
    let sequence = SKAction.sequence(animations)
    let animation = SKAction.group([sequence, SKAction.playSoundFileNamed("gavetaAbrindo", waitForCompletion: false)])
    spriteNode.run(animation) { [weak self] in // weak self serve para guardar na memória CASO haja alguma referencia dps que mudar de cena (ao voltar pro passado a gaveta estar aberta ou fechada)
      // A animação terminou de rodar
      guard let self = self else {
        return
      }
      self.isOpened = !isOpened
      self.isAnimating = false
      completion()
    }
  }
  
  //sequencia de animação dos assets
  private func animationTextures() -> [SKTexture] {
    return [SKTexture(imageNamed: "\(drawerSize.prefix)ClosedDrawer"), SKTexture(imageNamed: "\(drawerSize.prefix)HalfOpenDrawer"), SKTexture(imageNamed: "\(drawerSize.prefix)OpenDrawer")]
  }
}
