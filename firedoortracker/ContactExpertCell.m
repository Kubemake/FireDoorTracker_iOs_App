//
//  ContactExpertCellCollectionViewCell.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "ContactExpertCell.h"
#import "CustomFontUtilities.h"
#import "UIColor+additionalInitializers.h"

@interface ContactExpertCell ()

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel     *expertNameLabel;
@property (strong, nonatomic) UILabel     *phoneNumberLabel;
@property (strong, nonatomic) UILabel     *addressLabel;
@property (strong, nonatomic) UIButton    *websiteButton;

@end

@implementation ContactExpertCell

#pragma mark - Lifecycle

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

- (void)websiteButtonPressed
{
    NSURL *url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.website]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Public

- (void)redraw
{
    self.logoImageView.image = self.logo;
    self.expertNameLabel.text = self.expertName;
    self.phoneNumberLabel.text = self.phoneNumber;
    self.addressLabel.text = self.address;
    [self.websiteButton setTitle:self.website forState:UIControlStateNormal];
    
    [self commonLayoutSubviews];
}

#pragma mark - Private Logic

- (void)commonInit
{
    self.logoImageView = [UIImageView new];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.logoImageView];
    
    self.expertNameLabel = [UILabel new];
    self.expertNameLabel.font = fontHelveticaNeueBoldWithSize(18.0f);
    [self addSubview:self.expertNameLabel];
   
    self.phoneNumberLabel = [UILabel new];
    self.phoneNumberLabel.font = fontHelveticaNeueRegularWithSize(16.0f);
    self.phoneNumberLabel.numberOfLines = 2;
    [self addSubview:self.phoneNumberLabel];

    self.addressLabel = [UILabel new];
    self.addressLabel.font = fontHelveticaNeueRegularWithSize(16.0f);
    [self addSubview:self.addressLabel];
    
    self.websiteButton = [UIButton new];
    self.websiteButton.titleLabel.font = fontHelveticaNeueMediumWithSize(14.0f);
    [self.websiteButton setTitleColor:[UIColor colorWithUCharRed:51 green:122 blue:183 alpha:1.0f] forState:UIControlStateNormal];
    [self.websiteButton setTitleColor:[UIColor colorWithUCharRed:31 green:102 blue:163 alpha:1.0f] forState:UIControlStateHighlighted];
    [self.websiteButton addTarget:self action:@selector(websiteButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.websiteButton];
}

#pragma mark - Private UI

- (void)commonLayoutSubviews
{
    CGRect frame = CGRectZero;
  
    [self.expertNameLabel sizeToFit];
    frame = self.expertNameLabel.frame;
    frame.origin.y = 10.0f;
    frame.size.width = self.bounds.size.width;
    self.expertNameLabel.frame = frame;
    
    frame = self.logoImageView.frame;
    frame.size.height = roundf(self.bounds.size.width / 3.0f);
    frame.size.width = roundf(self.bounds.size.width / 3.0f);
    frame.origin.y = self.bounds.size.height - frame.size.height;
    self.logoImageView.frame = frame;
   
    [self.phoneNumberLabel sizeToFit];
    frame = self.phoneNumberLabel.frame;
    frame.origin.y = self.logoImageView.frame.origin.y;
    frame.origin.x = CGRectGetMaxX(self.logoImageView.frame) + 10.0f;
    frame.size.width = self.bounds.size.width - frame.origin.x;
    self.phoneNumberLabel.frame = frame;

    [self.addressLabel sizeToFit];
    frame = self.addressLabel.frame;
    frame.origin.y = CGRectGetMaxY(self.phoneNumberLabel.frame);
    frame.origin.x = CGRectGetMaxX(self.logoImageView.frame) + 10.0f;
    frame.size.width = self.bounds.size.width - frame.origin.x;
    self.addressLabel.frame = frame;
    
    [self.websiteButton sizeToFit];
    frame = self.websiteButton.frame;
    frame.origin.x = self.bounds.size.width - frame.size.width - 10.0f;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    self.websiteButton.frame = frame;

//    self.logoImageView.layer.borderColor = [[UIColor magentaColor] CGColor];
//    self.logoImageView.layer.borderWidth = 1.0f;
//    
//    self.expertNameLabel.layer.borderColor = [[UIColor magentaColor] CGColor];
//    self.expertNameLabel.layer.borderWidth = 1.0f;
//   
//    self.phoneNumberLabel.layer.borderColor = [[UIColor magentaColor] CGColor];
//    self.phoneNumberLabel.layer.borderWidth = 1.0f;
//    
//    self.addressLabel.layer.borderColor = [[UIColor magentaColor] CGColor];
//    self.addressLabel.layer.borderWidth = 1.0f;
//    
//    self.layer.borderColor = [[UIColor magentaColor] CGColor];
//    self.layer.borderWidth = 1.0f;
}

#pragma mark - Public

+ (NSString *)reusableIdentifier
{
    return NSStringFromClass([self class]);
}

@end