//
//  CurrentUser.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject

@property (nonatomic, strong) NSArray* userInscpetions;

/**
 * gets singleton object.
 * @return singleton
 */
+ (CurrentUser*)sharedInstance;

@end
