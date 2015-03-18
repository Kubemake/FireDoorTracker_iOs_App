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

//Import Extensions
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

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
    CGFloat propertyLabelHeight = self.doorPropertiesView.bounds.size.height / doorProperties.count + 1;
    CGFloat propertyTitleLabelWidth = self.doorPropertiesView.bounds.size.width / 3.0f;
    CGFloat propertyValueLabelWidth = self.doorPropertiesView.bounds.size.width - propertyTitleLabelWidth;
    CGFloat propertyLabelY = 0;
    for (NSDictionary* property in [doorProperties allValues]) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        propertyLabelY,
                                                                        propertyTitleLabelWidth,
                                                                        propertyLabelHeight)];
        titleLabel.font = [UIFont FDTTimesNewRomanBoldWithSize:16.0f];
        titleLabel.textColor = [UIColor FDTMediumGayColor];
        titleLabel.text = [property objectForKey:kName];
        [self.doorPropertiesView addSubview:titleLabel];
        
        if ([[property  objectForKey:kType] isEqualToString:vTypeEnum]) {
            IQDropDownTextField *dropDownField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(propertyTitleLabelWidth,
                                                                                                                                propertyLabelY,
                                                                                                                                                                            propertyValueLabelWidth,
                                                                                                                                                                            propertyLabelHeight)];
            dropDownField.background = [UIImage imageNamed:@"reviewDropDownFieldBackground"];
            if ([[property objectForKey:kValues] isKindOfClass:[NSDictionary class]]) {
                dropDownField.itemList = [[property objectForKey:kValues] allValues];
            } else if ([[property objectForKey:kValues] isKindOfClass:[NSString class]]) {
                dropDownField.itemList = [[property objectForKey:kValues] componentsSeparatedByString:@"\n"];
            }
            [self.doorPropertiesView addSubview:dropDownField];
        }
        
        propertyLabelY += propertyLabelHeight;
    }
    
}

@end
