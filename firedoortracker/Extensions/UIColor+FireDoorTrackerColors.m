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
    return [UIColor colorWithRed:198/255.0f green:239/255.0f blue:206/255.0f alpha:1.0f];
}

+ (UIColor *)FDTmaintenance {
    return [UIColor colorWithRed:247/255.0f green:150/255.0f blue:70/255.0f alpha:1.0f];
}

+ (UIColor *)FDTrepair {
    return [UIColor colorWithRed:75/255.0f green:172/255.0f blue:198/255.0f alpha:1.0f];
}

+ (UIColor *)FDTreplace {
    return [UIColor colorWithRed:128/255.0f green:100/255.0f blue:162/255.0f alpha:1.0f];
}

+ (UIColor *)FDTrecertify {
    return [UIColor colorWithRed:255/255.0f green:199/255.0f blue:206/255.0f alpha:1.0f];
}

@end
