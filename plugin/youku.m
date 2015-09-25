//
//  vp-youku.m
//  vp-youku
//
//  Created by TYPCN on 2015/9/20.
//  Copyright © 2015 TYPCN. All rights reserved.
//

#import "youku.h"

@interface youku ()

@property (strong) NSWindowController* settingsPanel;

@end

@implementation youku

@synthesize settingsPanel;

- (bool)load:(int)version{
    
    NSLog(@"VP-Youku is loaded");
    
    return true;
}


- (bool)unload{
    
    return true;
}


- (bool)canHandleEvent:(NSString *)eventName{
    // Eventname format is pluginName-str
    if([eventName isEqualToString:@"youku-playvideo"]){
        return true;
    }
    return false;
}

- (NSString *)processEvent:(NSString *)eventName :(NSString *)eventData{
    
    if([eventName isEqualToString:@"youku-playvideo"]){
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/open";
        task.arguments = @[@"-a",@"QuickTime Player",eventData];
        [task launch];
        return NULL;
    }
    
    return NULL; // return video url to play
}

- (void)openSettings{
    NSLog(@"Show youku settings");
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NSString *path = [[NSBundle bundleForClass:[self class]]
                          pathForResource:@"Settings" ofType:@"nib"];
        settingsPanel =[[NSWindowController alloc] initWithWindowNibPath:path owner:self];
        [settingsPanel showWindow:self];
    });
    return;
}
@end