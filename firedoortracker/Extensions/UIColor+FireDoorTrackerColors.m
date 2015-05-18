//
//  UIColor+FireDoorTrackerColors.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import "UIColor+FireDoorTrackerColors.h"

@implementation UIColor (Extension)

+ (UIColor *)FDTDarkGrayColor {
    return [UIColor colorWithRed:94/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f];
}

+ (UIColor *)FDTMediumGayColor {
    return [UIColor colorWithRed:144/255.0f green:144/255.0f blue:144/255.0f alpha:1.0f];
}

+ (UIColor *)FDTLightGrayColor {
    return [UIColor colorWithRed:219/255.0f green:219/255.0f blue:219/255.0f alpha:1.0f];
}

+ (UIColor *)FDTDeepBlueColor {
    return [UIColor colorWithRed:47/255.0f green:81/255.0f blue:152/255.0f alpha:1.0f];
}

//Door Review Colors
+ (UIColor *)FDTcompliant {
    return [UIColor colorWithRed:33/255.0f green:138/255.0f blue:47/255.0f alpha:1.0f];
}

+ (UIColor *)FDTmaintenance {
    return [UIColor colorWithRed:0/255.0f green:51/255.0f blue:204/255.0f alpha:1.0f];
}

+ (UIColor *)FDTrepair {
    return [UIColor colorWithRed:255/255.0f green:255/255.0f blue:51/255.0f alpha:1.0f];
}

+ (UIColor *)FDTreplace {
    return [UIColor colorWithRed:212/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
}

+ (UIColor *)FDTrecertify {
    return [UIColor colorWithRed:154/255.0f green:0/255.0f blue:205/255.0f alpha:1.0f];
}

@end
