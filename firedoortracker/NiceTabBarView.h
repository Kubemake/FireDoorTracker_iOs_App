//
//  NiceTabBarView.h
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NiceTabBarButtonType) {
    NiceTabBarButtonTypeUnknown,
    NiceTabBarButtonTypeHome,
    NiceTabBarButtonTypeDoorReview,
    NiceTabBarButtonTypeMedia,
    NiceTabBarButtonTypeResources,
    NiceTabBarButtonTypeSettings,
    NiceTabBarButtonTypeLogOut,
    NiceTabBarButtonTypeTotalCount          // Don't use this value
};

@protocol NiceTabBarViewDeleage <NSObject>

- (void)niceTabBarViewButtonPressed:(NiceTabBarButtonType)button;

@end

@interface NiceTabBarView : UIView

@property (weak, nonatomic) id<NiceTabBarViewDeleage> delegate;

@end