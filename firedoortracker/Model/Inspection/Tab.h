//
//  Tabs.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import <Foundation/Foundation.h>

@interface Tab : NSObject

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* nextQuiestionID;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
