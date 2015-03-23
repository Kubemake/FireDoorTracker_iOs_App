//
//  SecondViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import <UIKit/UIKit.h>

//Import Model
#import "Inspection.h"

@protocol DoorReviewSelectionProtocol <NSObject>

@required
- (void)inspectionSelected:(Inspection *)inspection doorReviewController:(UIViewController *)controller;

@end

@interface DoorReviewViewController : UIViewController

@property (nonatomic, weak) id<DoorReviewSelectionProtocol> inspectionSelectionDelegate;

@end

