//
//  RCTAppleHealthKit+Methods_ECG.m
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

- (void)ecg_ecgHasFatigue:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    NSString *uuidString = [RCTAppleHealthKit stringFromOptions:input key:@"uuid" withDefault:@""];
    HKSampleType *fatigue = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierFatigue];
    
    [self countAssociatedSymptoms:fatigue ecgUUID:uuidString completion:^(NSUInteger *count, NSError *error) {
        if (error != nil) {
          NSLog(@"Error getting fatigue samples: %@", error);
          callback(@[RCTMakeError(@"Error getting fatigue samples", nil, nil)]);
          return;
        }
        int countAsInteger = (int)count;
        callback(@[[NSNull null], @(countAsInteger)]);
    }];
}

// Helpers
- (void)getSampleByUUID:(NSString *)uuidString completion:(void (^)(HKElectrocardiogram *, NSError *))completion
{
    HKSampleType *ecgType = [HKObjectType electrocardiogramType];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    NSPredicate *predicate = [HKQuery predicateForObjectWithUUID:uuid];
    
    HKSampleQuery *query =
        [[HKSampleQuery alloc]
         initWithSampleType:ecgType
         predicate:predicate
         limit:HKObjectQueryNoLimit
         sortDescriptors:nil
         resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            if (error != nil || [results count] == 0) {
                NSLog(@"Error occurred getting ECG sample by UUID %@", error);
                completion(nil, error);
                return;
            }
            completion([results firstObject], nil);
        }];
    
    [self.healthStore executeQuery:query];
}

- (void)countAssociatedSymptoms:(HKCategoryType *)type
                        ecgUUID:(NSString *)ecgUUID
                     completion:(void (^)(NSUInteger *, NSError *))completion
{
    [self getSampleByUUID:ecgUUID completion:^(HKElectrocardiogram *ecgSample, NSError *ecgSampleError) {
        if (ecgSample == nil) {
            completion(0, nil);
        }

        NSPredicate *predicate = [HKQuery predicateForObjectsAssociatedWithElectrocardiogram:ecgSample];

        HKSampleQuery *symptomsQuery =
            [[HKSampleQuery alloc]
             initWithSampleType:type
             predicate:predicate
             limit:HKObjectQueryNoLimit
             sortDescriptors:nil
             resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                if (error != nil) {
                    NSLog(@"Error occurred getting ECG sample by UUID %@", error);
                    completion(nil, error);
                    return;
                }
                
                completion([results count], nil);
            }];
        
        [self.healthStore executeQuery:symptomsQuery];
    }];
}

@end
