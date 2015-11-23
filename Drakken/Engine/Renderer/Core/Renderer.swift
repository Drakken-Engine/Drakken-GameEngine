//
//  Renderer.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd
import Metal
import MetalKit

public class Renderer: NSObject {

	var depthStencilState: MTLDepthStencilState!
	var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
	var renderCommandEncoder: MTLRenderCommandEncoder!
	var commandBuffer: MTLCommandBuffer!
	
	var lastRenderPipelineState: MTLRenderPipelineState!

	private var _clearColor: MTLClearColor

	override init () {
		_clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0)

		super.init()
	}
	
	func buildDepthTexture(texture: MTLTexture) -> MTLTexture {
		let textureDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.Depth32Float_Stencil8,
																						width: texture.width,
																						height: texture.height,
																						mipmapped: false)
		let depthTexture = Core.device.newTextureWithDescriptor(textureDescriptor)
		
		return depthTexture
	}
	
	func buildDepthStencilDescriptor() -> MTLDepthStencilDescriptor {
		let dsDescriptor = MTLDepthStencilDescriptor();
		dsDescriptor.depthCompareFunction = .Less
		dsDescriptor.depthWriteEnabled = true
		dsDescriptor.frontFaceStencil.stencilCompareFunction = .Equal
		dsDescriptor.frontFaceStencil.stencilFailureOperation = .Keep
		dsDescriptor.frontFaceStencil.depthFailureOperation = .IncrementClamp
		dsDescriptor.frontFaceStencil.depthStencilPassOperation = .IncrementClamp
		dsDescriptor.frontFaceStencil.readMask = 0x1
		dsDescriptor.frontFaceStencil.writeMask = 0x1
		dsDescriptor.backFaceStencil = nil
		
		return dsDescriptor
	}
	
	func buildRenderPassDescriptor(texture: MTLTexture) -> MTLRenderPassDescriptor {
		let renderPassDescriptor = MTLRenderPassDescriptor()
		let depthStencilTexture = buildDepthTexture(texture)
		
		renderPassDescriptor.colorAttachments[0].texture = texture
		renderPassDescriptor.colorAttachments[0].loadAction = .Clear
		renderPassDescriptor.colorAttachments[0].storeAction = .Store
		renderPassDescriptor.colorAttachments[0].clearColor = _clearColor
		renderPassDescriptor.depthAttachment.texture = depthStencilTexture
		renderPassDescriptor.stencilAttachment.texture = depthStencilTexture
		
		return renderPassDescriptor
	}
	
	func buildDepthStencil() -> MTLDepthStencilState {
		return Core.device.newDepthStencilStateWithDescriptor(buildDepthStencilDescriptor())
	}

	func setClearColor(r r: Double, g: Double, b: Double, a: Double) {
		_clearColor = MTLClearColorMake(r, g, b, a)
	}
	
	func startFrame(drawable drawable: CAMetalDrawable) {
		startFrame(texture: drawable.texture)
	}

	func startFrame(texture texture: MTLTexture) {
		commandBuffer = Core.commandQueue.commandBuffer()

		let descriptor = buildRenderPassDescriptor(texture)
		renderCommandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(descriptor)

		renderCommandEncoder.setDepthStencilState(buildDepthStencil())
		renderCommandEncoder.setFrontFacingWinding(.CounterClockwise)
		renderCommandEncoder.setCullMode(.Front)
	}

	func endFrame() {
		renderCommandEncoder.endEncoding()
		commandBuffer.commit()

		lastRenderPipelineState = nil
	}
	
	func endFrame(drawable drawable: CAMetalDrawable) {
		renderCommandEncoder.endEncoding()
		commandBuffer.presentDrawable(drawable)
		commandBuffer.commit()

		lastRenderPipelineState = nil
	}
}
