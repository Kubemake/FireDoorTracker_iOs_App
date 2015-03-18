//
//  Tabs.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import "Tab.h"

@implementation Tab

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.uid = [dictionary objectForKey:@"idFormFields"];
        self.label = [dictionary objectForKey:@"label"];
        self.nextQuiestionID = [dictionary objectForKey:@"nextQuestionId"];
    }
    return self;
}

@end
