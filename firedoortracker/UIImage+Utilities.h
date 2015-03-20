//
//  UIImage+Utilities.h
//  Yep
//
//  Created by Dmitry Vorobjov on 9/4/13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Inspection.h"

@interface UIImage (Utilities)

+ (UIImage *)imageWithColor:(UIColor *)color;

//Image For Door Review
+ (UIImage *)imageForReviewStaton:(inspectionStatus)status;

@end
