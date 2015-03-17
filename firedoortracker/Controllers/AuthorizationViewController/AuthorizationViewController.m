//
//  AuthorizationViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "AuthorizationViewController.h"

//Import Network part
#import "NetworkManager.h"

//Import Model
#import "CurrentUser.h"

static NSString* showTabBarFlowSegueIdentifier = @"showTabBarFlowSegueIdentifier";

static NSString* kUserInspections = @"inspections";

@interface AuthorizationViewController ()

//IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation AuthorizationViewController

#pragma mark - view controller lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logInWithCashedCredentials];
}

#pragma mark - API Methods
#pragma mark - Login

- (void)logInWithCashedCredentials {
    [self changeViewStatus:YES];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:AuthorizationRequestType
                                                  andParams:@{@"login" : @"stasionok@gmail.com",
                                                              @"password" : @"124"}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [welf changeViewStatus:NO];
                                                 if (error) {
                                                     [welf.descriptionLabel setText:NSLocalizedString(@"Connection Problem", nil)];
                                                 }
                                                 [welf.descriptionLabel setText:NSLocalizedString(@"Authorization Completed",nil)];
                                                 [welf loadIssuesListFromServer];
                                             }];
}

#pragma mark - Issues List

- (void)loadIssuesListFromServer {
    [self changeViewStatus:YES];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionListByUserRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [welf changeViewStatus:NO];
                                                 if (error) {
                                                     [welf.descriptionLabel setText:NSLocalizedString(@"Error in Issues List Loading", nil)];
                                                 }
                                                 [welf.descriptionLabel setText:NSLocalizedString(@"Issues List Loading Completed",nil)];
                                                 [CurrentUser sharedInstance].userInscpetions = [responseObject objectForKey:kUserInspections];
                                                 [welf performSegueWithIdentifier:showTabBarFlowSegueIdentifier
                                                                           sender:welf];
                                             }];
}

#pragma mark - UI Supporting methods

- (void)changeViewStatus:(BOOL)isLoading {
    if (isLoading) {
        [self.activityIndicator startAnimating];
#warning Debug logic
//        [self.descriptionLabel setHidden:YES];
        [self.logInButton setEnabled:NO];
    } else {
        [self.activityIndicator stopAnimating];
        [self.descriptionLabel setHidden:NO];
        [self.logInButton setEnabled:YES];
        
    }
}

#pragma mark Segue methods


@end
