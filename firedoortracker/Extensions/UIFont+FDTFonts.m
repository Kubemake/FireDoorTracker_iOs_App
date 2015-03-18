//
//  UIFont+FDTFonts.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import "UIFont+FDTFonts.h"

@implementation UIFont(Extenstion)

+ (UIFont *)FDTTimesNewRomanBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:size];
}

+ (UIFont *)FDTTimesNewRomanRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"TimesNewRomanPSMT" size:size];
}

@end
