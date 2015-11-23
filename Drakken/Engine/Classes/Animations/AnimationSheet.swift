//
// Created by Allison Lindner on 11/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

public class AnimationSheet {
	private var _name: String
	private var _sheet: Texture
	private var _textures: [Texture]

	public init(name: String, animationSheet: Texture, sliceSize: Size2D)
	{
		_name = name
		_sheet = animationSheet
		_textures = [Texture]()

		self.separateAnimationSheet(animationSheet, sliceSize)
	}

	private func separateAnimationSheet(animationSheet: Texture, _ sliceSize: Size2D) {
		let maxStepX = animationSheet.size.width_i/sliceSize.width_i
		let maxStepY = animationSheet.size.height_i/sliceSize.height_i

		let sliceRegion = MTLRegionMake2D(
			0,
			0,
			sliceSize.width_i,
			sliceSize.height_i
		)

		var count: Int = 0
		for var y = maxStepY - 1; y >= 0; y-- {
			for var x = 0; x < maxStepX; x++ {
				let texture = Texture(size: sliceSize / Core.screenScale)

				var bytes = [UInt32](count: 4 * sizeof(UInt32) * sliceSize.width_i * sliceSize.height_i, repeatedValue: 0)
				let region = MTLRegionMake2D(
					x * sliceSize.width_i,
					y * sliceSize.height_i,
					sliceSize.width_i,
					sliceSize.height_i
				)

				animationSheet.texture.getBytes(
					&bytes,
					bytesPerRow: 4 * sizeof(UInt32) * sliceSize.width_i,
					fromRegion: region,
					mipmapLevel: 0
				)

				texture.texture.replaceRegion(
					sliceRegion,
					mipmapLevel: 0,
					withBytes: bytes,
					bytesPerRow: 4 * sizeof(UInt32) * sliceSize.width_i
				)

				_textures.insert(texture, atIndex: count)
				count++
			}
		}
	}

	public func getTextureAtFrame(frame: Int) -> Texture {
		return _textures[frame]
	}
}