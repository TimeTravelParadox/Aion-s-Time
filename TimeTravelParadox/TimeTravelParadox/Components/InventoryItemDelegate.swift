//
//  InventoryItemDelegate.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 21/07/23.
//

import SpriteKit

protocol InventoryItemDelegate {
  func select(node: SKSpriteNode)
  func clearItemDetail()
}
