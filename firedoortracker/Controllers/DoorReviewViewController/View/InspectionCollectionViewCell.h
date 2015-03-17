//
//  InspectionCollectionViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import <UIKit/UIKit.h>
#import "Inspection.h"

@interface InspectionCollectionViewCell : UICollectionViewCell

- (void)displayInspection:(Inspection *)inspection;

@end
