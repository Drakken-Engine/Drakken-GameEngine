//
//  ParticleGroup.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ParticleSystem.h"
#import "FluidType.h"
#import "Shape.h"

@interface ParticleGroup : NSObject

+ (void) createWithShape:(Shape *) shape
			  atPosition:(CGPoint) position
				  ofType:(FluidType) type
	   forParticleSystem:(ParticleSystem *) particleSystem
				userData:(void *) userData;

+ (void) createWithShape:(Shape *) shape
			  atPosition:(CGPoint) position
				  ofType:(FluidType) type
	   forParticleSystem:(ParticleSystem *) particleSystem
				userData:(void *) userData
				lifetime:(float) lifetime;

@end
