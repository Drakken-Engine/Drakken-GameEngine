//
//  World.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 14/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "World.h"
#import "CollisionListener.h"
#import "b2World.h"
#import "b2WorldCallbacks.h"
#import <Box2D/Box2D.h>

@implementation World {
	b2World * _world;
	CollisionListener _listener;
}

- (instancetype) initWithGravity:(CGVector) gravity {
	if(self = [super init]) {
		_world = new b2World(b2Vec2(gravity.dx, gravity.dy));
		_world->SetGravity(b2Vec2(gravity.dx, gravity.dy));
		_world->SetAllowSleeping(true);

		_listener = CollisionListener();
		_world->SetContactListener(&_listener);
	}
	return self;
}

- (void) setGravity:(CGVector)gravity {
	_world->SetGravity(b2Vec2(gravity.dx, gravity.dy));
}

- (void*) getWorld {
	return (void*) _world;
}

- (void) step {
	_world->Step(0.016f, 3, 3);
}

- (void) step:(float) timeInterval {
	_world->Step(timeInterval, 3, 3);
}

- (void) destroy {
	_world->~b2World();
	_world = nullptr;
}

@end
