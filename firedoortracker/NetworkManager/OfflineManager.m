//
//  OfflineManager.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 23.09.15.
//
//

#import "OfflineManager.h"

@implementation OfflineManager

static OfflineManager *SINGLETON = nil;
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
    return [[OfflineManager alloc] init];
}

- (id)mutableCopy {
    return [[OfflineManager alloc] init];
}

- (id)init {
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
//    [self initRequestOperationManager];
    return self;
}

#pragma mark - Operation Manager lyfecircle


@end
