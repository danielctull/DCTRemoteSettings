//
//  DCTRemoteSettings.m
//  DCTRemoteSettings
//
//  Created by Daniel Tull on 25.09.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "DCTRemoteSettings.h"
#import "_DCTRemoteSettingsDiskCache.h"

@implementation DCTRemoteSettings {
	__strong NSMutableDictionary *_handlers;
	__strong NSDictionary *_remoteSettings;
	__strong NSMutableDictionary *_defaultSettings;
	__strong _DCTRemoteSettingsDiskCache *_diskCache;
}

- (id)initWithURL:(NSURL *)URL cacheOnDisk:(BOOL)cacheOnDisk {
	
	self = [super init];
	if (!self) return nil;
	
	_URL = [URL copy];
	_cacheOnDisk = cacheOnDisk;
	if (cacheOnDisk) _diskCache = [[_DCTRemoteSettingsDiskCache alloc] initWithURL:URL];
			
	_handlers = [NSMutableDictionary new];
	_defaultSettings = [NSMutableDictionary new];
		
	return self;
}

- (void)registerDefaults:(NSDictionary *)dictionary {
	[dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		[self registerDefault:object forKey:key];
	}];
}

- (void)registerDefault:(id)defaultValue forKey:(NSString *)key {
	[_defaultSettings setObject:defaultValue forKey:key];
}

- (void)_setHandler:(void(^)(id object))handler forKey:(NSString *)key {
	
	if (self.status > DCTRemoteSettingsStatusFetching) {
		[self _triggerHandler:handler forKey:key];
		return;
	}
	
	[_handlers setObject:handler forKey:key];
}

- (void)_triggerHandler:(void(^)(id object))handler forKey:(NSString *)key {
	id object = [_remoteSettings objectForKey:key];
	if (!object) object = [_defaultSettings objectForKey:key];
	handler(object);
}

- (void)_triggerHandlers {
	[_handlers enumerateKeysAndObjectsUsingBlock:^(id key, void(^handler)(id), BOOL *stop) {
		[self _triggerHandler:handler forKey:key];
	}];
	[_handlers removeAllObjects];
}

- (void)objectForKey:(NSString *)key handler:(void(^)(id object))handler {
	
	[self _setHandler:handler forKey:key];
	
	if (self.status > DCTRemoteSettingsStatusNotFetched)
		return;
	
	_status = DCTRemoteSettingsStatusFetching;
	
	_remoteSettings = [_diskCache cachedRemoteSettings];
	if (_remoteSettings) {
		_status = DCTRemoteSettingsStatusSuccess;
		[self _triggerHandlers];
		return;
	}
	
	NSURLRequest *vlsRequest = [[NSURLRequest alloc] initWithURL:self.URL];
	[NSURLConnection sendAsynchronousRequest:vlsRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		
		_remoteSettings = [self _dictionaryFromData:data];
		
		if (_remoteSettings) {
			_status = DCTRemoteSettingsStatusSuccess;
			_diskCache.cachedRemoteSettings = _remoteSettings; // Won't cache when _diskCache is nil
		} else {
			_status = DCTRemoteSettingsStatusFailed;
		}
		
		[self _triggerHandlers];
	}];
}

- (NSDictionary *)_dictionaryFromData:(NSData *)data {
	
	if (!data) return nil;
	
	id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
	if ([object isKindOfClass:[NSDictionary class]]) return object;
	
	object = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
	if ([object isKindOfClass:[NSDictionary class]]) return object;
	
	return nil;
}

@end
