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
	
	DCTRemoteSettings *remoteSettings = [DCTRemoteSettings sharedRemoteSettings];
	remoteSettings.URL = [NSURL URLWithString:@"http://danieltull.co.uk/DCTRemoteSettings/test.json"];
		
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
