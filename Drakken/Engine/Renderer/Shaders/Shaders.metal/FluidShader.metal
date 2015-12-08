//
//  BasicShader.metal
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut
{
	float4 position		[[ position ]];
	float3 normal		[[ user(normal) ]];
	float2 texcoord		[[ user(tex_coord) ]];
	float4 color		[[ user(color) ]];
	float  pointSize	[[ point_size ]];
};

struct SharedUniforms
{
	float4x4 projectionMatrix;
	float4x4 viewProjection;
};

struct ModelUniforms
{
	float4x4 modelMatrix;
};

struct Material {
	float specularIntensity;
	float shininess;
};

struct Light
{
	float3 color;
	float ambientIntensity;
	float diffuseIntensity;
	float3 direction;
};

vertex VertexOut fluid_vertex ( constant	SharedUniforms	&sharedUniforms		[[ buffer(0) ]],
								constant	ModelUniforms	&modelUniforms		[[ buffer(1) ]],
								constant	float2			*position			[[ buffer(2) ]],
								constant	float2			*texcoord			[[ buffer(3) ]],
								uint						vid					[[ vertex_id ]])
{
	VertexOut v_out;

	v_out.position =	sharedUniforms.projectionMatrix *
						sharedUniforms.viewProjection *
						modelUniforms.modelMatrix *
						float4(position[vid], 0.0, 1.0);

	v_out.texcoord = texcoord[vid];

	return v_out;
}

fragment float4 fluid_fragment (			VertexOut			vert		[[ stage_in ]],
								constant	float4				*th_color	[[ buffer(0) ]],
											texture2d<float>	texture1	[[ texture(0) ]],
											texture2d<float>	maskTexture	[[ texture(1) ]],
											sampler				s			[[ sampler(0) ]] )
{
	float2 texcoord = vert.texcoord;
	float4 maskColor = maskTexture.sample(s, texcoord);
	if(maskColor.r <= 0.0) {
		discard_fragment();
	}
	
	float n = 0.0;
	
	float width = 2048.0;
	float height = 1536.0;
	
	float dx = (1.0 / width) * 2.0;
	float dy = (1.0 / height) * 2.0;
	
	float4 color = float4(0.0, 0.0, 0.0, 1.0);

	// ---------------------------------------------------------------------------------------
	
	color += texture1.sample(s, texcoord - float2(  0.0 * dx, -5.0 * dy));
	color += texture1.sample(s, texcoord - float2(  0.0 * dx,  5.0 * dy));
	color += texture1.sample(s, texcoord - float2(  0.0 * dx,  0.0 * dy));
	color += texture1.sample(s, texcoord - float2( -5.0 * dx,  0.0 * dy));
	color += texture1.sample(s, texcoord - float2(  5.0 * dx,  0.0 * dy));
	
	n += 5.0;
	
	if (color.r / n <= 0.0)
	{
		discard_fragment();
	}
	else
	{
		color += texture1.sample(s, texcoord - float2( -1.0 * dx, -3.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx, -3.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx, -3.0 * dy));
		// -----------------
		color += texture1.sample(s, texcoord - float2( -1.0 * dx,  3.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx,  3.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx,  3.0 * dy));
		
		n += 6.0;
		
		// ---------------------------------------------------------------------------------------
		
		color += texture1.sample(s, texcoord - float2( -2.0 * dx, -2.0 * dy));
		color += texture1.sample(s, texcoord - float2( -1.0 * dx, -2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx, -2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx, -2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  2.0 * dx, -2.0 * dy));
		// -----------------
		color += texture1.sample(s, texcoord - float2( -2.0 * dx,  2.0 * dy));
		color += texture1.sample(s, texcoord - float2( -1.0 * dx,  2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx,  2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx,  2.0 * dy));
		color += texture1.sample(s, texcoord - float2(  2.0 * dx,  2.0 * dy));
		
		n += 10.0;
		
		// ---------------------------------------------------------------------------------------
		
		// ---------------------------------------------------------------------------------------
		
		color += texture1.sample(s, texcoord - float2( -3.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2( -2.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2( -1.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  2.0 * dx, -1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  3.0 * dx, -1.0 * dy));
		// -----------------
		color += texture1.sample(s, texcoord - float2( -3.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2( -2.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2( -1.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  2.0 * dx,  1.0 * dy));
		color += texture1.sample(s, texcoord - float2(  3.0 * dx,  1.0 * dy));
		
		n += 14.0;
		
		// ---------------------------------------------------------------------------------------
		
		// ---------------------------------------------------------------------------------------
		
		color += texture1.sample(s, texcoord - float2( -3.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2( -2.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2( -1.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2(  0.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2(  1.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2(  2.0 * dx,  0.0 * dy));
		color += texture1.sample(s, texcoord - float2(  3.0 * dx,  0.0 * dy));
		
		n += 7.0;
		
		// ---------------------------------------------------------------------------------------
		
		color /= n;
		
		float range = 0.85;
		
		float grayScale = color.r;
		
		if ((grayScale) >= range)
		{
			color = float4(0.3, 0.3, 0.9, 0.6);
		}
		else if ((grayScale) >= range - 0.1)
		{
			color = float4(0.25, 0.25, 0.9, 0.5);
		}
		else if ((grayScale) >= range - 0.15)
		{
			color = float4(0.225, 0.225, 0.9, 0.4);
		}
		else if ((grayScale) >= range - 0.2)
		{
			color = float4(0.2, 0.2, 0.9, 0.2);
		}
		else {
			discard_fragment();
		}
	}

	return color;
}