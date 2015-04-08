//
//  ContactExpertCellCollectionViewCell.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "ContactExpertCell.h"

//Import Exptension
#import <UIImageView+WebCache.h>

@interface ContactExpertCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *webSiteButton;

@property (nonatomic, copy) NSString *expertWebsite;

@end

@implementation ContactExpertCell

#pragma mark - Display Methods

- (void)displayExpertData:(CellDataModel *)cellData {
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:cellData.logoUrl]];
    self.expertWebsite = cellData.website;
    
    [self.webSiteButton setTitle:cellData.website
                        forState:UIControlStateNormal];
    self.nameLabel.text = cellData.expertName;
    self.descriptionLabel.text = cellData.expertDescription;
}

#pragma mark - Actions

- (IBAction)websiteButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.expertWebsite]];
}


#pragma mark - Public

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([self class]);
}

@end