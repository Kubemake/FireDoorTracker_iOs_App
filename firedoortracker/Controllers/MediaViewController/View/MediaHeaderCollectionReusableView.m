//
//  MediaHeaderCollectionReusableView.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.04.15.
//
//

#import "MediaHeaderCollectionReusableView.h"

@interface MediaHeaderCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation MediaHeaderCollectionReusableView

- (void)displayInspectionInfo:(Inspection *)inspection {
    self.textLabel.text = [NSString stringWithFormat:@"Door ID %@",inspection.barCode];
}

+ (NSString *)identifier {
    return @"MediaHeaderCollectionReusableViewIdentifier";
}

@end
