//
//  InspectionCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "InspectionCollectionViewCell.h"

@interface InspectionCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation InspectionCollectionViewCell

#pragma mark - Display Methods

- (void)displayInspection:(Inspection *)inspection {
    self.titleLabel.text = [NSString stringWithFormat:@"Inspection %@",inspection.uid];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
                                  inspection.buildingName,
                                  inspection.inspectionStatus,
                                  inspection.startDate,
                                  inspection.locationName,
                                  (inspection.inspector) ? : @"-"];
}

@end
