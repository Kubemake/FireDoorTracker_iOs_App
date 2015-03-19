//
//  UIColor+additionalInitializers.m
//  Tripspotr
//
//  Created by Zhdanov Boris on 19.10.12.
//  Copyright (c) 2012 Polecat. All rights reserved.
//

#import "UIColor+additionalInitializers.h"

@implementation UIColor (additionalInitializers)

#pragma mark - 0..255 per color component format

+ (UIColor *)colorOpaqueUCharWithRed:(unsigned char)red
                               green:(unsigned char)green
                                blue:(unsigned char)blue {
    return [UIColor colorWithUCharRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)colorWithUCharRed:(unsigned char)red
                         green:(unsigned char)green
                          blue:(unsigned char)blue
                         alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:alpha];
}

+ (UIColor *)colorOpaqueWithUCharWhite:(unsigned char)white {
    return [UIColor colorWithUCharWhite:white alpha:1.0f];
}

+ (UIColor *)colorWithUCharWhite:(unsigned char)white alpha:(CGFloat)alpha {
    return [UIColor colorWithWhite:white / 255.0f alpha:alpha];
}

#pragma mark - hex color format

+ (UIColor *)colorOpaqueWithHex:(unsigned int)hexColor
{
    return [self colorWithHex:hexColor alpha:1.0f];
}

+ (UIColor *)colorWithHex:(unsigned int)hexColor alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) ((hexColor & 0xFF0000) >> 16)) / 255.0f
                           green:((float) ((hexColor & 0xFF00) >> 8)) / 255.0f
                            blue:((float) (hexColor & 0xFF)) / 255.0f
                           alpha:alpha];
}

@end
