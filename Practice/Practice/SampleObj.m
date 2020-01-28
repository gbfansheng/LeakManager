//
//  AObj.m
//  Practice
//
//  Created by Shenglin Fan on 2019/12/1.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import "SampleObj.h"
#import <objc/runtime.h>
#import "LeakManager.h"
#import "NSObject+Leak.h"

@implementation SampleObj

+ (void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(init) withSEL:@selector(swizzleInit)];
    });
}

-(instancetype)swizzleInit
{
    id instance = [self swizzleInit];
    [[LeakManager shareInstance] weakRefferObj:instance];
    return instance;
}


+ (void)initialize
{
    NSLog(@"AObjClass is initialize");
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.message = [coder decodeObjectForKey:@"message"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_message forKey:@"message"];
}

//+ (void)load
//{
//    NSLog(@"AObjClass is load");
//}

- (void)testB
{
//    BObj* b = [[BObj alloc] init];
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t tQueue = dispatch_queue_create("abc", NULL);
////    dispatch_async(tQueue, ^{
////        for (int i = 0; i < 1000000; i ++) {
////            int j = i;
////        }
////    });
//    dispatch_async(tQueue, ^{
//        NSLog([NSString stringWithFormat:@"%@ 0", [NSThread currentThread]]);
//        dispatch_async(tQueue, ^{
//            for (int i = 0; i < 100; i ++) {
//                NSLog([NSString stringWithFormat:@"%@ b", [NSThread currentThread]]);
//            }
//        });
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            for (int i = 0; i < 100; i ++) {
//                NSLog([NSString stringWithFormat:@"%@ a", [NSThread currentThread]]);
//            }
//        });
//
//        NSLog(@"concurrentQueue this mean no dead lock");
//    });

//    dispatch_queue_t serialQueue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(serialQueue, ^{
//        NSLog([NSString stringWithFormat:@"%@", [NSThread currentThread]]);
//        dispatch_sync(serialQueue, ^{
//            NSLog(@"sync task");
//        });
//        NSLog(@"serialQueue this mean no dead lock");
//    });
}

@end
