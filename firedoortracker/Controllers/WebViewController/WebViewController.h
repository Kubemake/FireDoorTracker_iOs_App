//
//  WebViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 07.04.15.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    WebViewPageTypeFAQ = 0,
    WebViewPageTypeVideoTutorial
} WebViewPageType;

@interface WebViewController : UIViewController

@property (nonatomic, assign) WebViewPageType typeForDisplaying;

@end
