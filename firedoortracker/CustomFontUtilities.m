//
//  File.c
//  Pure
//
//  Created by Zhdanov Boris on 25.03.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "CustomFontUtilities.h"

#pragma mark - HelveticaNeue

UIFont *fontHelveticaNeueRegularWithSize(CGFloat size)
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

UIFont * fontHelveticaNeueUltraLightWithSize(CGFloat size)
{
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}

UIFont * fontHelveticaNeueThinWithSize(CGFloat size)
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    if (!font)
    {
        font = [UIFont fontWithName:@"HelveticaNeueThin" size:size];
    }
    return font;
}

UIFont * fontHelveticaNeueLightWithSize(CGFloat size)
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

UIFont * fontHelveticaNeueMediumWithSize(CGFloat size)
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

UIFont * fontHelveticaNeueBoldWithSize(CGFloat size)
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}