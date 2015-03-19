//
//  ViewController.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "ContactExpertViewController.h"
#import "ContactExpertCell.h"
#import "ContactExpertView.h"
#import "CellDataModel.h"
#import "NavigationBarButtons.h"

@interface ContactExpertViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) ContactExpertView *view;
@property (strong, nonatomic) NSArray *expertObjects;

@end

@implementation ContactExpertViewController

#pragma mar - Lifecycle

- (void)loadView
{
    self.view = [ContactExpertView new];
    self.view.collectionView.delegate = self;
    self.view.collectionView.dataSource = self;
    
    self.title = @"CONTACT AN EXPERT";
    
    self.navigationItem.leftBarButtonItem = [NavigationBarButtons backBarButtonItem];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(backButtonPressed)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - Actions

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellDataModel *object = self.expertObjects[indexPath.row];
   
    ContactExpertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ContactExpertCell reusableIdentifier]
                                                                        forIndexPath:indexPath];
    cell.logo = object.logo;
    cell.expertName = object.expertName;
    cell.phoneNumber = object.phoneNumber;
    cell.address = object.address;
    cell.website = object.website;

    [cell redraw];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.expertObjects count];
}

#pragma mark - Private Logic

- (void)loadData
{
    NSMutableArray *experts = [NSMutableArray new];
    
    {
        CellDataModel *intertecExpert = [CellDataModel new];
        intertecExpert.logo = [UIImage imageNamed:@"exp-intertec"];
        intertecExpert.expertName = @"Intertek Testing Services, NA, Inc.";
        intertecExpert.phoneNumber = @"Phone: (608) 836-4400 08431\nMurphy Drive";
        intertecExpert.address = @"Middleton, WI 53562";
        intertecExpert.website = @"www.intertek.com";
        [experts addObject:intertecExpert];
    }
    {
        CellDataModel *underwritersLaboratoriesExpert = [CellDataModel new];
        underwritersLaboratoriesExpert.logo = [UIImage imageNamed:@"exp-underwriters"];
        underwritersLaboratoriesExpert.expertName = @"Underwriters Laboratories";
        underwritersLaboratoriesExpert.phoneNumber = @"Phone: (847) 272-8800 333\nPfingsten Road";
        underwritersLaboratoriesExpert.address = @"Northbrook, IL 60062";
        underwritersLaboratoriesExpert.website = @"www.ul.com";
        [experts addObject:underwritersLaboratoriesExpert];
    }
    {
        CellDataModel *nfpaExpert = [CellDataModel new];
        nfpaExpert.logo = [UIImage imageNamed:@"exp-nfpa"];
        nfpaExpert.expertName = @"National Fire Protection Association";
        nfpaExpert.phoneNumber = @"Phone: (617) 770-3000\n1 Batterymarch Park";
        nfpaExpert.address = @"Quincy, MA  02169-7471";
        nfpaExpert.website = @"www.nfpa.org";
        [experts addObject:nfpaExpert];
    }
    {
        CellDataModel *bhmaExpert = [CellDataModel new];
        bhmaExpert.logo = [UIImage imageNamed:@"exp-bhma"];
        bhmaExpert.expertName = @"Builders Hardware Manufacturers Association";
        bhmaExpert.phoneNumber = @"Phone: (212) 297-2122 355\nLexington Avenue 15th Floor";
        bhmaExpert.address = @"New York, NY 10017-6603";
        bhmaExpert.website = @"www.buildershardware.com";
        [experts addObject:bhmaExpert];
    }
    {
        CellDataModel *dhiExpert = [CellDataModel new];
        dhiExpert.logo = [UIImage imageNamed:@"exp-dhi"];
        dhiExpert.expertName = @"Door and Hardware Institute";
        dhiExpert.phoneNumber = @"Phone: (703) 222-2010 14150\nNewbrook Drive Suite 200";
        dhiExpert.address = @"Chantilly, VA 20151-2232";
        dhiExpert.website = @"www.dhi.org";
        [experts addObject:dhiExpert];
    }
    {
        CellDataModel *hmmaExpert = [CellDataModel new];
        hmmaExpert.logo = [UIImage imageNamed:@"exp-hmma"];
        hmmaExpert.expertName = @"Hollow Metal Manufacturers Association";
        hmmaExpert.phoneNumber = @"Phone: (630) 942-6591 800\nRoosevelt Rd.";
        hmmaExpert.address = @"Bldg. C, Suite 312";
        hmmaExpert.website = @"www.naamm.org/hmma";
        [experts addObject:hmmaExpert];
    }
    {
        CellDataModel *sdiExpert = [CellDataModel new];
        sdiExpert.logo = [UIImage imageNamed:@"exp-sdi"];
        sdiExpert.expertName = @"Steel Door Institute";
        sdiExpert.phoneNumber = @"Phone: (440) 899-0010 30200\nDetroit Road";
        sdiExpert.address = @"Westlake, Ohio 44145";
        sdiExpert.website = @"www.steeldoor.org";
        [experts addObject:sdiExpert];
    }
    {
        CellDataModel *wdmaExpert = [CellDataModel new];
        wdmaExpert.logo = [UIImage imageNamed:@"exp-wdma"];
        wdmaExpert.expertName = @"Window & Door Manufacturers Association";
        wdmaExpert.phoneNumber = @"Phone: (847) 299-5200 1400\nE. Touhy Ave., Suite 470";
        wdmaExpert.address = @"Des Plaines, IL 60018";
        wdmaExpert.website = @"www.wdma.com";
        [experts addObject:wdmaExpert];
    }
    
    self.expertObjects = [experts copy];
}

@end