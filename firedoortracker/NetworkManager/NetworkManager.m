//
//  NetworkManager.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "NetworkManager.h"
#import <AFNetworking.h>

static NSString* baseURL = @"http://superpizdato.com/service/dispatcher";

static NSString* kRequestType = @"type";
static NSString* AuthRequestType = @"auth";
static NSString* glossaryLettersRequestType = @"get_glossary_letters";
static NSString* glossaryTermsByLetter = @"get_terms_by_letter";
static NSString* glossaryKeyWordSearch = @"search_glossary_terms";
static NSString* inspectionListByUser = @"get_inspection_list_by_user";
static NSString* inspectionquestionsList = @"get_issues_list";
static NSString* inspectionDoorOverview = @"get_aperture_overview_info";

static NSString* kToken = @"token";

static NSString* kStatus = @"status";
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
    
    switch (requestMethod) {
        case RequestMethodGET: {
            [self.networkManager GET:@""
                          parameters:requestParams
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if (completion) completion(responseObject, nil);
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 if (completion) completion(nil, error);
                             }];
            break;
        }

        case RequestMethodPOST:
            [self.networkManager POST:@""
                           parameters:requestParams
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  if ([responseObject objectForKey:kToken]) {
                                      self.userToken = [responseObject objectForKey:kToken];
                                  }
                                  
                                  if (completion) {
                                      if ([[responseObject objectForKey:kStatus] isEqualToString:statusOK]) {
                                          completion(responseObject, nil);
                                      } else {
                                          completion(nil, [NSError errorWithDomain:@"Request Error"
                                                                              code:-100500
                                                                          userInfo:responseObject]);
                                      }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  if (completion) completion(nil, error);
                              }];
            break;
    }
}


@end
