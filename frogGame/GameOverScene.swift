//
//  GameOverScene.swift
//  frogGame
//
//  Created by Alex Maltsev on 10/11/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
	
	init(size: CGSize, won: Bool) {
		super.init(size: size)
		
		backgroundColor = SKColor.white
		let message = "You lose"
		
		let label = SKLabelNode(fontNamed: "Chalkduster")
		label.text = message
		label.fontSize = 0.1 * size.width
		label.fontColor = SKColor.black
		label.position = CGPoint(x: size.width / 2, y: size.height / 2)
		addChild(label)
		
		let againButton = SKLabelNode(fontNamed: "Chalkduster")
		againButton.text = "Play again"
		againButton.name = "againButton"
		againButton.fontSize = 0.06 * size.width
		againButton.fontColor = SKColor.blue
		againButton.position = CGPoint(x: label.position.x, y: label.position.y - 50)
		addChild(againButton)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			let touchedNode = atPoint(location)
			if touchedNode.name == "againButton" {
				run(SKAction.sequence([
					SKAction.run() { [weak self] in
						guard let `self` = self else { return }
						let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
						let scene = GameScene(size: self.size)
						self.view?.presentScene(scene, transition:reveal)
					}
					]))
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
