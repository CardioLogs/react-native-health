//
//  RCTAppleHealthKit+Methods_ECG.h
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
#import <HealthKit/HealthKit.h>

#import "RCTAppleHealthKit.h"

@interface RCTAppleHealthKit (Methods_ECG)

// API
- (void)ecg_getECGSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
- (void)ecg_ecgHasFatigue:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

// Helpers
- (void)getSampleByUUID:(NSString *)uuidString completion:(void (^)(HKElectrocardiogram *, NSError *))completion;
- (void)countAssociatedSymptoms:(HKCategoryType *)type
                        ecgUUID:(NSString *)ecgUUID
                     completion:(void (^)(NSUInteger *, NSError *))completion;

@end
