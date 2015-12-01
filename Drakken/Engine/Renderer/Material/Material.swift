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
		let rpDescriptor = MTLRenderPipelineDescriptor()
		
		rpDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		rpDescriptor.colorAttachments[0].blendingEnabled = true
		
		rpDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.Add
		rpDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.Add
		
		rpDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.SourceAlpha
		rpDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		rpDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.SourceAlpha
		rpDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		rpDescriptor.depthAttachmentPixelFormat = .Depth32Float_Stencil8
		rpDescriptor.stencilAttachmentPixelFormat = .Depth32Float_Stencil8
		
		rpDescriptor.fragmentFunction = fragmentShaderFunction
		rpDescriptor.vertexFunction = vertexShaderFunction
		
		return rpDescriptor
	}
}