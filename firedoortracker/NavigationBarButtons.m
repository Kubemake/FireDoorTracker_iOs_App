//
//  NavigationBarButtons.m
//  firedoortracker
//
//  Created by Nikolay Palamar on 19/03/15.
//
//

#import "NavigationBarButtons.h"

@implementation NavigationBarButtons

+ (UIBarButtonItem *)backBarButtonItem
{
    UIImage *image = [UIImage imageNamed:@"nav-bar-back-button"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem new];
    [barButtonItem setImage:image];
    return barButtonItem;
}

+ (UIBarButtonItem *)searchBarButtonItem
{
#warning change icon to search
    UIBarButtonItem *barButtonItem = [UIBarButtonItem new];
    [barButtonItem setImage:[UIImage imageNamed:@"nav-bar-back-button"]];
    
    return barButtonItem;   
}

+ (UIBarButtonItem *)settingsBarButtonItem
{
#warning change icon to settings
    UIBarButtonItem *barButtonItem = [UIBarButtonItem new];
    [barButtonItem setImage:[UIImage imageNamed:@"nav-bar-back-button"]];
    
    return barButtonItem;     
}

@end
