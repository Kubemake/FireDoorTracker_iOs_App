//
//  InterviewConfirmationViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import <UIKit/UIKit.h>

@protocol InterviewConfirmationProtocol <NSObject>

@required
- (void)interviewConfirmed;

@end

@interface InterviewConfirmationViewController : UIViewController

@property (nonatomic, weak) id<InterviewConfirmationProtocol> confirmationDelegate;

@property (nonatomic, weak) NSArray *tabs;
@property (nonatomic, weak) NSArray *questionAndAnswers;

@end
