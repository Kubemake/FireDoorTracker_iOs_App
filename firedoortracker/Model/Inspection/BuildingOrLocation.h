//
//  BuildingOrLocation.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

#import <Foundation/Foundation.h>

@interface BuildingOrLocation : NSObject

@property (nonatomic, strong) NSNumber* buildingOrder;
@property (nonatomic, strong) NSNumber* deleted;
@property (nonatomic, strong) NSNumber* idBuildings;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSNumber* parent;
@property (nonatomic, strong) NSNumber* root;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
