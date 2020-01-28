//
//  UIView+Leak.m
//  Practice
//
//  Created by Shenglin Fan on 2019/12/23.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import "UIView+Leak.h"
#import <objc/runtime.h>
#import "NSObject+Leak.h"
#import "LeakManager.h"

@implementation UIView (Leak)

+ (void)load {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(init) withSEL:@selector(swizzleInit)];
        [self swizzleSEL:@selector(initWithFrame:) withSEL:@selector(swizzleInitWithFrame:)];
    });
}

-(instancetype)swizzleInit
{
    id instance = [self swizzleInit];
    [[LeakManager shareInstance] weakRefferObj:instance];
    return instance;
}

-(instancetype)swizzleInitWithFrame:(CGRect)frame
{
    id instance = [self swizzleInitWithFrame:frame];
    [[LeakManager shareInstance] weakRefferObj:instance];
    return instance;
}


@end
