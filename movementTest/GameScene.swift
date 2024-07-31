//
//  GameScene.swift
//  movementTest
//
//  Created by Laura C. Balbachan dos Santos on 17/07/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: Variables
    var player: SKSpriteNode!
    let floor = SKSpriteNode(imageNamed: "floor")
    let leftMovementArea = SKShapeNode()
    let rightMovementArea = SKShapeNode()
    var isLeft: Bool = false
    var isRight: Bool = false
    
    var sceneCamera: SKCameraNode = SKCameraNode()
    
    private var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "PlayerIdle")
    }
    
    private var playerTexture: SKTexture {
        return playerAtlas.textureNamed("idle")
    }
    
    private var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("idle1"),
            playerAtlas.textureNamed("idle2"),
            playerAtlas.textureNamed("idle3"),
            playerAtlas.textureNamed("idle4"),
            playerAtlas.textureNamed("idle5"),
            playerAtlas.textureNamed("idle6"),
            playerAtlas.textureNamed("idle7"),
            playerAtlas.textureNamed("idle8"),
            playerAtlas.textureNamed("idle9"),
            playerAtlas.textureNamed("idle10"),
            playerAtlas.textureNamed("idle11"),
            playerAtlas.textureNamed("idle12"),
            playerAtlas.textureNamed("idle13"),
            playerAtlas.textureNamed("idle14"),
            playerAtlas.textureNamed("idle15")
        ]
    }
    
    enum bitMasks: UInt32 {
        case player = 0b1
        case ground = 0b10
    }
    
    // MARK: Default functions
    override func didMove(to view: SKView) {
        camera = sceneCamera
        
        setEnvironment()
        setPlayer()
        setIdleAnimation()
        setMovementButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(leftMovementArea) {
            player.position = CGPoint(x: player.position.x-100, y: player.position.y)
        } else if tappedNodes.contains(rightMovementArea) {
            player.position = CGPoint(x: player.position.x+100, y: player.position.y)
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        camera?.position.x = player.position.x
        camera?.position.y = player.position.y + 85
        
        leftMovementArea.position.x = player.position.x - 300
        leftMovementArea.position.y = player.position.y - 70
        
        rightMovementArea.position.x = player.position.x - 220
        rightMovementArea.position.y = player.position.y - 70
    }
    
    func playerHit(_node: SKNode) {
        player.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
    // Colision
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerHit(_node: nodeB)
        } else {
            playerHit(_node: nodeA)
        }
    }
    
    // MARK: Set ups
    
    // Environment
    func setEnvironment() {
        createSky()
        createMoon()
        createFloor()
    }
    
    func createSky() {
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.zPosition = -1
        
        addChild(sky)
    }
    
    func createFloor() {
        floor.position = CGPoint(x: 0, y: -150)
        floor.size = CGSize(width: 844, height: 50)
        floor.zPosition = 0
        
        floor.physicsBody = SKPhysicsBody(texture: floor.texture!, size: floor.size)
        floor.physicsBody?.categoryBitMask = bitMasks.ground.rawValue
        floor.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        floor.physicsBody?.collisionBitMask = bitMasks.player.rawValue
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.friction = 1
        
        addChild(floor)
    }
    
    func createMoon() {
        let moonlight = SKLightNode()
        let moon = SKSpriteNode(imageNamed: "moon")
        let y = 80
        
        moonlight.position = CGPoint(x: 0, y: y)
        moonlight.setScale(4)
        moonlight.zPosition = 0
        moonlight.categoryBitMask = 1
        moonlight.lightColor = .white
        moonlight.ambientColor = .black
    
        
        moon.position = CGPoint(x: 0, y: y)
        moon.size = CGSize(width: 70, height: 70)
        moon.zPosition = 0
        moon.lightingBitMask = 3
        
        addChild(moonlight)
        addChild(moon)
    }
    
    // Player
    func setPlayer() {
        player = SKSpriteNode(texture: playerTexture, size: CGSize(width: 72, height: 79))
        player.position = CGPoint(x: 0, y: 0)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.zPosition = 1
        
        player.lightingBitMask = 3
        player.shadowedBitMask = 3
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = bitMasks.player.rawValue
        player.physicsBody?.contactTestBitMask = bitMasks.ground.rawValue
        player.physicsBody?.collisionBitMask = bitMasks.ground.rawValue
        player.physicsBody?.allowsRotation = false
        
        player.physicsBody?.linearDamping = 0
        
        addChild(player)
    }
    
    func setIdleAnimation() {
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.25)
        player.run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
    }
    
    // Movement
    func setMovementButtons() {
        rightMovementArea.path = UIBezierPath(rect: CGRect(x: player.position.x, y: player.position.y, width: 50, height: 50)).cgPath
        rightMovementArea.zPosition = 100
        rightMovementArea.fillColor = UIColor.gray
        rightMovementArea.lineWidth = 0
        
        leftMovementArea.path = UIBezierPath(rect: CGRect(x: player.position.x, y: player.position.y, width: 50, height: 50)).cgPath
        leftMovementArea.zPosition = 100
        leftMovementArea.fillColor = UIColor.gray
        leftMovementArea.lineWidth = 0
        
        addChild(rightMovementArea)
        addChild(leftMovementArea)
    }
    
}
