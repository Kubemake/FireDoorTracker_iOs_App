//
//  CellDataModel.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 16/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "CellDataModel.h"

@implementation CellDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.logoUrl = [dict objectForKey:@"logo"];
        self.website = [dict objectForKey:@"link"];
        self.expertName = [dict objectForKey:@"name"];
        self.expertDescription = [dict objectForKey:@"description"];
    }
    return self;
}

@end