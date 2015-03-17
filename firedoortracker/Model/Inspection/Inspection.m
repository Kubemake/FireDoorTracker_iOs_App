//
//  Inspection.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "Inspection.h"

@implementation Inspection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.uid = [dictionary objectForKey:@"id"];
        self.firstName = [dictionary objectForKey:@"firstName"];
        self.lastName = [dictionary objectForKey:@"lastName"];
        self.locationId = [dictionary objectForKey:@"location_id"];
        self.buildingName = [dictionary objectForKey:@"building_name"];
        self.locationName = [dictionary objectForKey:@"location_name"];
        self.inspectionStatus = [dictionary objectForKey:@"InspectionStatus"];
        self.inspector = [dictionary objectForKey:@"Inscpector"];
        self.startDate = [dictionary objectForKey:@"StartDate"];
        self.completionDate = [dictionary objectForKey:@"Completion"];
        self.apertureId = [dictionary objectForKey:@"aperture_id"];
        self.apertureName = [dictionary objectForKey:@"aperture_name"];
    }
    return self;
}

@end
