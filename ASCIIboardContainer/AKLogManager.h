//
//  AKLogManager.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 3/13/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKLogManager : NSObject

+ (void)saveLog:(NSString *)log;
+ (void)saveLog:(NSString *)log withParams:(NSDictionary *)params;
+ (void)dumpLogsToFlurry;

@end
