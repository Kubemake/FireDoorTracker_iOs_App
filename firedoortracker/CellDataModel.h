//
//  CellDataModel.h
//  FTD-Test
//
//  Created by Nikolay Palamar on 16/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDataModel : NSObject

@property (strong, nonatomic) UIImage  *logo;
@property (copy,   nonatomic) NSString *expertName;
@property (copy,   nonatomic) NSString *phoneNumber;
@property (copy,   nonatomic) NSString *address;
@property (copy,   nonatomic) NSString *website;

@end