//
// Created by Allison Lindner on 28/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import "Rigidbody.h"
#import "BodyType.h"

@class Texture;

@interface MaskTexture : NSObject

+ (id<MTLTexture>)generateWithCircleAtPosition:(CGPoint)position withRadius:(int)radius withTextureSize:(CGSize)size;
+ (Texture *)cropCircleAtPosition:(CGPoint)position withRadius:(int)radius fromMetalTexture:(id<MTLTexture>)metalTexture;
+ (Rigidbody *)createRigidBodyInWorld:(World *) world
				   withEdgesOfTexture:(id<MTLTexture>) metalTexture
							  Density:(float) density
							 Friction:(float) friction
						  Restitution:(float) restitution;
+ (NSArray *) getContoursFromMaskTexture:(id<MTLTexture>) metalTexture withGridSize:(CGSize) size;

@end