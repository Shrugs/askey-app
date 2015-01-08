//
//  AKCharacterPackManager.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/31/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AKCharacterPackManager.h"

@implementation AKCharacterPackManager

+ (id)sharedManager
{

    static AKCharacterPackManager *sharedManager;
    if (!sharedManager) {
        sharedManager = [[AKCharacterPackManager alloc] init];
    }
    return sharedManager;
}



- (NSMutableArray *)characterSets;
{
    NSMutableArray *sets = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"characterSets" ofType:@"plist"]];

    // check preferences for purchased and enabled sets

    // if none exist, create and populat with defaults
    // otherwise, read and modify results in memory after retrieving their data
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    if ([defaults objectForKey:@"characterSets"] == nil) {
        // first launch or something
        [self reset];
    }

    for (NSString *key in [defaults objectForKey:@"characterSets"]) {
        // for each pack in that array, find it in allcharacterSets and make sure enabled is true
        // -> they are disabled by default
        for (NSMutableDictionary *set in sets) {
            if ([[set objectForKey:@"keyName"] isEqualToString:key]) {
                [set setValue:@YES forKey:@"enabled"];
                [set setValue:@YES forKey:@"purchased"];
            }
        }
    }

    return sets;

}

- (BOOL)setCharacterSetEnabled:(NSString *)set
{
    // pack is key of pack
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    NSMutableArray *existingSets = [NSMutableArray arrayWithArray:[defaults objectForKey:@"characterPacks"]];
    [existingSets addObject:set];
    [defaults setObject:[NSArray arrayWithArray:existingSets] forKey:@"characterSets"];
    [defaults synchronize];

    // returns success or not
    return YES;
}

- (void)reset
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    // we haven't purchased any sets
    [defaults setObject:@[] forKey:@"characterSets"];
    [defaults synchronize];
}

@end










