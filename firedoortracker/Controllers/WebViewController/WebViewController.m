//
//  WebViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 07.04.15.
//
//

#import "WebViewController.h"

static NSString *const faqUrl = @"http://firedoortracker.org/service/faqpage";
static NSString *const videoTutorialUrl = @"http://firedoortracker.org/service/videopage";

@interface WebViewController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url;
    switch (self.typeForDisplaying) {
        case WebViewPageTypeFAQ:
            url = [NSURL URLWithString:faqUrl];
            break;
            
        case WebViewPageTypeVideoTutorial:
            url = [NSURL URLWithString:videoTutorialUrl];
            break;
    }
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

#pragma mark - IBActions
#pragma mark - Back Action

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web View Delegate
#pragma mark -

@end
