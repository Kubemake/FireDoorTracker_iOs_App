//
//  CurrentUser.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "CurrentUser.h"

//Import Model
#import "Inspection.h"

@implementation CurrentUser

static CurrentUser *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return [[CurrentUser alloc] init];
}

- (id)mutableCopy {
    return [[CurrentUser alloc] init];
}

- (id) init {
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

#pragma mark - Public Setters

- (void)setUserInscpetions:(NSArray *)userInscpetions {
    NSMutableArray *encodedInspetions = [NSMutableArray array];
    for (NSDictionary* codedInspection in userInscpetions) {
        Inspection* encodedInspection = [[Inspection alloc] initWithDictionary:codedInspection];
        [encodedInspetions addObject:encodedInspection];
    }
    _userInscpetions = encodedInspetions;
}


@end
