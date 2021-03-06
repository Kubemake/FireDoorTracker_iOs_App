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
- (void)enableMenuTitles:(NSArray *)menuItems;
- (void)changeInspectionStatusTo:(NSArray *)newStatuses;

@end

@interface InterviewPageViewController : UIPageViewController

@property (nonatomic, copy) NSString* inspectionID;
@property (nonatomic, strong) NSDictionary* doorOverviewDictionary;

//Door Interview Delegate
@property (nonatomic, weak) id <InterviewPageDelegate> interviewDelegate;

- (void)setSelectedPage:(NSInteger)selectedPage;

@end
