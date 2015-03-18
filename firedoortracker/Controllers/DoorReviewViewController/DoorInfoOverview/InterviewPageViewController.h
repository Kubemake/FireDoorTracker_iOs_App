//
//  InterviewPageViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import <UIKit/UIKit.h>

@protocol InterviewPageDelegate <NSObject>

@required
- (void)displayMenuItems:(NSArray *)menuItems;

@end

@interface InterviewPageViewController : UIPageViewController

@property (nonatomic, copy) NSString* apertureID;
@property (nonatomic, strong) NSDictionary* doorOverviewDictionary;

//Door Interview Delegate
@property (nonatomic, weak) id <InterviewPageDelegate> delegate;

@end
