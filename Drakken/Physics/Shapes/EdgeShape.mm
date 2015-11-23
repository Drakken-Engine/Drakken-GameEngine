//
//  EdgeShape.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 17/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "EdgeShape.h"
#import "GlobalHeader.h"
#import "b2Math.h"
#import "b2EdgeShape.h"
#import <Box2D/Box2D.h>

@implementation EdgeShape

- (instancetype) initWithVector1:(CGPoint) v1 andVector2:(CGPoint) v2 {
	if(self = [super init]) {
		b2EdgeShape * edgeShape = new b2EdgeShape();
		edgeShape->Set(b2Vec2(v1.x / kWorldScale, v1.y / kWorldScale), b2Vec2(v2.x / kWorldScale, v2.y / kWorldScale));
		
		[self setShape:(void *)edgeShape];
	}
	return self;
}

@end
