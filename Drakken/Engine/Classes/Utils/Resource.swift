//
// Created by Allison Lindner on 19/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import MetalKit
import Metal

public class Resource {
	private static var _loadedTextures: [String: MTLTexture] = [String: MTLTexture]()

	public class func loadTexture(fileName: String) -> MTLTexture {
		if _loadedTextures[fileName] == nil {
			do {
				var image = UIImage(named: fileName, inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
				if image == nil {
					for bundle in NSBundle.allFrameworks() {
						image = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
						if image != nil {
							break
						}
					}
				}
				
				let textureLoader = MTKTextureLoader(device: Core.device)
				let texture: MTLTexture = try textureLoader.newTextureWithCGImage(image!.CGImage!, options: .None)
				_loadedTextures[fileName] = texture.newTextureViewWithPixelFormat(.BGRA8Unorm)
			} catch {
				print(error)
				return loadTexture("white_pixel.png")
			}
		}

		return _loadedTextures[fileName]!
	}

	public class func deallocTexture(fileName: String) {
		_loadedTextures.removeValueForKey(fileName)
	}

	public class func emptyTexture(size: CGSize) -> MTLTexture {
		let screenScale = Core.screenScale
		let textureDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(
		MTLPixelFormat.BGRA8Unorm,
				width: 	Int(size.width) 	* Int(screenScale),
				height: Int(size.height) 	* Int(screenScale),
				mipmapped: false
		)

		return Core.device.newTextureWithDescriptor(textureDescriptor)
	}
}
