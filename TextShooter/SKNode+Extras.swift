//
//  SKNode+Extras.swift
//  TextShooter
//
//  Created by Pedro Alonso on 4/1/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    @objc func receiveAttacker(_ attacker: SKNode, contact: SKPhysicsContact) {
        // Default implementation does nothing
    }
    
    @objc func friendlyBumpFrom(_ node: SKNode) {
        // Default implementation does nothing
    }
    
}
