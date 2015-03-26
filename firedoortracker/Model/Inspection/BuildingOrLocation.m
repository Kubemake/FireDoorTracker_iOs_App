//
//  BuildingOrLocation.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

#import "BuildingOrLocation.h"

@implementation BuildingOrLocation

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.buildingOrder = dict[@"buildingOrder"];
        self.deleted = dict[@"deleted"];
        self.idBuildings = dict[@"idBuildings"];
        self.name = dict[@"name"];
        self.parent = dict[@"parent"];
        self.root = dict[@"root"];
    }
    return self;
}

@end
