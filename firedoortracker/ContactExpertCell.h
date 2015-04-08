//
//  ContactExpertCellCollectionViewCell.h
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataModel.h"

@interface ContactExpertCell : UICollectionViewCell

- (void)displayExpertData:(CellDataModel *)cellData;

+ (NSString *)reusableIdentifier;

@end