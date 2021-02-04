//
//  RCTAppleHealthKit+Methods_Vitals.h
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.

#import "RCTAppleHealthKit+Methods_ECG.h"
#import "RCTAppleHealthKit+Queries.h"
#import "RCTAppleHealthKit+Utils.h"

@implementation RCTAppleHealthKit(Methods_ECG)

- (void)ecg_getECGSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKSampleType *ecgType = [HKObjectType electrocardiogramType];

    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchSamplesOfType:ecgType
                        unit:unit
                   predicate:predicate
                   ascending:ascending
                       limit:limit
                  completion:^(NSArray *results, NSError *error) {
                      if(results){
                          callback(@[[NSNull null], results]);
                          return;
                      } else {
                          NSLog(@"error getting ecg samples: %@", error);
                          callback(@[RCTMakeError(@"error getting ecg samples", nil, nil)]);
                          return;
                      }
                  }];
}

@end
