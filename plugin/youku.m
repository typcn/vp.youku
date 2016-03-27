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
        
        NSArray *arr = [eventData componentsSeparatedByString:@"|"];
        if([arr count] == 1){
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/usr/bin/open";
            task.arguments = @[@"-a",@"QuickTime Player",eventData];
            [task launch];
        }else if([arr count] == 2){
            NSURL* URL = [NSURL URLWithString:arr[0]];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
            request.HTTPMethod = @"GET";
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9" forHTTPHeaderField:@"User-Agent"];
            [request setValue:arr[1] forHTTPHeaderField:@"Cookie"];
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request
                                                                  returningResponse:&response
                                                                            error:&error];
            if(error || !data){
                return NULL;
            }
            NSString *name = [NSString stringWithFormat:@"youku_%ld.m3u8",time(0)];
            NSString *path = [NSString stringWithFormat:@"%@bilimac_http_serv/%@",NSTemporaryDirectory(),name];
            [data writeToFile:path atomically:YES];
            
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/usr/bin/open";
            task.arguments = @[@"-a",@"QuickTime Player",[NSString stringWithFormat:@"http://localhost:23330/temp_content/%@",name]];
            [task launch];
            return NULL;
        }
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
        [settingsPanel.window makeKeyAndOrderFront:self];
    });
    return;
}
@end