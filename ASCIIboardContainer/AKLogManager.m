//
//  AKLogManager.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 3/13/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKLogManager.h"
#import "Config.h"
#import "Flurry.h"

@implementation AKLogManager

+ (id)sharedManager
{

    static AKLogManager *sharedManager;
    if (!sharedManager) {
        sharedManager = [[AKLogManager alloc] init];
    }
    return sharedManager;
}

- (NSUserDefaults *)defaults
{
    return [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
}

- (void)saveLog:(NSString *)log withParams:(NSDictionary *)params
{
    NSUserDefaults *defaults = [self defaults];
    NSMutableArray *events = [NSMutableArray arrayWithArray:[defaults objectForKey:@"events"]];
    [events addObject:@{
                        @"event": log,
                        @"params": params
                        }];
    [defaults setObject:events forKey:@"events"];
    [defaults synchronize];
}

+ (void)saveLog:(NSString *)log withParams:(NSDictionary *)params
{
    [[AKLogManager sharedManager] saveLog:log withParams:params];
}

- (void)saveLog:(NSString *)log
{
    NSUserDefaults *defaults = [self defaults];
    NSMutableArray *events = [NSMutableArray arrayWithArray:[defaults objectForKey:@"events"]];
    [events addObject:@{ @"event": log }];
    [defaults setObject:events forKey:@"events"];
    [defaults synchronize];
}

+ (void)saveLog:(NSString *)log
{
    [[AKLogManager sharedManager] saveLog:log];
}

- (void)dumpLogsToFlurry
{
    NSUserDefaults *defaults = [self defaults];
    NSArray *events = [defaults objectForKey:@"events"];
    for (NSDictionary *event in events) {
        [Flurry logEvent:[event objectForKey:@"event"] withParameters:[event objectForKey:@"params"]];
    }

    [defaults setObject:nil forKey:@"events"];
    [defaults synchronize];

}

+ (void)dumpLogsToFlurry
{
    [[AKLogManager sharedManager] dumpLogsToFlurry];
}

@end
