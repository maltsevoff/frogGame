//
//  NodeManager.swift
//  frogGame
//
//  Created by Alex Maltsev on 10/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import Foundation
import SpriteKit

class NodeManager {
	
	let size: CGSize
	
	init(size: CGSize) {
		self.size = size
	}
	
	func makeLog(onPosition: CGPoint, name: String, score: Int) -> SKSpriteNode {
		var logName = "log"
		let logNum = Int.random(in: 1...3)
		logName = logName + "\(logNum)"
		let log = SKSpriteNode(imageNamed: logName)
		log.position = onPosition
		log.zPosition = Layer.gameNode
		log.name = name
		let sizeMultiplier: CGFloat = 0.35 * size.height / log.size.height
		let hardMultiplier: CGFloat = 1.0 - CGFloat(score) / 100.0
		log.size = CGSize(width: log.size.width * sizeMultiplier, height: log.size.height * sizeMultiplier * hardMultiplier)
		log.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: log.size.width, height: log.size.height))
		log.physicsBody?.isDynamic = true
		log.physicsBody?.categoryBitMask = PhysicsSettings.log
		log.physicsBody?.contactTestBitMask = PhysicsSettings.frog
		log.physicsBody?.collisionBitMask = PhysicsSettings.none
		log.physicsBody?.usesPreciseCollisionDetection = true
		
		return log
	}
	
	func makeEnemy(coordY: CGFloat, isRotate: Bool) -> SKSpriteNode {
		let imgNum = Int.random(in: 1...3)
		let imageName = "enemy" + "\(imgNum)"
		var image = UIImage(named: imageName)
		if isRotate {
			image = image?.rotate(radians: .pi)
		}
		let enemy = SKSpriteNode(texture: SKTexture(image: image!))
		let sizeMultiplier: CGFloat = 0.1 * size.width / enemy.size.width
		enemy.size = CGSize(width: enemy.size.width * sizeMultiplier, height: enemy.size.height * sizeMultiplier)
		enemy.name = "enemy"
		enemy.zPosition = Layer.gameNode
		let positionX = size.width * CGFloat.random(in: 0.3...0.7)
		enemy.position = CGPoint(x: positionX, y: coordY)
		
		enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
		enemy.physicsBody?.isDynamic = true
		enemy.physicsBody?.categoryBitMask = PhysicsSettings.enemy
//		enemy.physicsBody?.contactTestBitMask = PhysicsSettings.frog
		enemy.physicsBody?.collisionBitMask = PhysicsSettings.none
		enemy.physicsBody?.usesPreciseCollisionDetection = true
		return enemy
	}
}
