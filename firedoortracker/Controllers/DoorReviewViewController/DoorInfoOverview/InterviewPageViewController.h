//
//  InterviewPageViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import <UIKit/UIKit.h>

@interface InterviewPageViewController : UIPageViewController

@property (nonatomic, copy) NSString* apertureID;
@property (nonatomic, strong) NSDictionary* doorOverviewDictionary;

@end
