//
//  InventoryItemDelegate.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 21/07/23.
//

import SpriteKit

/// Protocolo usado para o detalhe do item no inventário.
protocol InventoryItemDelegate {
    /// Método para selecionar e exibir o nó no meio da tela.
    /// - Parameter node: O nó do tipo SKSpriteNode que representa o item a ser exibido.
    func select(node: SKSpriteNode)

    /// Método para deselecionar o item e removê-lo do meio da tela.
    func clearItemDetail()
}

