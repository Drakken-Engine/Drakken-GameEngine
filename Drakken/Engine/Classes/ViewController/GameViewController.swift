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
import MetalKit

internal class GameView: MTKView {
	internal var scene: Scene!
	
	init(frame frameRect: CGRect, device: MTLDevice?, viewController: GameViewController) {
		let scale = UIScreen.mainScreen().scale
		let size = frameRect.size
		
		Core.screenSize = size
		Core.screenScale = Float(scale)
		
		scene = Scene(viewController.beforeUpdate, viewController.afterUpdate)
		
		super.init(frame: frameRect, device: device)
		
		self.colorPixelFormat = .BGRA8Unorm
		self.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
		self.layer.zPosition = -10
	}

	required internal init(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	internal override func drawRect(rect: CGRect) {
		scene.draw(self)
	}
}

public class GameViewController: UIViewController {
	var metalLayer: CAMetalLayer!
	private var _gameView: GameView!
	
	public var scene: Scene {
		return _gameView.scene
	}
	
    override public func viewDidLoad() {
		_gameView = GameView(frame: self.view.frame, device: Core.device, viewController: self)
		
		super.view.layer.addSublayer(_gameView.layer)
		
		super.viewDidLoad()
	}
	
	public func afterUpdate() {
		
	}
	
	public func beforeUpdate() {
		
	}

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override public func prefersStatusBarHidden() -> Bool {
		return true
	}
}
