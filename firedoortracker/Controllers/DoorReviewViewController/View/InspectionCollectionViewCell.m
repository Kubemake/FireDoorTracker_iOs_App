//
//  InspectionCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "InspectionCollectionViewCell.h"

//Import Extension
#import "UIImage+Utilities.h"

@interface InspectionCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation InspectionCollectionViewCell

#pragma mark - Display Methods

- (void)displayInspection:(Inspection *)inspection {
    self.titleLabel.text = [NSString stringWithFormat:@"Review %@",inspection.uid];
    //TODO: Display Result Statuses
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@ %@\n%@",
                                  inspection.apertureId,
                                  inspection.locationName,
                                  inspection.inspectionStatus,
                                  inspection.startDate,
                                  inspection.completionDate,
                                  inspection.firstName, inspection.lastName,
                                  inspection.inspectionStatus];
    [self displayColorStatuses:inspection.colorStatus];
}

- (void)displayColorStatuses:(NSArray *)statuses {
    for (UIImageView *prevStatuses in [self.descriptionLabel subviews]) {
        [prevStatuses removeFromSuperview];
    }
    
    CGFloat colorStatusViewX = 0.0f;
    for (NSNumber *status in statuses) {
        UIImageView *statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageForReviewStaton:[status integerValue]]];
        statusImageView.frame = CGRectMake(colorStatusViewX,
                                           self.descriptionLabel.frame.size.height - statusImageView.bounds.size.height,
                                           statusImageView.bounds.size.width,
                                           statusImageView.bounds.size.height);
        [self.descriptionLabel addSubview:statusImageView];
        colorStatusViewX += statusImageView.bounds.size.width + 3.0f;
    }
}

@end
