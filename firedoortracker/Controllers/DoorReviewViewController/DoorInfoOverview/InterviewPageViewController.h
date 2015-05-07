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

//Door Interview Delegate
@property (nonatomic, weak) id <InterviewPageDelegate> interviewDelegate;

- (void)setSelectedPage:(NSInteger)selectedPage;

- (void)setDoorOverviewDictionary:(NSDictionary *)doorOverviewDictionary toApertureId:(NSString *)apertureId;

@end
