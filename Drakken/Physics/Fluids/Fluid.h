//
//  Fluid.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "World.h"
#import "FluidType.h"
#import "Shape.h"

@protocol Component;

@interface Fluid : NSObject

- (instancetype)initWithRadius:(float)radius
			   dampingStrength:(float)dampingStrength
				  gravityScale:(float)gravityScale
					   density:(float)density
						 world:(World *)world
					 component:(id<Component>) component;

- (void) addBoxShapeFluidWithSize:(CGSize) size
					   atPosition:(CGPoint) position
						   ofType:(FluidType) type;

- (void) addCircleShapeFluidWithRadius:(float) radius
							atPosition:(CGPoint) position
								ofType:(FluidType) type;

- (void *) getPositionBuffer;
- (int) getParticleCount;
@end
