//
//  ImageCache.m
//  TelegramTest
//
//  Created by keepcoder on 19.10.13.
//  Copyright (c) 2013 keepcoder. All rights reserved.
//

#import "ImageCache.h"
#import "ImageStorage.h"
#import "ImageUtils.h"
#import "TGFileLocation+Extensions.h"
@interface ImageCache()
@property (nonatomic, strong) NSCache *roundCache;
@end

@implementation ImageCache

+ (ImageCache *) sharedManager {
    static ImageCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCache alloc] init];
    });
    return instance;
}

- (id) init {
    if(self = [super init]) {
        [self setCountLimit:100];
        [self setTotalCostLimit:1500000];
        
        self.roundCache = [[NSCache alloc] init];
        [self.roundCache setCountLimit:100];
//        [self.roundCache setTotalCostLimit:1000000];
    }
    return self;
}

- (void) setObject:(id)obj forKey:(id)key {
    if(obj == nil)
        return ELog(@"nil value");
    
    [super setObject:obj forKey:key];
}


- (void) editCacheKey:(TGFileLocation *)old withLocation:(TGFileLocation *)location {
    NSImage *image = [self imageFromMemory:old];
    if(image) {
        [self removeFromCache:location];
        [self setImage:image forLocation:location];
    }
//    NSImage *image = [self objectForKey:[[old cacheKey] stringByAppendingString:@"_0"]];
//    if(image) {
//        [self removeObjectForKey:[[old cacheKey] stringByAppendingString:@"_0"]];
//        [self setObject:image forKey:[[location cacheKey] stringByAppendingString:@"_0"]];
//    }
}

-(void) removeFromCache:(TGFileLocation *)location {
     [self removeObjectForKey:[location cacheKey]];
}

- (void) setImage:(NSImage *)image forLocation:(TGFileLocation *)location {
    [self setObject:image forKey:location.cacheKey];
}

- (NSImage *) imageFromMemory:(TGFileLocation *)location {
    return [self objectForKey:[location cacheKey]];
}

- (NSImage*) imageFromMemory:(TGFileLocation*)location round:(int)round {
    return [self imageFromMemory:location];
   return [self objectForKey:[[location cacheKey] stringByAppendingFormat:@"_%d",round]];
}

- (NSImage *)roundImageFromMemoryByHash:(NSUInteger)hash {
    return [self.roundCache objectForKey:[NSNumber numberWithUnsignedInteger:hash]];
}

- (void)setRoundImageToMemory:(NSImage *)image hash:(NSUInteger)hash {
    if(!image)
        return;
    [self.roundCache setObject:image forKey:[NSNumber numberWithUnsignedInteger:hash]];
}


- (void) clear {
    [self.roundCache removeAllObjects];
    [self removeAllObjects];
}

@end
