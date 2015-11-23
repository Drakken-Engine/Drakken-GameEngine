//
//  EdgeShape.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 17/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Shape.h"

@interface EdgeShape : Shape

- (instancetype) initWithVector1:(CGPoint) v1 andVector2:(CGPoint) v2;

@end
