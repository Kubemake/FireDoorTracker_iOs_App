//
//  NetworkManager.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "NetworkManager.h"
#import <AFNetworking.h>

static NSString* baseURL = @"http://firedoortracker.org/service/";
static NSString* dispatcherURL = @"dispatcher";
static NSString* uploadURL = @"upload";

static NSString* kRequestType = @"type";
static NSString* AuthRequestType = @"auth";
static NSString* glossaryLettersRequestType = @"get_glossary_letters";
static NSString* glossaryTermsByLetter = @"get_terms_by_letter";
static NSString* glossaryKeyWordSearch = @"search_glossary_terms";
static NSString* inspectionListByUser = @"get_inspection_list_by_user";
static NSString* inspectionquestionsList = @"get_aperture_issues";
static NSString* inspectionDoorOverview = @"get_aperture_overview_info";
static NSString* getProfileInfo = @"get_profile_data";
static NSString* updateProfileInfoKey = @"update_profile_data";
static NSString* inspectionUpdateData = @"update_inspection_data";
static NSString* inspectionConfirmation = @"set_inspection_confirmation";

static NSString* kToken = @"token";
static NSString* kFile = @"file";

static NSString* kStatus = @"status";
static NSString* kError = @"error";
static NSString* statusOK = @"ok";

typedef enum {
    RequestMethodPOST = 0,
    RequestMethodGET
} RequestMethod;

@interface NetworkManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager* networkManager;
@property (nonatomic, copy) NSString* userToken;

@end

@implementation NetworkManager

static NetworkManager *SINGLETON = nil;
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
    return [[NetworkManager alloc] init];
}

- (id)mutableCopy {
    return [[NetworkManager alloc] init];
}

- (id)init {
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    [self initRequestOperationManager];
    return self;
}

#pragma mark - Operation Manager lyfecircle

- (void)initRequestOperationManager {
    self.networkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    self.networkManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.networkManager.responseSerializer = [AFJSONResponseSerializer serializer];
}

#pragma mark - Request methods

- (void)performRequestWithType:(RequestType)type
                     andParams:(NSDictionary *)params
                withCompletion:(void (^)(id responseObject, NSError* error))completion {
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    RequestMethod requestMethod = RequestMethodPOST;
    
    switch (type) {
        case AuthorizationRequestType:
            [requestParams setObject:AuthRequestType forKey:kRequestType];
            break;
        case GlossaryLettersRequestType:
            [requestParams setObject:glossaryLettersRequestType forKey:kRequestType];
            break;
        case GlossaryTermsByLetterRequestType:
            [requestParams setObject:glossaryTermsByLetter forKey:kRequestType];
            break;
        case GlossaryKeyWordSearchRequestType:
            [requestParams setObject:glossaryKeyWordSearch forKey:kRequestType];
            break;
        case InspectionListByUserRequestType:
            [requestParams setObject:inspectionListByUser forKey:kRequestType];
            break;
        case InspectionQuestionListRequestType:
            [requestParams setObject:inspectionquestionsList forKey:kRequestType];
            break;
        case InspectionDoorOverviewRequestType:
            [requestParams setObject:inspectionDoorOverview forKey:kRequestType];
            break;
        case GetProfileInfoRequestType:
            [requestParams setObject:getProfileInfo forKey:kRequestType];
            break;
        case UpdateProfileInfoRequestType:
            [requestParams setObject:updateProfileInfoKey forKey:kRequestType];
        case InspectionUpdateDataRequestType:
            [requestParams setObject:inspectionUpdateData forKey:kRequestType];
            break;
        case InspectionConfirmationRequestType:
            [requestParams setObject:inspectionConfirmation forKey:kRequestType];
            break;
        case uploadFileRequestType:
            break;
        default:
            //TODO: Unknow request type, return Error
            break;
    }
    if (self.userToken) {
        [requestParams setObject:self.userToken forKey:kToken];
    }
    for (NSString* paramsKey in [params allKeys]) {
        if ([requestParams objectForKey:paramsKey]) {
            //TODO: Return error -> wrong request param
        } else {
            [requestParams setObject:[params objectForKey:paramsKey]
                              forKey:paramsKey];
        }
    }
    
    if (type == uploadFileRequestType) {
        //Special method for upload
        NSData *dataForUpload = UIImagePNGRepresentation([requestParams objectForKey:kFile]);
        [requestParams removeObjectForKey:kFile];
        [self.networkManager POST:uploadURL
                       parameters:requestParams
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:dataForUpload
                                        name:kFile
                                    fileName:[requestParams objectForKey:@"file_name"]
                                    mimeType:@"image/png"];
        }
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if (completion) {
                                  if ([[responseObject objectForKey:kStatus] isEqualToString:statusOK]) {
                                      completion(responseObject, nil);
                                  } else {
                                      completion(nil, [NSError errorWithDomain:[responseObject objectForKey:kError]
                                                                          code:0
                                                                      userInfo:responseObject]);
                                  }
                              }
                              
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              if (completion) completion(nil, error);
//                              NSData *theData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//                              NSString *string = [NSString stringWithUTF8String:[theData bytes]];
//                              NSLog(@"%@",string);
                          }];
        return;
    }
    
    [self.networkManager POST:dispatcherURL
                   parameters:requestParams
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if ([responseObject objectForKey:kToken]) {
                              self.userToken = [responseObject objectForKey:kToken];
                          }
                          
                          if (completion) {
                              if ([[responseObject objectForKey:kStatus] isEqualToString:statusOK]) {
                                  completion(responseObject, nil);
                              } else {
                                  completion(nil, [NSError errorWithDomain:[responseObject objectForKey:kError]
                                                                      code:0
                                                                  userInfo:responseObject]);
                              }
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (completion) completion(nil, error);
                      }];
}


@end
