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

- (void)logInWithCashedCredentials {
    [self.activityIndicator startAnimating];
    [self.descriptionLabel setHidden:YES];
    [self.logInButton setEnabled:NO];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:AuthorizationRequestType
                                                  andParams:@{@"login" : @"stasionok@gmail.com",
                                                              @"password" : @"124"}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [welf.activityIndicator stopAnimating];
                                                     [welf.descriptionLabel setHidden:NO];
                                                     [welf.descriptionLabel setText:NSLocalizedString(@"Connection Problem", nil)];
                                                     [welf.logInButton setEnabled:YES];
                                                 }
                                                 //TODO: Push tab bar controller if response status = ok
                                             }];
}

@end
