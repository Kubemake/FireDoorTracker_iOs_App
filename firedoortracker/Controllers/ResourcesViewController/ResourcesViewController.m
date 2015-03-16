//
//  ResourcesViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "ResourcesViewController.h"

//Import View
#import "AlphabetView.h"

//Import Network
#import "NetworkManager.h"

static NSString* kLetters = @"letters";
static NSString* kTerms = @"terms";

@interface ResourcesViewController() <AlphabetViewDelegate>

@property (weak, nonatomic) IBOutlet AlphabetView *alphabetView;

@end

@implementation ResourcesViewController

#pragma mark - view controller lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDelegates];
    [self loadAndDisplayAvailableLetters];
}

#pragma mark - Setup Methods
#pragma mark -

- (void)setupDelegates {
    self.alphabetView.delegate = self;
}

#pragma mark - API methods
#pragma mark -

- (void)loadAndDisplayAvailableLetters {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryLettersRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display Error
                                                 }
                                                 [welf.alphabetView displayActiveLetters:[responseObject objectForKey:kLetters]];
                                             }];
}

- (void)loadAndDispayGlossaryTermsByLetter:(NSString *)letter {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryTermsByLetterRequestType
                                                  andParams:@{kLetters : letter}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display error
                                                 }
                                                 //TODO: Displat terms on table
                                             }];
}

#pragma mark - Delegates
#pragma mark - ALphabet View Delegate

- (void)userSelectLetter:(NSString *)letter {
    [self loadAndDispayGlossaryTermsByLetter:letter];
}

@end
