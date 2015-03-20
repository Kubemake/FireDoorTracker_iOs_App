//
//  UIColor+FireDoorTrackerColors.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)FDTDarkGrayColor;
+ (UIColor *)FDTMediumGayColor;
+ (UIColor *)FDTLightGrayColor;
+ (UIColor *)FDTDeepBlueColor;

//Door Review Status
+ (UIColor *)FDTcompliant;
+ (UIColor *)FDTmaintenance;
+ (UIColor *)FDTrepair;
+ (UIColor *)FDTreplace;
+ (UIColor *)FDTrecertify;

@end
