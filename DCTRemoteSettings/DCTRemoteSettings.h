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

+ (DCTRemoteSettings *)sharedRemoteSettings;

@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, assign) BOOL cacheOnDisk;

@property (readonly) DCTRemoteSettingsStatus status;


- (void)setDefaultSetting:(id)defaultSetting forKey:(NSString *)key;
- (void)objectForKey:(NSString *)key handler:(void(^)(id object))handler;

@end
