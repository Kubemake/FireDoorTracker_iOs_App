//
//  StartInterviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

//Import Controllers
#import "StartInterviewViewController.h"

//Import View
#import <IQDropDownTextField.h>

static NSString* kSelected = @"selected";
static NSString* kType = @"type";
static NSString* vTypeEnum = @"enum";
static NSString* kValues = @"values";
static NSString* kName = @"name";

@interface StartInterviewViewController ()

@property (weak, nonatomic) IBOutlet UIView *doorPropertiesView;

@end

@implementation StartInterviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Display View Methods
#pragma mark -

- (void)displayDoorProperties:(NSDictionary *)doorProperties {
    CGFloat propertyLabelHeight = self.doorPropertiesView.bounds.size.height / doorProperties.count;
    CGFloat propertyTitleLabelWidth = self.doorPropertiesView.bounds.size.width / 4.0f;
    CGFloat propertyValueLabelWidth = self.doorPropertiesView.bounds.size.width - propertyTitleLabelWidth;
    CGFloat propertyLabelY = 0;
    for (NSDictionary* property in [doorProperties allValues]) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        propertyLabelY,
                                                                        propertyTitleLabelWidth,
                                                                        propertyLabelHeight)];
        titleLabel.text = [property objectForKey:kName];

        UILabel *temLanel = [[UILabel alloc] initWithFrame:CGRectMake(propertyTitleLabelWidth,
                                                                      propertyLabelY,
                                                                      propertyValueLabelWidth,
                                                                      propertyLabelHeight)];
        temLanel.text = [property objectForKey:kSelected];
        
        [self.doorPropertiesView addSubview:titleLabel];
        [self.doorPropertiesView addSubview:temLanel];
        propertyLabelY += propertyLabelHeight;
    }
    
}

@end
