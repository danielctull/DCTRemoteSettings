//
//  _DCTRemoteSettingsDiskCache.m
//  DCTRemoteSettings
//
//  Created by Daniel Tull on 26.09.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "_DCTRemoteSettingsDiskCache.h"

@implementation _DCTRemoteSettingsDiskCache {
	__strong NSURL *_URL;
}

- (id)initWithURL:(NSURL *)URL {
	self = [super init];
	if (!self) return nil;
	_URL = [URL copy];
	return self;
}

- (NSDictionary *)cachedRemoteSettings {
	return [NSDictionary dictionaryWithContentsOfURL:[self _cacheURL]];
}

- (void)setCachedRemoteSettings:(NSDictionary *)cachedRemoteSettings {
	[cachedRemoteSettings writeToURL:[self _cacheURL] atomically:YES];
}

- (NSURL *)_directoryURL {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSURL *cacheDirectory = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *directoryURL = [cacheDirectory URLByAppendingPathComponent:NSStringFromClass([self class])];
	[fileManager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
	return directoryURL;
}

- (NSURL *)_cacheURL {
	NSString *string = [NSString stringWithFormat:@"%lu", (unsigned long)[_URL hash]];
	return [[self _directoryURL] URLByAppendingPathComponent:string];
}

@end
