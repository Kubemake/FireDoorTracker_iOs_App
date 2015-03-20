//
//  StartInterviewViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import <UIKit/UIKit.h>

@protocol startInterviewDelegate <NSObject>

@required
- (void)submitDoorOverview;

@end

@interface StartInterviewViewController : UIViewController

@property (nonatomic, weak) id<startInterviewDelegate> delegate;

- (void)displayDoorProperties:(NSDictionary *)doorProperties;

@end
