//
//  RCTAppleHealthKit+Methods_Vitals.h
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
#import <HealthKit/HealthKit.h>

#import "RCTAppleHealthKit.h"

@interface RCTAppleHealthKit (Methods_ECG)

// API
- (void)ecg_getECGSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

@end
