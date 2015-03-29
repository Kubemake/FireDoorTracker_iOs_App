//
//  Inspection.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "Inspection.h"

#import "UIColor+FireDoorTrackerColors.h"

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
        self.colorStatus = [dictionary objectForKey:@"colorcode"];
    }
    return self;
}

#pragma mark - public getters

- (NSString *)completionDate {
    if ([_completionDate isEqual:[NSNull null]]) {
        return @"-";
    }
    return _completionDate;
}

#pragma mark - status properties

+ (NSString *)stringForStatus:(inspectionStatus)status {
    switch (status) {
        case inspectionStatusCompliant:
            return @"Compliant";
        case inspectionStatusMaintenance:
            return @"Maintenance";
        case inspectionStatusRepair:
            return @"Repair";
        case inspectionStatusReplace:
            return @"Replace";
        case inspectionStatusRecertify:
            return @"Recertify";
        default:
            return @"In Progress";
    }
}

+ (UIColor *)colorForStatus:(inspectionStatus)status {
    switch (status) {
        case inspectionStatusCompliant:
            return [UIColor FDTcompliant];
        case inspectionStatusMaintenance:
            return [UIColor FDTmaintenance];
        case inspectionStatusRepair:
            return [UIColor FDTrepair];
        case inspectionStatusReplace:
            return [UIColor FDTreplace];
        case inspectionStatusRecertify:
            return [UIColor FDTrecertify];
        default:
            return [UIColor FDTDeepBlueColor];
    }
}

@end
