//
//  DoorInfoOveriviewViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import <UIKit/UIKit.h>
#import "Inspection.h"

@protocol DoorInfoOveriviewViewControllerDelegate <NSObject>

@required
- (void)DoorInfoOveriviewViewController:(id)doorInfoOveriviewViewController didUpdateInspection:(Inspection *)inspection;

@end

@interface DoorInfoOveriviewViewController : UIViewController

@property (nonatomic, strong) Inspection* selectedInspection;

@property (nonatomic, weak) id<DoorInfoOveriviewViewControllerDelegate>delegate;

@end
