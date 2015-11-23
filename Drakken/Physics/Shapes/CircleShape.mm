//
//  CircleShape.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "CircleShape.h"
#import "GlobalHeader.h"
#import <Box2D/Box2D.h>

@implementation CircleShape

- (instancetype) init:(CGPoint) center Radius:(float) radius {
	if (self = [super init]) {
		b2CircleShape * circleShape = new b2CircleShape();
		circleShape->m_p = b2Vec2(center.x / kWorldScale, center.y / kWorldScale);
		circleShape->m_radius = radius / kWorldScale;
		
		[self setShape:(void*)circleShape];
	}
	return self;
}

- (instancetype) init:(float) radius {
	if (self = [super init]) {
		b2CircleShape * circleShape = new b2CircleShape();
		circleShape->m_radius = radius;
		
		[self setShape:(void*)circleShape];
	}
	return self;
}

@end
