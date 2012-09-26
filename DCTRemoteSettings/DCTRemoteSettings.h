//
//  DCTRemoteSettings.h
//  DCTRemoteSettings
//
//  Created by Daniel Tull on 25.09.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	DCTRemoteSettingsStatusNoSettings,
	DCTRemoteSettingsStatusFetching,
	DCTRemoteSettingsStatusSuccess,
	DCTRemoteSettingsStatusFailed
} DCTRemoteSettingsStatus;

@interface DCTRemoteSettings : NSObject

- (id)initWithURL:(NSURL *)URL cacheOnDisk:(BOOL)cacheOnDisk;

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) BOOL cacheOnDisk;
@property (readonly) DCTRemoteSettingsStatus status;

- (void)registerDefault:(id)defaultValue forKey:(NSString *)key;
- (void)objectForKey:(NSString *)key handler:(void(^)(id object))handler;

@end
