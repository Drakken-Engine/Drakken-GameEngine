//
//  TextureBuffer.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 30/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import simd

class TextureBuffer {
	var texture: MTLTexture
	var index: Int
	
	init(texture: Texture, index: Int) {
		self.texture = texture.texture
		self.index = index
	}
};

public class Texture: NSObject, Bufferable {
	internal var index: Int

	private var _texture: MTLTexture
	public var texture: MTLTexture {
		return _texture
	}

	public var size: Size2D {
		return Size2D(texture.width, texture.height)
	}

	public init(size: Size2D) {
		_texture = Resource.emptyTexture(size.CGSize)
		index = -1
	}

	public init(metalTexture texture: MTLTexture) {
		_texture = texture
		index = -1

		super.init()
	}

	public convenience init(fileName file: String, fileExtension ext: String = ".png") {
		if ext.containsString(".") {
			self.init(metalTexture: Resource.loadTexture(file + ext))
		} else {
			self.init(metalTexture: Resource.loadTexture(file + "." + ext))
		}
	}

	public func loadFromFile(fileName file: String, fileExtension ext: String = ".png") {
		if ext.containsString(".") {
			_texture = Resource.loadTexture(file + ext)
		} else {
			_texture = Resource.loadTexture(file + "." + ext)
		}
	}

	internal func setupOnRenderer(renderer: Renderer) {
		renderer.renderCommandEncoder.setFragmentTexture(_texture, atIndex: index)
	}
}