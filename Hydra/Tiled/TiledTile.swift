//
//  TiledTile.swift
//  RPG-SpriteKit
//
//  Created by Pablo Henrique Bertaco on 21/02/20.
//  Copyright © 2020 OrganizationName. All rights reserved.
//

import SpriteKit

class TiledTile: SKSpriteNode {

    init(texture: SKTexture, x: Int, y: Int) {
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = TiledTile.position(x: x, y: y)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func position(x: Int, y: Int) -> CGPoint {
        guard let map = TiledMap.current  else {
            return .zero
        }
        return CGPoint(x: x * Int(map.tileWidth), y: -y * Int(map.tileHeight))
    }
}
