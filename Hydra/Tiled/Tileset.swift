//
//  TiledTileset.swift
//  RPG-SpriteKit
//
//  Created by Pablo Henrique Bertaco on 21/02/20.
//  Copyright © 2020 OrganizationName. All rights reserved.
//

import SpriteKit

class TiledTileset: SKSpriteNode {

    private var tileWidth: CGFloat = 0
    private var tileHeight: CGFloat = 0
    private var columns = 0
    private var rows = 0
    private var tilecount = 0
    
    var tileTextures = [SKTexture]()
    
    init(imageNamed name: String) {
        let texture = SKSpriteNode(imageNamed: name).texture!
        texture.filteringMode = GameScene.defaultFilteringMode
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func load(tileWidth: CGFloat, tileHeight: CGFloat) {
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        
        self.columns = Int(self.size.width / self.tileWidth)
        self.rows = Int(self.size.height / self.tileHeight)
        
        self.tilecount = self.columns * self.rows
        
        self.load()
    }
    
    func load(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        self.tileWidth = self.size.width / CGFloat(columns)
        self.tileHeight = self.size.height / CGFloat(rows)
        
        self.tilecount = self.columns * self.rows
        
        self.load()
    }
    
    private func load() {
        
        var column: CGFloat = 0
        var row: CGFloat = 1
        
        for _ in 0..<self.tilecount {
            
            if Int(column) >= self.columns {
                column = 0
                row = row + 1
            }
            
            let rect = CGRect(
                origin: CGPoint(x: (self.tileWidth * column)/size.width,
                                y: (self.size.height - (self.tileHeight * row))/self.size.height),
                size: CGSize(width: self.tileWidth/self.size.width,
                             height: self.tileHeight/self.size.height))
            
            let tileTexture = SKTexture(rect: rect, in: self.texture!)
            tileTexture.filteringMode = GameScene.defaultFilteringMode
            
            self.tileTextures.append(tileTexture)
            
            column = column + 1
        }
    }
}
