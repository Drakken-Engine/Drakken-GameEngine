//
//  Core.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import Metal
import MetalKit

public class Core: NSObject {
	static let sharedInstance: Core = Core()

	private var _device: MTLDevice!
	public static var device: MTLDevice! {
		get { return Core.sharedInstance._device }
		set { Core.sharedInstance._device = newValue}
	}

	private var _commandQueue: MTLCommandQueue!
	public static var commandQueue: MTLCommandQueue! {
		get { return Core.sharedInstance._commandQueue }
		set { Core.sharedInstance._commandQueue = newValue }
	}

	private var _library: MTLLibrary!
	public static var library: MTLLibrary! {
		get { return Core.sharedInstance._library }
		set { Core.sharedInstance._library = newValue }
	}

	private var _screenSize: CGSize!
	public static var screenSize: CGSize! {
		get { return Core.sharedInstance._screenSize }
		set { Core.sharedInstance._screenSize = newValue }
	}

	private var _screenScale: Float!
	public static var screenScale: Float! {
		get { return Core.sharedInstance._screenScale }
		set { Core.sharedInstance._screenScale = newValue }
	}

	static var screenScale_i: Int! {
		get { return Int(Core.sharedInstance._screenScale) }
		set { Core.sharedInstance._screenScale = Float(newValue) }
	}

	public static var drawableSize: CGSize {
		return CGSizeMake(Core.screenSize.width * CGFloat(Core.screenScale),
						  Core.screenSize.height * CGFloat(Core.screenScale))
	}
	
	override init() {
		self._device = MTLCreateSystemDefaultDevice()
		self._commandQueue = _device.newCommandQueue()
		
		let path = NSBundle.mainBundle().pathForResource("default", ofType: "metallib", inDirectory: "Frameworks/Drakken.framework" );
		do
		{
			self._library = try self._device.newLibraryWithFile(path!);
		}
		catch
		{
			print("Failed to load!");
		}

		super.init()
	}
}