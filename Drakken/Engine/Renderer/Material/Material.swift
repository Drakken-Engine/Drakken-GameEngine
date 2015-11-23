//
//  Material.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 05/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import Metal
import MetalKit
import simd

public class Material: NSObject {
	
	private var fragmentShaderFunction: MTLFunction!
	private var vertexShaderFunction: MTLFunction!

	internal var renderPipelineState: MTLRenderPipelineState!
	
	internal var materialPropertiesUniform: MaterialProperties!
	internal var materialPropertiesUniformBuffer: MTLBuffer!

	private var _shaderReflextion: MTLRenderPipelineReflection?
	
	init (vertex: String, fragment: String) {
		super.init()
		
		fragmentShaderFunction	= Core.library.newFunctionWithName(fragment);
		vertexShaderFunction	= Core.library.newFunctionWithName(vertex);
		
		let renderPipelineStateDescriptor = buildRenderPipelineDescriptor()
		
		do {
			renderPipelineState = try Core.device.newRenderPipelineStateWithDescriptor(
					renderPipelineStateDescriptor,
					options: .BufferTypeInfo,
					reflection: &_shaderReflextion
			)
		} catch {
			renderPipelineState = nil
			print("Error occurred when creating render pipeline state: \(error)")
		}

		print("Fragment Arguments:")
		for fragmentArgs: MTLArgument in _shaderReflextion!.fragmentArguments! {
			print("Name: \(fragmentArgs.name) - Index: \(fragmentArgs.index)")
		}

		print("Vertex Arguments:")
		for vertexArgs: MTLArgument in _shaderReflextion!.vertexArguments! {
			print("Name: \(vertexArgs.name) - Index: \(vertexArgs.index)")
		}
	}
	
	func buildRenderPipelineDescriptor() -> MTLRenderPipelineDescriptor {
		let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
		
		renderPipelineDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		renderPipelineDescriptor.colorAttachments[0].blendingEnabled = true
		renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.Add
		renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.SourceAlpha
		renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.SourceAlpha
		renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		renderPipelineDescriptor.depthAttachmentPixelFormat = .Depth32Float_Stencil8
		renderPipelineDescriptor.stencilAttachmentPixelFormat = .Depth32Float_Stencil8
		
		renderPipelineDescriptor.fragmentFunction = fragmentShaderFunction
		renderPipelineDescriptor.vertexFunction = vertexShaderFunction
		
		return renderPipelineDescriptor
	}
}