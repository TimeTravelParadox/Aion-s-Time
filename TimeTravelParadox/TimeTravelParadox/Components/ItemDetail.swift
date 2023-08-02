//
//  ItemDetail.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 21/07/23.
//

import SpriteKit

class ItemDetail: SKSpriteNode {
    // Variável que armazena o nome do item.
    var itemName: String?
    
    // Inicializador da classe ItemDetail.
    init(item: SKSpriteNode) {
        // Atribui o nome do item à variável itemName.
        itemName = item.name
        // Inicializa a classe base (SKSpriteNode) com as propriedades do item.
        super.init(texture: item.texture, color: item.color, size: item.size)
        // Define o nome desta instância como "itemDetail".
        name = "itemDetail"
        // Define a posição Z desta instância como 20, para que seja exibida acima de outros elementos na cena.
        zPosition = 20
        
        // Verifica o nome do item para definir seu tamanho com base em um switch-case.
        switch itemName {
        case "polaroid":
            size = CGSize(width: 100 * GameScene.shared.ratio, height: 100 * GameScene.shared.ratio)
        case "paper":
            size = CGSize(width: 200 * GameScene.shared.ratio, height: 200 * GameScene.shared.ratio)
        case "paperComplete":
            size = CGSize(width: 200 * GameScene.shared.ratio, height: 250 * GameScene.shared.ratio)
        default:
            // Se o nome do item não corresponder a nenhum dos casos, a função retorna.
            return
        }
    }
    
    // Requerido para conformidade com o protocolo NSCoder, mas não é usado neste contexto.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Função para interagir com o item com base em seu nome.
    func interact() {
        // Verifica o nome do item para decidir a ação de interação.
        switch itemName {
        case "polaroid":
            // Se o item for uma "polaroid", chama a função privada "spin" para girá-lo.
            spin()
        // Adicionar outros casos para outros itens, se necessário.
        default:
            // Se o nome do item não corresponder a nenhum dos casos, a função retorna.
            return
        }
    }
    
    // Função privada para girar o item.
    private func spin() {
        // Cria uma ação de rotação para girar o item 180 graus (pi radianos) em 0.2 segundos.
        let spinPolaroid = SKAction.rotate(byAngle: .pi, duration: 0.2)
        // Executa a ação de rotação no item.
        run(spinPolaroid)
    }
}
