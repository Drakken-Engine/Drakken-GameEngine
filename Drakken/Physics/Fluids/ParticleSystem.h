//
//  PHLiquidFun.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "Shape.h"

@interface ParticleSystem : NSObject

- (instancetype) initWithRadius:(float)radius
				dampingStrength:(float)dampingStrength
				   gravityScale:(float)gravityScale
						density:(float)density
						  world:(World *)world;

- (void *) getParticleSystem;
- (int) getParticleCount;
- (void *) getPositionBuffer;
- (void *) getColorBuffer;

@end
