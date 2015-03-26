//
//  AddDoorReviewViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

#import <UIKit/UIKit.h>

@protocol AddDoorReviewDelegate <NSObject>

@required
- (void)inspectionSuccessfullyCreated;

@end

@interface AddDoorReviewViewController : UIViewController

@property (nonatomic, weak) id<AddDoorReviewDelegate> delegate;

@end
