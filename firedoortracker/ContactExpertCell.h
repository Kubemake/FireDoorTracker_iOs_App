//
//  ContactExpertCellCollectionViewCell.h
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactExpertCell : UICollectionViewCell

@property (strong, nonatomic) UIImage  *logo;
@property (copy,   nonatomic) NSString *expertName;
@property (copy,   nonatomic) NSString *phoneNumber;
@property (copy,   nonatomic) NSString *address;
@property (copy,   nonatomic) NSString *website;

- (void)redraw;

+ (NSString *)reusableIdentifier;

@end