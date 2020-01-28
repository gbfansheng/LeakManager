//
//  NSObject+Leak.h
//  Practice
//
//  Created by Shenglin Fan on 2019/12/17.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(Leak)

- (void)watchAllRetainedProperties:(int)level;
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;
- (NSArray*)getAllStrongPropertyNames:(Class)cls;
- (void)watchAllRetainedProperties:(int)level hashTable:(NSHashTable*)hashTable;
@end

NS_ASSUME_NONNULL_END
