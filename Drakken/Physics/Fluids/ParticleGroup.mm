//
//  ParticleGroup.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "ParticleGroup.h"

#import "b2ParticleGroup.h"
#import "b2ParticleSystem.h"
#import "b2Particle.h"
#import "b2Math.h"

@implementation ParticleGroup

+ (void) createWithShape:(Shape *) shape
			  atPosition:(CGPoint) position
				  ofType:(FluidType) type
	   forParticleSystem:(ParticleSystem *) particleSystem
				userData:(void *) userData
{
	b2ParticleGroup * _particleGroup;
	b2ParticleGroupDef _particleGroupDef;
	
	_particleGroupDef.flags = b2_waterParticle;
	_particleGroupDef.position.Set(position.x, position.y);
	_particleGroupDef.shape = (b2Shape *) [shape getShape];
	_particleGroupDef.flags = b2_fixtureContactListenerParticle | b2_fixtureContactFilterParticle;
	
	b2ParticleSystem * _particleSystem = (b2ParticleSystem *)[particleSystem getParticleSystem];
	
	_particleGroup = _particleSystem->CreateParticleGroup(_particleGroupDef);
	_particleGroup->SetUserData(userData);
}

@end
