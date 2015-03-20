//
//  Term.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "Term.h"

@implementation Term

#pragma mark - init method

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.idInfo = [dictionary objectForKey:@"idInfo"];
        self.name = [dictionary objectForKey:@"name"];
        self.type = [dictionary objectForKey:@"type"];
        self.termDescription = [dictionary objectForKey:@"description"];
    }
    return self;
}

@end
