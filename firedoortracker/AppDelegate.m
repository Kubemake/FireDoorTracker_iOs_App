//
//  AppDelegate.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "AppDelegate.h"
#import "UIImage+Utilities.h"
#import "TestFairy.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupNavigationBarAppearance];
    [TestFairy begin:@"80331b626231b2dc25c06037e77882814a81c4c5"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Private UI

- (void)setupNavigationBarAppearance
{
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"nav-bar-shadow-image"]];
}

@end