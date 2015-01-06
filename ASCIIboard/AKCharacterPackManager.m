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

- (void)refreshCharacterPacks
{

    NSMutableArray *allCharacterPacks = [[NSMutableArray alloc] init];

    NSArray *characterPackPaths = [self filesAtPath:[[NSBundle mainBundle] bundlePath] withExtension:@".pack.plist"];

    for (NSString *path in characterPackPaths) {
        NSMutableDictionary *pack = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:@"plist"]];
        [allCharacterPacks addObject:pack];
    }


    // check preferences for enabled packs

    // if none exist, create and populat with defaults
    // otherwise, read and modify results in memory after retrieving their data
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    if ([defaults objectForKey:@"characterPacks"] == nil) {
        // first launch or something
        [self reset];
    }

    for (NSString *key in [defaults objectForKey:@"characterPacks"]) {
        // for each pack in that array, find it in allCharacterPacks and make sure enabled is true
        // -> they are disabled by default
        for (NSMutableDictionary *pack in allCharacterPacks) {
            if ([[pack objectForKey:@"keyName"] isEqualToString:key]) {
                [pack setValue:@YES forKey:@"enabled"];
            }
        }
    }

    self.characterPacks = [NSArray arrayWithArray:allCharacterPacks];

}

- (BOOL)setCharacterPackEnabled:(NSString *)pack
{
    // pack is key of pack
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    NSMutableArray *existingPacks = [NSMutableArray arrayWithArray:[defaults objectForKey:@"characterPacks"]];
    [existingPacks addObject:pack];
    [defaults setObject:[NSArray arrayWithArray:existingPacks] forKey:@"characterPacks"];
    [defaults synchronize];

    // returns success or not
    return YES;
}

- (void)reset
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
    [defaults setObject:@[@"original"] forKey:@"characterPacks"];
    [defaults synchronize];
}

#pragma mark - Util

- (NSArray *)filesAtPath:(NSString *)path withExtension:(NSString *)extension
{
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:path error:nil];

    for (item in contents){
        if ([item hasSuffix:extension]) {
            [matches addObject:item];
        }
    }
    return matches;
}

@end










