//
//  TiledObject.swift
//  RPG-SpriteKit
//
//  Created by Pablo Henrique Bertaco on 21/02/20.
//  Copyright © 2020 OrganizationName. All rights reserved.
//

import SpriteKit

class TiledObject: NSObject {
    
    var id = ""
    var name = ""
    var type = ""
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    var attributeDict = [String : String]()
}
