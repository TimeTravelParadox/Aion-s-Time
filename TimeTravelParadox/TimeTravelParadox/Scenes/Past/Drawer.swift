//
//  Drawer.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit

protocol DrawerDelegate {
    func addCrumpledPaperIfNeeded(to drawer: Drawer)
    func removeCrumpledPaperIfNeeded(to drawer: Drawer)
}

class Drawer: SKNode {
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
    
    var spriteNode: SKSpriteNode?
    let drawerSize: Size
    private var isOpened: Bool
    // para dar pra clicar só quando a animação estiver false
    private var isAnimating = false

    var delegate: DrawerDelegate?
    var zoomDelegate: ZoomProtocol?
    
    //inicializando os objetos
    init(drawerSize: Size, spriteNode: SKSpriteNode?) {
        self.drawerSize = drawerSize
        self.spriteNode = spriteNode
        self.isOpened = false
        super.init()
        if let spriteNode {
            spriteNode.removeFromParent()
            addChild(spriteNode)
        }
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        guard let spriteNode, tapped == spriteNode else { return }
        zoomDelegate?.zoom(isZoom: true, node: spriteNode, ratio: 0.26)
        toggle()
    }
    
    // onde a gaveta abre e fecha
    private func toggle() {
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
        
        spriteNode?.run((SKAction.sequence(animations))) { [weak self] in // weak self serve para guardar na memória CASO haja alguma referencia dps que mudar de cena (ao voltar pro passado a gaveta estar aberta ou fechada)
            // A animação terminou de rodar
            guard let self = self else {
                return
            }
            
            if self.isOpened == false {
                self.delegate?.addCrumpledPaperIfNeeded(to: self)
            } else {
                self.delegate?.removeCrumpledPaperIfNeeded(to: self)
            }
            
            self.isOpened = !isOpened
            self.isAnimating = false
        }
    }
    //sequencia de animação dos assets
    private func animationTextures() -> [SKTexture] {
        return [SKTexture(imageNamed: "\(drawerSize.prefix)ClosedDrawer"), SKTexture(imageNamed: "\(drawerSize.prefix)HalfOpenDrawer"), SKTexture(imageNamed: "\(drawerSize.prefix)OpenDrawer")]
    }
}
