//
//  GameScene.swift
//  frogGame
//
//  Created by Alex Maltsev on 10/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	lazy var nodeManager = NodeManager(size: size)
	let frog = SKSpriteNode(imageNamed: "frog")
	let rightLogs = SKSpriteNode()
	let leftLogs = SKSpriteNode()
	var isMoving = true
	var score: Int = 0 {
		didSet {
			scoreLabel.text = "\(score)"
		}
	}
	let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
	var gameOverAction: SKAction {
		let loseAction = SKAction.run() { [weak self] in
			guard let `self` = self else { return }
			let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
			let gameOverScene = GameOverScene(size: self.size, won: false)
			self.view?.presentScene(gameOverScene, transition: reveal)
		}
		return loseAction
	}
    
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "bgr")
		background.position = CGPoint(x: size.width / 2, y: size.height / 2)
		background.zPosition = Layer.background
		background.size = size
		addChild(background)
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		setScoreLabel()
		
		run(SKAction.sequence([SKAction.wait(forDuration: 1.7), SKAction.run(setFrog)]))
		let makingLeftLogs = SKAction.repeatForever(SKAction.sequence([SKAction.run(addLeftLog), SKAction.wait(forDuration: 1.0)]))
		let makingRightLogs = SKAction.repeatForever(SKAction.sequence([SKAction.run(addRightLog), SKAction.wait(forDuration: 1.0)]))
		addChild(leftLogs)
		addChild(rightLogs)
		leftLogs.run(makingLeftLogs)
		rightLogs.run(makingRightLogs)
		run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemyBottom), SKAction.run(addEnemyTop), SKAction.wait(forDuration: 1.0)])))
    }
	
	func setScoreLabel() {
		scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
		scoreLabel.fontColor = .red
		scoreLabel.zPosition = Layer.foreground
		scoreLabel.fontSize = 3 * size.width / scoreLabel.fontSize
		scoreLabel.text = "0"
		addChild(scoreLabel)
	}
	
	func addEnemyBottom() {
		let enemy = nodeManager.makeEnemy(coordY: size.height / -2, isRotate: false)
		let movingAction = SKAction.move(to: CGPoint(x: enemy.position.x, y: size.height + size.height / 2), duration: 2.5)
		let moveActionDone = SKAction.removeFromParent()
		addChild(enemy)
		enemy.run(SKAction.sequence([movingAction, moveActionDone]))
	}
	
	func addEnemyTop() {
		let enemy = nodeManager.makeEnemy(coordY: size.height + size.height / 2, isRotate: true)
		let movingAction = SKAction.move(to: CGPoint(x: enemy.position.x, y: size.height / -2), duration: 2.5)
		let moveActionDone = SKAction.removeFromParent()
		addChild(enemy)
		enemy.run(SKAction.sequence([movingAction, moveActionDone]))
	}
	
	func addRightLog() {
		let rightXposition: CGFloat = size.width * 0.93
		let rightLog = nodeManager.makeLog(onPosition: CGPoint(x: rightXposition, y: size.height / -2), name: "rightLog", score: score)
		rightLogs.addChild(rightLog)
		let moveActionRight = SKAction.move(to: CGPoint(x: rightXposition, y: size.height + size.height / 2), duration: 4)
		let actionMoveDone = SKAction.removeFromParent()
		rightLog.run(SKAction.sequence([moveActionRight, actionMoveDone]))
	}
	
	func addLeftLog() {
		let leftXposition: CGFloat = size.width * 0.07
		let leftLog = nodeManager.makeLog(onPosition: CGPoint(x: leftXposition, y: size.height / -2), name: "leftLog", score: score)
		leftLogs.addChild(leftLog)
		let moveActionLeft = SKAction.move(to: CGPoint(x: leftXposition, y: size.height + size.height / 2), duration: 4)
		let actionMoveDone = SKAction.removeFromParent()
		leftLog.run(SKAction.sequence([moveActionLeft, actionMoveDone]))
	}
	
	func setFrog() {
		frog.position = CGPoint(x: size.width * 0.7, y: size.height / 2)
		frog.zPosition = Layer.frog
		frog.name = "frog"
		print(size, frog.size)
//		let sizeMultiplier: CGFloat = 0.1 * size.width / frog.size.width
		let sizeMultiplier: CGFloat = 0.05 * size.height / frog.size.height
		frog.size = CGSize(width: frog.size.width * sizeMultiplier, height: frog.size.height * sizeMultiplier)
		frog.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frog.size.width, height: frog.size.height))
		frog.physicsBody?.isDynamic = true
		frog.physicsBody?.categoryBitMask = PhysicsSettings.frog
		frog.physicsBody?.contactTestBitMask = PhysicsSettings.enemy
		frog.physicsBody?.collisionBitMask = PhysicsSettings.none
		frog.physicsBody?.usesPreciseCollisionDetection = true
		let pointToMove = CGPoint(x: size.width * 0.93, y: frog.position.y)
		let moveAction = SKAction.move(to: pointToMove, duration: 0.3)
		let actionMoveDone = SKAction.removeFromParent()
		addChild(frog)
		frog.run(SKAction.sequence([moveAction, gameOverAction, actionMoveDone]))
	}

}

extension GameScene: SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
		if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}
		if firstBody.categoryBitMask == PhysicsSettings.frog && secondBody.categoryBitMask == PhysicsSettings.log {
			if let log = secondBody.node as? SKSpriteNode {
				stopLogsWith(name: log.name!)
				frog.removeAllActions()
				isMoving = false
			}
		} else if firstBody.categoryBitMask == PhysicsSettings.frog && secondBody.categoryBitMask == PhysicsSettings.enemy {
			if let enemy = secondBody.node as? SKSpriteNode {
				enemy.removeFromParent()
				score += 1
			}
		}
	}
	
	func stopLogsWith(name: String) {
		if name == "leftLog" {
			leftLogs.isPaused = true
		} else if name == "rightLog" {
			rightLogs.isPaused = true
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isMoving {
			let isLeft = frog.position.x < size.width / 2
			let x = size.width * (isLeft ? 0.93 : 0.07)
			let pointToMove = CGPoint(x: x, y: frog.position.y)
			let moveAction = SKAction.move(to: pointToMove, duration: 0.7)
			let actionMoveDone = SKAction.removeFromParent()
			frog.run(SKAction.sequence([moveAction, gameOverAction, actionMoveDone]))
			if isLeft {
				leftLogs.isPaused = false
			} else {
				rightLogs.isPaused = false
			}
			isMoving = true
		}
	}
	
}
