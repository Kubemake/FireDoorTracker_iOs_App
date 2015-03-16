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

static NSString* showTabBarFlowSegueIdentifier = @"showTabBarFlowSegueIdentifier";

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

#pragma mark - Login Action
#pragma mark -

- (void)logInWithCashedCredentials {
    [self.activityIndicator startAnimating];
    [self.descriptionLabel setHidden:YES];
    [self.logInButton setEnabled:NO];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:AuthorizationRequestType
                                                  andParams:@{@"login" : @"stasionok@gmail.com",
                                                              @"password" : @"124"}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [welf.activityIndicator stopAnimating];
                                                 [welf.descriptionLabel setHidden:NO];
                                                 if (error) {
                                                     [welf.logInButton setEnabled:YES];
                                                     [welf.descriptionLabel setText:NSLocalizedString(@"Connection Problem", nil)];
                                                 }
                                                 [welf.descriptionLabel setText:NSLocalizedString(@"Authorization Completed",nil)];
                                                 [welf performSegueWithIdentifier:showTabBarFlowSegueIdentifier
                                                                           sender:welf];
                                             }];
}

#pragma mark Segue methods


@end
