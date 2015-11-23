//
//  GameViewController.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 04/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd
import Metal

public class GameViewController: UIViewController {
	
	var metalLayer: CAMetalLayer!
	
	public var scene: Scene!
	
	func setupMetalLayer() {
		metalLayer = CAMetalLayer()
		metalLayer.device = Core.device
		metalLayer.framebufferOnly = true
		metalLayer.frame = self.view.frame
		
		let scale = UIScreen.mainScreen().scale
		let size = self.view.bounds.size

		Core.screenSize = size
		Core.screenScale = Float(scale)
			
		metalLayer.drawableSize = CGSize(width: size.width * scale,
										 height: size.height * scale)

		self.view.layer.addSublayer(metalLayer)
	}
	
    override public func viewDidLoad() {
		super.viewDidLoad()
		
		setupMetalLayer()
		scene = Scene()

		scene.setupGameLoop(metalLayer)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override public func prefersStatusBarHidden() -> Bool {
		return true
	}
}
