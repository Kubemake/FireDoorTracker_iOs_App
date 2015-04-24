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
//Interaction with top menu
- (void)enableMenuTitles:(NSArray *)menuItems;
- (void)didScrollToMenuItem:(NSInteger)menuItem;

//Review Status
- (void)changeInspectionStatusTo:(NSArray *)newStatuses;

- (void)inspectionConfirmded;

@end

@interface InterviewPageViewController : UIPageViewController

@property (nonatomic, strong) NSNumber* inspectionID;
@property (nonatomic, strong) NSDictionary* doorOverviewDictionary;

//Door Interview Delegate
@property (nonatomic, weak) id <InterviewPageDelegate> interviewDelegate;

- (void)setSelectedPage:(NSInteger)selectedPage;

@end
