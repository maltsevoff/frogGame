//
//  Model.swift
//  frogGame
//
//  Created by Alex Maltsev on 10/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import Foundation
import SpriteKit

struct Layer {
	static let background: CGFloat = 0
	static let gameNode: CGFloat = 1
	static let frog: CGFloat = 2
	static let foreground: CGFloat = 3
}

struct PhysicsSettings {
	static let none: UInt32 = 0
	static let all: UInt32 = UInt32.max
	static let enemy: UInt32 = 0b1
	static let log: UInt32 = 0b10
	static let frog: UInt32 = 0b11
}
