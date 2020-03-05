//
//  StringExtension.swift
//  RPG-SpriteKit
//
//  Created by Pablo Henrique Bertaco on 03/03/20.
//  Copyright © 2020 OrganizationName. All rights reserved.
//

import SpriteKit

extension String {
    
    func scrub() -> String {
        var scrubbed = self.replacingOccurrences(of: " ", with: "")
        scrubbed = scrubbed.replacingOccurrences(of: "\n", with: "")
        return scrubbed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
