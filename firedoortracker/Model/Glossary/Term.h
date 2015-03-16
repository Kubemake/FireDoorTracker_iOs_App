//
//  Term.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import <Foundation/Foundation.h>

@interface Term : NSObject

@property (nonatomic, copy) NSString* idInfo;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* termDescription;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
