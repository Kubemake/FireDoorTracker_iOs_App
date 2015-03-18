//
//  NetworkManager.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    AuthorizationRequestType = 0,
    GlossaryLettersRequestType,
    GlossaryTermsByLetterRequestType,
    GlossaryKeyWordSearchRequestType,
    InspectionListByUserRequestType,
    InspectionQuestionListRequestType,
    InspectionDoorOverviewRequestType
} RequestType ;

@interface NetworkManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (NetworkManager*)sharedInstance;

/**
 *  Create and perform request to API in general requests queue
 *
 *  @param type       RequestType
 *  @param params     Params to the JSON body POST request or URL to the GET request
 *  @param completion completion withresponse object or error
 */
- (void)performRequestWithType:(RequestType)type
                     andParams:(NSDictionary *)params
                withCompletion:(void (^)(id responseObject, NSError* error))completion;

@end
