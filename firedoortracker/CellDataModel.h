//
//  CellDataModel.h
//  FTD-Test
//
//  Created by Nikolay Palamar on 16/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDataModel : NSObject

@property (strong, nonatomic) NSString *logoUrl;
@property (copy,   nonatomic) NSString *expertName;
@property (copy,   nonatomic) NSString *expertDescription;
@property (copy,   nonatomic) NSString *website;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end