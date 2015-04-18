//
//  MediaHeaderCollectionReusableView.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.04.15.
//
//

#import <UIKit/UIKit.h>
#import "Inspection.h"

@interface MediaHeaderCollectionReusableView : UICollectionReusableView

- (void)displayInspectionInfo:(Inspection *)inspection;

+ (NSString *)identifier;

@end
