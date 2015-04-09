//
//  PhotoCollectionViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 09.04.15.
//
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

- (void)displayImage:(NSString *)imageUrl;

+ (NSString *)reuseIdentifier;

@end
