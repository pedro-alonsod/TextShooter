//
//  GameViewController.swift
//  TextShooter
//
//  Created by Pedro Alonso on 4/1/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
        
//        let scene = GameScene(size: view.frame.size, levelNum: 1)
        let scene = StartScene(size: view.frame.size)
        // configure the view
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        
        /* Sprite Kit applies additional optimizations to improve rendering
         performance */
        skView.ignoresSiblingOrder = true
        
         /* Set the scale mode to scale to fit the window */
        scene.scaleMode = SKSceneScaleMode.aspectFill
        
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
