//
//  NiceTabBarView.m
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import "NiceTabBarView.h"
#import "UIColor+additionalInitializers.h"

@interface NiceTabBarView ()

@property (strong, nonatomic) UIView *horizontalSeparator;

@end

@implementation NiceTabBarView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self commonLayoutSubviews];
}

#pragma mark - Actions

- (void)niceButtonPressed:(UIButton *)button
{
    if (button.selected) {
        return;
    }
        
    [self setSelectedButton:button.tag - 10];
    [self.delegate niceTabBarViewButtonPressed:button.tag - 10];
}

#pragma mark - Public

- (void)setSelectedButton:(NiceTabBarButtonType)buttonType
{
    UILabel *label = (UILabel *)[self viewWithTag:buttonType + 100];
    label.textColor = [UIColor colorWithUCharRed:47 green:81 blue:152 alpha:1.0f];
    
    UIButton *button = (UIButton *)[self viewWithTag:buttonType + 10];
    button.selected = YES;
    
    for (int i = 0; i < NiceTabBarButtonTypeTotalCount; i++) {
        if (i == buttonType) {
            continue;
        }

        UILabel *label = (UILabel *)[self viewWithTag:i + 100];
        label.textColor = [UIColor colorWithUCharWhite:64 alpha:1.0f];
        
        UIButton *button = (UIButton *)[self viewWithTag:i + 10];
        button.selected = NO;
    }   
}

#pragma mark - Private Logic

- (void)commonInit
{
    self.backgroundColor = [UIColor colorWithUCharWhite:226 alpha:1.0f];
    
    for (int i = 0; i < NiceTabBarButtonTypeTotalCount; i++) {
        UIButton *button = [UIButton new];
        [button setImage:[self imageForButtonType:i]         forState:UIControlStateNormal];
        [button setImage:[self selectedImageForButtonType:i] forState:UIControlStateSelected];
        [button setImage:[self selectedImageForButtonType:i] forState:UIControlStateSelected | UIControlStateHighlighted];
        [button addTarget:self action:@selector(niceButtonPressed:) forControlEvents:UIControlEventTouchDown];
        button.tag = i + 10;
        button.selected = !i;
        [self addSubview:button];
       
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:8.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self titleForButtonType:i];
        label.tag = i + 100;
        [self addSubview:label];
        
        UIView *verticalSeparator = [UIView new];
        verticalSeparator.backgroundColor = [UIColor colorWithUCharWhite:202 alpha:1.0f];
        verticalSeparator.tag = i + 1000;
        [self addSubview:verticalSeparator];
    }
    
    self.horizontalSeparator = [UIView new];
    self.horizontalSeparator.backgroundColor = [UIColor colorWithUCharWhite:202 alpha:1.0f];
}

#pragma mark - Private UI

- (void)commonLayoutSubviews
{
    CGFloat offset = roundf(self.bounds.size.width / NiceTabBarButtonTypeTotalCount);
    CGRect frame = CGRectZero;
    
    for (int i = 0; i < NiceTabBarButtonTypeTotalCount; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i + 10];
        [button sizeToFit];
        frame = button.frame;
        frame.size.height = self.bounds.size.height;
        frame.size.width = self.bounds.size.height;
        frame.origin.x = i ? (offset * i) + roundf(offset / 2 - frame.size.width / 2)
                           : roundf(offset / 2 - frame.size.width / 2);
        frame.origin.y = (self.bounds.size.height - frame.size.height) / 2 - 4.0f;
        button.frame = frame;
   
        UILabel *label = (UILabel *)[self viewWithTag:i + 100];
        [label sizeToFit];
        frame = label.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height - 10.0f;
        frame.origin.x = CGRectGetMidX(button.frame) - frame.size.width / 2;
        label.frame = frame;
        
        UIView *verticalSeparator = [self viewWithTag:i + 1000];
        frame = verticalSeparator.frame;
        frame.size.height = self.bounds.size.height;
        frame.size.width = 0.5f;
        frame.origin.x = i * offset;
        verticalSeparator.frame = frame;
    }
    
    frame = self.horizontalSeparator.frame;
    frame.size.height = 0.5f;
    frame.size.width = self.bounds.size.width;
    self.horizontalSeparator.frame = frame;
}

#pragma mark - Private Utilities

- (UIImage *)imageForButtonType:(NiceTabBarButtonType)buttonType
{
    UIImage *image = nil;
    if (NiceTabBarButtonTypeHome == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-home"];
    }
    else if (NiceTabBarButtonTypeDoorReview == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-door-review"];
    }
    else if (NiceTabBarButtonTypeMedia == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-media"];
    }
    else if (NiceTabBarButtonTypeResources == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-resources"];
    }
    else if (NiceTabBarButtonTypeContactAnExpert == buttonType) {
        image = [UIImage imageNamed:@"tabBarContactAnExpert"];
    }
    else if (NiceTabBarButtonTypeSettings == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-settings"];
    }
    else if (NiceTabBarButtonTypeLogOut == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-logout"];
    }
    
    return image;
}

- (UIImage *)selectedImageForButtonType:(NiceTabBarButtonType)buttonType
{
    UIImage *image = nil;
    if (NiceTabBarButtonTypeHome == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-home-selected"];
    }
    else if (NiceTabBarButtonTypeDoorReview == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-door-review-selected"];
    }
    else if (NiceTabBarButtonTypeMedia == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-media-selected"];
    }
    else if (NiceTabBarButtonTypeResources == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-resources-selected"];
    }
    else if (NiceTabBarButtonTypeContactAnExpert == buttonType) {
        image = [UIImage imageNamed:@"tabBarContactAnExpert-selected"];
    }
    else if (NiceTabBarButtonTypeSettings == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-settings-selected"];
    }
    else if (NiceTabBarButtonTypeLogOut == buttonType) {
        image = [UIImage imageNamed:@"tab-bar-logout-selected"];
    }
    
    return image;
}

- (NSString *)titleForButtonType:(NiceTabBarButtonType)buttonType
{
    NSString *title;
    if (NiceTabBarButtonTypeHome == buttonType) {
        title = NSLocalizedString(@"Home", @"");
    }
    else if (NiceTabBarButtonTypeDoorReview == buttonType) {
        title = NSLocalizedString(@"Door Review", @"");
    }
    else if (NiceTabBarButtonTypeMedia == buttonType) {
        title = NSLocalizedString(@"Media", @"");
    }
    else if (NiceTabBarButtonTypeResources == buttonType) {
        title = NSLocalizedString(@"Resources", @"");
    }
    else if (NiceTabBarButtonTypeContactAnExpert == buttonType) {
        title = NSLocalizedString(@"Contact An Expert", @"");
    }
    else if (NiceTabBarButtonTypeSettings == buttonType) {
        title = NSLocalizedString(@"Settings", @"");
    }
    else if (NiceTabBarButtonTypeLogOut == buttonType) {
        title = NSLocalizedString(@"Log Out", @"");
    }
    
    return title;
}

@end