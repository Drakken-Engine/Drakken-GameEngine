//
//  Shape.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <simd/simd.h>

#import "Shape.h"

@interface PolygonShape : Shape

- (instancetype) init:(CGSize) boxSize;

@end
