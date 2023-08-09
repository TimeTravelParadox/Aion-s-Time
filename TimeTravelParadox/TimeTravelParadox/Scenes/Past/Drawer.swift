//
//  Drawer.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit

class Drawer {
    // Enumeração para representar os tamanhos da gaveta.
    enum Size {
        case large
        case small
        
        // Prefixo para os nomes das texturas de animação da gaveta.
        var prefix: String {
            switch self {
            case .large:
                return "larger"
            case .small:
                return "smaller"
            }
        }
    }
    
    // Ação de áudio para a gaveta sendo aberta ou fechada.
    let drawerOpening = SKAction.playSoundFileNamed("gavetaAbrindo", waitForCompletion: false)
    
    // Referência ao nó SpriteKit representando a gaveta.
    var spriteNode: SKSpriteNode
    
    // Tamanho atual da gaveta (large ou small).
    let drawerSize: Size
    
    // Variável para indicar se a gaveta está aberta ou fechada.
    var isOpened: Bool
    
    // Variável para controlar se a animação da gaveta está em andamento.
    private var isAnimating = false
    
    // Inicializador da classe Drawer.
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
    
    // Método para abrir ou fechar a gaveta, com uma chamada de conclusão opcional.
    func toggle(completion: @escaping () -> Void) {
        // Verifica se a animação da gaveta já está em andamento, se sim, não faz nada.
        guard isAnimating == false else {
            return
        }
        
        isAnimating = true
        
        // Determina as texturas de animação da gaveta com base no estado atual (aberta ou fechada).
        let textures: [SKTexture]
        if isOpened {
            textures = animationTextures().reversed()
        } else {
            textures = animationTextures()
        }
        
        // Duração da animação.
        let duration = 0.2
        var animations = [SKAction]()
        for texture in textures {
            let size = texture.size()
            // Cria a animação para alterar a textura e redimensionar a gaveta.
            animations.append(SKAction.group([
                SKAction.animate(with: [texture], timePerFrame: duration),
                SKAction.resize(toWidth: size.width, height: size.height, duration: duration / 2)
            ]))
        }
        
        // Cria a sequência de animações.
        let sequence = SKAction.sequence(animations)
        // Cria a animação completa que inclui a sequência de texturas e o áudio.
        let animation = SKAction.group([sequence, SKAction.playSoundFileNamed("gavetaAbrindo", waitForCompletion: false)])
        
        // Executa a animação na gaveta.
        spriteNode.run(animation) { [weak self] in
            // A animação terminou de rodar
            guard let self = self else {
                return
            }
            // Atualiza o estado da gaveta (aberta ou fechada) e reseta a flag de animação.
            self.isOpened = !self.isOpened
            self.isAnimating = false
            // Chama a conclusão (se fornecida).
            completion()
        }
    }
    
    /// Método para obter a sequência de texturas de animação da gaveta.
    private func animationTextures() -> [SKTexture] {
        return [
            SKTexture(imageNamed: "\(drawerSize.prefix)ClosedDrawer"),
            SKTexture(imageNamed: "\(drawerSize.prefix)HalfOpenDrawer"),
            SKTexture(imageNamed: "\(drawerSize.prefix)OpenDrawer")
        ]
    }
}
