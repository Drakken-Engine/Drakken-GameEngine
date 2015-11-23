//
//  Fixture.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "Fixture.h"
#import <Box2D/Box2D.h>

#import "World.h"
#import "b2Fixture.h"
#import "b2PolygonShape.h"
#import "b2Fixture.h"

@implementation Fixture {
	b2Fixture * _fixture;
	b2FixtureDef _fixtureDef;
}

- (instancetype)initWithShape:(Shape *) shape Density:(float) density Friction:(float) friction Restitution:(float) restitution {
	if(self = [super init]) {
		_fixtureDef = b2FixtureDef();
		_fixtureDef.shape = (b2PolygonShape *)[shape getShape];
		_fixtureDef.density = density;
		_fixtureDef.friction = friction;
		_fixtureDef.restitution = restitution;
	}
	return self;
}

- (void) createForBody:(Body *) body {
	_fixture = ((b2Body*)[body getBody])->CreateFixture(&_fixtureDef);
}

@end
