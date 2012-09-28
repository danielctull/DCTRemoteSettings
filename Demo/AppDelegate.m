//
//  AppDelegate.m
//  Demo
//
//  Created by Daniel Tull on 25.09.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import <DCTRemoteSettings/DCTRemoteSettings.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	NSURL *remoteSettingsURL = [NSURL URLWithString:@"http://danielctull.github.com/DCTRemoteSettings/test.json"];
	DCTRemoteSettings *remoteSettings = [[DCTRemoteSettings alloc] initWithURL:remoteSettingsURL cacheOnDisk:NO];
	
	[remoteSettings registerDefaults:@{ @"name" : @"Daniel", @"amountToLoad" : @10 }];
	
	[remoteSettings objectForKey:@"name" handler:^(id object) {
		NSLog(@"%@:%@ name: %@", self, NSStringFromSelector(_cmd), object);
	}];
	
	[remoteSettings objectForKey:@"amountToLoad" handler:^(id object) {
		NSLog(@"%@:%@ amountToLoad: %@", self, NSStringFromSelector(_cmd), object);
	}];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
