//
//  Shape.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "PolygonShape.h"
#import "GlobalHeader.h"
#import <Box2D/Box2D.h>

@implementation PolygonShape

- (instancetype) init:(CGSize) boxSize {
	if (self = [super init]) {
		b2PolygonShape * polygonShape = new b2PolygonShape();
		polygonShape->SetAsBox((boxSize.width / 2.0f) / kWorldScale, (boxSize.height / 2.0f) / kWorldScale);
		
		[self setShape:(void*)polygonShape];
	}
	return self;
}

@end
