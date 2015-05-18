//
//  InspectionCollectionViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import <UIKit/UIKit.h>
#import "Inspection.h"

@protocol InspectionCollectionViewCellDelegate <NSObject>

@required
- (void)inspectionCollectionViewCell: (UICollectionViewCell *)cell userTouchedDeleteButton:(id)sender;

@end

@interface InspectionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<InspectionCollectionViewCellDelegate> delegate;

- (void)displayInspection:(Inspection *)inspection editingMode:(BOOL)isEditing;

@end
