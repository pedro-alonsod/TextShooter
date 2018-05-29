//
//  GameScene.swift
//  TextShooter
//
//  Created by Pedro Alonso on 4/1/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?

    private var levelNum: Int
    private var playerLives: Int {
        didSet {
            let lives = childNode(withName: "LivesLabel") as! SKLabelNode
            lives.text = "Lives: \(playerLives)"
        }
    }
    private var finished = false
    private let playerNode: PlayerNode = PlayerNode()
    private let enemies = SKNode()
    private let playerBullets = SKNode()
    private let forceFields = SKNode()
    
    @objc class func scene(size: CGSize, levelNum: Int) -> GameScene {
        return GameScene(size: size, levelNum: levelNum)
    }
    
    override convenience init(size: CGSize) {
        self.init(size: size, levelNum: 1)
    }
    
    @objc init(size: CGSize, levelNum: Int) {
          self.levelNum = levelNum
        self.playerLives = 5
        super.init(size: size)
        backgroundColor = SKColor.lightGray
        
        let lives = SKLabelNode(fontNamed: "Courier")
        lives.fontSize = 16
        lives.fontColor = SKColor.black
        lives.name = "LivesLabel"
        lives.text = "Lives: \(self.playerLives)"
        lives.verticalAlignmentMode = .top
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        lives.position = CGPoint(x: frame.size.width, y: frame.size.height)
        
        addChild(lives)
        
        let level = SKLabelNode(fontNamed: "Courier")
        level.fontSize = 16
        level.fontColor = SKColor.black
        level.name = "LevelLabel"
        level.text = "Level: \(self.levelNum)"
        level.verticalAlignmentMode = .top
        level.horizontalAlignmentMode = .left
        level.position = CGPoint(x: 0, y: frame.size.height)
        
        addChild(level)
        
        self.playerNode.position = CGPoint(x: frame.midX, y: frame.height * 0.1)
        addChild(playerNode)
        addChild(enemies)
        spawnEnemies()
        addChild(playerBullets)
        
        addChild(forceFields)
        createForceFields()
//        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
//        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
    }
    
    private func createForceFields() {
        let fieldCount = 3
        let size = frame.size
        let sectionWidth = Int(size.width)/fieldCount
        for i in 0..<fieldCount {
            let x = CGFloat(UInt32(i * sectionWidth) +
                arc4random_uniform(UInt32(sectionWidth)))
            let y = CGFloat(arc4random_uniform(UInt32(size.height * 0.25))
                + UInt32(size.height * 0.25))
            let gravityField = SKFieldNode.radialGravityField()
            gravityField.position = CGPoint(x: x, y: y)
            gravityField.categoryBitMask = GravityFieldCategory
            gravityField.strength = 4
            gravityField.falloff = 2
            gravityField.region = SKRegion(size: CGSize(width:
                size.width * 0.3,
                                                        height: size.height * 0.1))
            forceFields.addChild(gravityField)
            let fieldLocationNode = SKLabelNode(fontNamed: "Courier")
            fieldLocationNode.fontSize = 16
            fieldLocationNode.fontColor = SKColor.red
            fieldLocationNode.name = "GravityField"
            fieldLocationNode.text = "*"
            fieldLocationNode.position = CGPoint(x: x, y: y)
            forceFields.addChild(fieldLocationNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.levelNum = aDecoder.decodeInteger(forKey: "level")
        self.playerLives = aDecoder.decodeInteger(forKey: "playerLives")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(Int(levelNum), forKey: "level")
        aCoder.encode(playerLives, forKey: "playerLives")
    }
//    didMoveToView() method. This method is called whenever the scene is presented in an SKView and it is typically used to make last-minute changes to the scene before it becomes visible.
//    override func didMove(to view: SKView) {
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        for touch in touches {
            let location = touch.location(in: self)
            if location.y < frame.height * 0.2 {
                let target = CGPoint(x: location.x, y: playerNode.position.y)
                playerNode.moveToward(target)
            } else {
                let bullet = BulletNode.bullet(from: playerNode.position, toward: location)
                playerBullets.addChild(bullet)
            }
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        updateBullets()
        if finished {
            
            return
            
        }
        updateBullets()
        updateEnemies()
//        checkForNextLevel()
        
        if (!checkForGameOver()) {
            checkForNextLevel()
        }
    }
    
    private func checkForNextLevel() {
        if enemies.children.isEmpty {
            goToNextLevel()
        }
    }
    
    private func goToNextLevel() {
        finished = true
        let label = SKLabelNode(fontNamed: "Courier")
        label.text = "Level Complete!"
        label.fontColor = SKColor.blue
        label.fontSize = 32
        label.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        addChild(label)
        let nextLevel = GameScene(size: frame.size, levelNum: levelNum + 1)
        nextLevel.playerLives = playerLives
        view!.presentScene(nextLevel, transition: SKTransition.flipHorizontal(withDuration: 1.0))

    }
    
    private func updateBullets() {
        var bulletsToRemove:[BulletNode] = []
        for bullet in playerBullets.children as! [BulletNode] {
            // Remove any bullets that have moved off-screen
            if !frame.contains(bullet.position) {
                // Mark bullet for removal
                bulletsToRemove.append(bullet)
                continue
            }
            // Apply thrust to remaining bullets
            bullet.applyRecurringForce()
        }
        playerBullets.removeChildren(in: bulletsToRemove)
    }
    
    // enemies
    private func spawnEnemies() {
        let count = Int(log(Float(levelNum))) + levelNum
        for _ in 0..<count {
            let enemy = EnemyNode()
            let size = frame.size;
            let x = arc4random_uniform(UInt32(size.width * 0.8)) + UInt32(size.width * 0.1)
            let y = arc4random_uniform(UInt32(size.height * 0.5)) + UInt32(size.height * 0.5)
            enemy.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            enemies.addChild(enemy)
        }
    }
    
    private func updateEnemies() {
        var enemiesToRemove:[EnemyNode] = []
        for node in enemies.children as! [EnemyNode] {
            if !frame.contains(node.position) {
                // Mark enemy for removal
                enemiesToRemove.append(node)
            } }
        enemies.removeChildren(in: enemiesToRemove)
    }
    //MARK: - phyisics delegates
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask {
            // Both bodies are in the same category
            let nodeA = contact.bodyA.node!
            let nodeB = contact.bodyB.node!
            // What do we do with these nodes?
            
            // What do we do with these nodes?
            nodeA.friendlyBumpFrom(nodeB)
            nodeB.friendlyBumpFrom(nodeA)
        } else {
            var attacker: SKNode
            var attackee: SKNode
            if contact.bodyA.categoryBitMask
                > contact.bodyB.categoryBitMask {
                // Body A is attacking Body B
                attacker = contact.bodyA.node!
                attackee = contact.bodyB.node!
            } else {
                // Body B is attacking Body A
                attacker = contact.bodyB.node!
                attackee = contact.bodyA.node!
            }
            if attackee is PlayerNode {
                playerLives -= 1
            }
            // What do we do with the attacker and the attackee?
            // What do we do with the attacker and the attackee?
            attackee.receiveAttacker(attacker, contact: contact)
            playerBullets.removeChildren(in: [attacker])
            enemies.removeChildren(in: [attacker])
        }
    }
    
    private func triggerGameOver() {
        finished = true
        let path = Bundle.main.path(forResource:"EnemyExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!)
            as! SKEmitterNode
        explosion.numParticlesToEmit = 200
        explosion.position = playerNode.position
        scene!.addChild(explosion)
        playerNode.removeFromParent()
        let transition = SKTransition.doorsOpenVertical(withDuration: 1)
        let gameOver = GameOverScene(size: frame.size)
        view!.presentScene(gameOver, transition: transition)
        run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
    }
    
    private func checkForGameOver() -> Bool {
        if playerLives == 0 {
            triggerGameOver()
            return true }
        return false
    }
}
