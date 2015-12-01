//
//  PHLiquidFun.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "ParticleSystem.h"
#import "b2ParticleSystem.h"
#import "b2World.h"

@implementation ParticleSystem {
	b2ParticleSystem * _particleSystem;
	b2ParticleSystemDef _particleSystemDef;
}

- (instancetype) initWithRadius:(float)radius
				dampingStrength:(float)dampingStrength
				   gravityScale:(float)gravityScale
						density:(float)density
						  world:(World *)world
{
	self = [super init];
	if (self) {
		_particleSystemDef.radius = radius;
		_particleSystemDef.dampingStrength = dampingStrength;
		_particleSystemDef.gravityScale = gravityScale;
		_particleSystemDef.density = density;
		
		b2World * _world = (b2World*)[world getWorld];
		_particleSystem = _world->CreateParticleSystem(&_particleSystemDef);
	}
	return self;
}

- (void *) getParticleSystem {
	return (void *) _particleSystem;
}

- (int) getParticleCount {
	return _particleSystem->GetParticleCount();
}

- (void *) getPositionBuffer {
	return (void *) _particleSystem->GetPositionBuffer();
}

- (void *) getColorBuffer {
	return (void *) _particleSystem->GetColorBuffer();
}

- (void) removeAll {
	if ([self getParticleCount] > 0) {
		for(int i = 0; i < [self getParticleCount]; i++) {
			_particleSystem->DestroyParticle(i);
		}
	}
}

@end
