//
//  LeakManager.m
//  Practice
//
//  Created by Shenglin Fan on 2019/12/18.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import "LeakManager.h"
#import <objc/runtime.h>
#import "NSObject+Leak.h"

@interface LeakManager()

@property (strong, nonatomic) NSMutableDictionary* vcHashTableDic;  //key是vc的内存地址字符串，value是vc 引用的weakReference table
@property (strong, nonatomic) NSMutableDictionary* vcPropertyHashTableDic;//key是vc内存地址字符串，value是vc property的weakReference table
@property (strong, nonatomic) NSMutableArray* whiteListClasses;
@property (strong, nonatomic) NSMutableArray* whiteListInstance;

@end

@implementation LeakManager

+ (instancetype)shareInstance
{
    static LeakManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.vcHashTableDic = [[NSMutableDictionary alloc] init];
        instance.vcPropertyHashTableDic = [[NSMutableDictionary alloc] init];
        instance.whiteListClasses = [[NSMutableArray alloc] init];
        instance.whiteListInstance = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)createTableForViewController:(UIViewController*)vc
{
    if (vc) {
        NSHashTable* hashTable = [NSHashTable hashTableWithOptions: NSPointerFunctionsWeakMemory];
        [hashTable addObject:vc];//默认添加viewController
        [self.vcHashTableDic setObject:hashTable forKey:[NSString stringWithFormat:@"%p", vc]];
    }
}

- (void)createPropertyTableForViewController:(UIViewController*)vc
{
    if (vc) {
        NSHashTable* hashTable = [NSHashTable hashTableWithOptions: NSPointerFunctionsWeakMemory];
        [self.vcPropertyHashTableDic setObject:hashTable forKey:[NSString stringWithFormat:@"%p", vc]];
    }
}

- (void)referPropertiesForViewContronller:(UIViewController*)vc
{
    
}

//更新vc的属性表
- (void)updatePropertyReferencForController:(UIViewController*)vc
{
    //获得属性表，并循环将属性表的属性加入到vcPropertWeakReferDic
    NSString* vcAddress = [NSString stringWithFormat:@"%p", vc];
    NSHashTable* hashTable = [self.vcPropertyHashTableDic objectForKey:vcAddress];
    
    [vc watchAllRetainedProperties:0 hashTable:hashTable]; //vc所有属性和属性的属性加入到表中
    
}

- (void)weakRefferObj:(NSObject*)obj
{
    if (_currentViewController) {
        NSHashTable* table = [self.vcHashTableDic objectForKey:[NSString stringWithFormat:@"%p", _currentViewController]];
        [table addObject:obj];
    }
}

- (void)checkLeakForViewController:(UIViewController*)vc
{
    NSString* vcAddress = [NSString stringWithFormat:@"%p", vc];
    NSString* vcClassName = NSStringFromClass([vc class]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @synchronized (self) {
            [self checkLeakForHashTable:vcAddress vcClassName:vcClassName];
        }
    });
}

- (void)checkLeakForHashTable:(NSString*)vcAddress vcClassName:(NSString*)className
{
    NSHashTable* hashTable = [self.vcHashTableDic objectForKey:vcAddress];
    if (hashTable.count > 0) {
        //hashTable 有没有被回收的对象, send alert
        NSArray* objs = [hashTable allObjects];
        for (NSObject* obj in objs) {
            NSLog(@"%@ may leak %@", className, NSStringFromClass([obj class]));
        }
    }
    [self.vcHashTableDic removeObjectForKey: vcAddress];
    NSHashTable* propertyHashTable = [self.vcPropertyHashTableDic objectForKey:vcAddress];
    if (propertyHashTable.count > 0) {
        //hashTable 有没有被回收的对象, send alert
        NSArray* objs = [propertyHashTable allObjects];
        for (NSObject* obj in objs) {
            NSLog(@"%@ may leak property %@", className, NSStringFromClass([obj class]));
        }
    }
    [self.vcPropertyHashTableDic removeObjectForKey: vcAddress];}

- (void)checkRepeatReferenceForViewController:(UIViewController*)vc
{
    NSString* vcAddress = [NSString stringWithFormat:@"%p", vc];
    NSHashTable* hashTable = [self.vcHashTableDic objectForKey:vcAddress];
    if (hashTable.count > 0) {
        NSArray* objs = [hashTable allObjects];
        for (NSObject* obj in objs) {
            //排除所有已经存在的property
            for (NSString* key in _vcPropertyHashTableDic.allKeys) {
                NSHashTable* pTable = _vcPropertyHashTableDic[key];
                if ([pTable containsObject:obj]) {
                    [hashTable removeObject:obj];
                }
            }
        }
    }
}


@end
