//
//  UIColor+additionalInitializers.h
//  Tripspotr
//
//  Created by Zhdanov Boris on 19.10.12.
//  Copyright (c) 2012 Polecat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (additionalInitializers)

#pragma mark - 0..255 per color component format

+ (UIColor *)colorOpaqueUCharWithRed:(unsigned char)red
                               green:(unsigned char)green
                                blue:(unsigned char)blue;

+ (UIColor *)colorWithUCharRed:(unsigned char)red
                         green:(unsigned char)green
                          blue:(unsigned char)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorOpaqueWithUCharWhite:(unsigned char)white;

+ (UIColor *)colorWithUCharWhite:(unsigned char)white
                           alpha:(CGFloat)alpha;

#pragma mark - hex color format

+ (UIColor *)colorOpaqueWithHex:(unsigned int)hexColor;

+ (UIColor *)colorWithHex:(unsigned int)hexColor alpha:(CGFloat)alpha;

@end
