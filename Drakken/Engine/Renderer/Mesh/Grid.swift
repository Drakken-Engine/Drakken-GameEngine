//
//  Grid.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd

public class Grid: Mesh {
	
	private var core: Core!
	private var width: Int! = 0
	private var height: Int! = 0
	private var depth: Int! = 0
	private var textureRepeatXCount: Int! = 0
	private var textureRepeatYCount: Int! = 0

	public init (materialName: String, width: Int, height: Int, depth: Int, textureRepeatXCount: Int, textureRepeatYCount: Int) {
		self.width = width
		self.depth = depth
		self.height = height

		self.textureRepeatXCount = textureRepeatXCount
		self.textureRepeatYCount = textureRepeatYCount

		super.init(materialName: materialName)

		self.textureRepeat = float2(Float(textureRepeatXCount), Float(textureRepeatYCount))
		self.repeatMask = false
	}

	public convenience init(width: Int, depth: Int, textureRepeatXCount: Int, textureRepeatYCount: Int) {
		self.init (
			materialName: "basic",
			width: width,
			height: 0,
			depth: depth,
			textureRepeatXCount: textureRepeatXCount,
			textureRepeatYCount: textureRepeatYCount
		)
		createWithDepth()
	}
	
	public convenience init(width: Int, height: Int, textureRepeatXCount: Int, textureRepeatYCount: Int) {
		self.init (
				materialName: "basic",
				width: width,
				height: height,
				depth: 0,
				textureRepeatXCount: textureRepeatXCount,
				textureRepeatYCount: textureRepeatYCount
		)
		createWithHeight()
	}
	
	public convenience init(materialName: String, width: Int, depth: Int, textureRepeatXCount: Int, textureRepeatYCount: Int) {
		self.init (
				materialName: materialName,
				width: width,
				height: 0,
				depth: depth,
				textureRepeatXCount: textureRepeatXCount,
				textureRepeatYCount: textureRepeatYCount
		)
		createWithDepth()
	}
	
	public convenience init(materialName: String, width: Int, height: Int, textureRepeatXCount: Int, textureRepeatYCount: Int) {
		self.init (
				materialName: materialName,
				width: width,
				height: height,
				depth: 0,
				textureRepeatXCount: textureRepeatXCount,
				textureRepeatYCount: textureRepeatYCount
		)
		createWithHeight()
	}
	
	internal func createWithDepth() {
		let hW = (Float(width) - 1.0) / 2.0
		let hD = (Float(depth) - 1.0) / 2.0
		
		//Tamanho de cada passo da textura
		let textureRepeatUnitX = (Float(textureRepeatXCount) / Float(width - 1))
		let textureRepeatUnitY = (Float(textureRepeatYCount) / Float(depth - 1))
		
		for(var z = 0; z < depth; z++) {
			for(var x = 0; x < width; x++) {
				
				positions.append(	float3(	x: Float(x) - hW,
											y: Float(0.0),
											z: Float(z) - hD))
				
				normals.append(		float3( x: 0.0,
											y: 1.0,
											z: 0.0))
				
				texcoords.append(	float2( x: textureRepeatUnitX * Float(x),
											y: textureRepeatUnitY * Float(z)))
			}
		}
		
		for(var z = 0; z < depth - 1; z++) {
			for(var x = 0; x < width - 1; x++) {
				
				let zero  = UInt32(x + z * width)
				let one   = UInt32((x + 1) + z * width)
				let two   = UInt32(x + (z + 1) * width)
				let three = UInt32((x + 1) + (z + 1) * width)
				
				indices.append(one)
				indices.append(three)
				indices.append(zero)
				
				indices.append(three)
				indices.append(two)
				indices.append(zero)
			}
		}
	}
	
	internal func createWithHeight() {
		let hW: Float = (Float(width) - 1.0) / 2.0
		let hH: Float = (Float(height) - 1.0) / 2.0
		
		//Tamanho de cada passo da textura
		let textureRepeatUnitX = (Float(textureRepeatXCount) / Float(width - 1))
		let textureRepeatUnitY = (Float(textureRepeatYCount) / Float(height - 1))
		
		for(var y = 0; y < height; y++) {
			for(var x = 0; x < width; x++) {
				
				
				positions.append(	float3(	x: Float(x) - hW,
											y: Float(y) - hH,
											z: 0.0))
				
				normals.append(		float3(	x: 0.0,
											y: 0.0,
											z: 1.0))
				
				texcoords.append(	float2( x: textureRepeatUnitX * Float(x),
											y: textureRepeatUnitY * Float(y)))
			}
		}
		
		var count = 0;
		for(var y = 0; y < height - 1; y++) {
			for(var x = 0; x < width - 1; x++) {
				
				let zero =	UInt32(x + y * width)
				let one =	UInt32((x + 1) + y * width)
				let two =	UInt32(x + (y + 1) * width)
				let three = UInt32((x + 1) + (y + 1) * width)
				
				indices.insert(zero, atIndex: count++)
				indices.insert(three, atIndex: count++)
				indices.insert(one, atIndex: count++)
				
				indices.insert(zero, atIndex: count++)
				indices.insert(two, atIndex: count++)
				indices.insert(three, atIndex: count++)
			}
		}
	}
}