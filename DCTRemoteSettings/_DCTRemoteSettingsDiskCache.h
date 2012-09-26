//
//  _DCTRemoteSettingsDiskCache.h
//  DCTRemoteSettings
//
//  Created by Daniel Tull on 26.09.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _DCTRemoteSettingsDiskCache : NSObject

- (id)initWithURL:(NSURL *)URL;
@property NSDictionary *cachedRemoteSettings;

@end
