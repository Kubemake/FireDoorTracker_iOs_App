//
//  Inspection.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    inspectionStatusUnknow = 0,
    inspectionStatusCompliant,
    inspectionStatusMaintenance,
    inspectionStatusRepair,
    inspectionStatusReplace,
    inspectionStatusRecertify
}inspectionStatus;

@interface Inspection : NSObject

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* locationId;
@property (nonatomic, copy) NSString* locationName;
@property (nonatomic, copy) NSString* buildingName;
@property (nonatomic, copy) NSString* inspectionStatus;
@property (nonatomic, copy) NSString* inspector;
@property (nonatomic, copy) NSString* startDate;
@property (nonatomic, copy) NSString* completionDate;
@property (nonatomic, copy) NSString* apertureId;
@property (nonatomic, copy) NSString* barCode;
@property (nonatomic, copy) NSString* apertureName;
@property (nonatomic, strong) NSArray* colorStatus;
@property (nonatomic, strong) NSArray* images;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)stringForStatus:(inspectionStatus)status;
+ (UIColor *)colorForStatus:(inspectionStatus)status;

@end
