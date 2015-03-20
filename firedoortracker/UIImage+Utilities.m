//
//  UIImage+Utilities.m
//  Yep
//
//  Created by Dmitry Vorobjov on 9/4/13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

+ (UIImage *)imageWithColor:(UIColor *)color {
    if (! color) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageForReviewStaton:(inspectionStatus)status {
    switch (status) {
        case inspectionStatusCompliant:
            return [UIImage imageNamed:@"compliantIcon"];
        case inspectionStatusMaintenance:
            return [UIImage imageNamed:@"maintenanceIcon"];
        case inspectionStatusRepair:
            return [UIImage imageNamed:@"repairIcon"];
        case inspectionStatusReplace:
            return [UIImage imageNamed:@"replaceIcon"];
        case inspectionStatusRecertify:
            return [UIImage imageNamed:@"recertifyIcon"];
        default:
            return nil;
    }
}

@end
