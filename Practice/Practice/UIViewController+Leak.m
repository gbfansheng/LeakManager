//
//  UIViewController+Leak.m
//  Practice
//
//  Created by Shenglin Fan on 2019/12/19.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import "UIViewController+Leak.h"
#import <objc/runtime.h>
#import "NSObject+Leak.h"
#import "LeakManager.h"

const void *const kHasBeenPoppedKey = &kHasBeenPoppedKey;

@implementation UIViewController (Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizzled_viewDidDisappear:)];
        [self swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(swizzled_viewWillAppear:)];
        [self swizzleSEL:@selector(dismissViewControllerAnimated:completion:) withSEL:@selector(swizzled_dismissViewControllerAnimated:completion:)];
        [self swizzleSEL:@selector(init) withSEL:@selector(swizzleInit)];
    });
}

- (instancetype)swizzleInit
{
    id instance = [self swizzleInit];
    [[LeakManager shareInstance] createTableForViewController:instance];
    [[LeakManager shareInstance] createPropertyTableForViewController:instance];
    [LeakManager shareInstance].currentViewController = self;
    return instance;
}

- (void)swizzled_viewDidDisappear:(BOOL)animated {
    [self swizzled_viewDidDisappear:animated];
    
    if ([objc_getAssociatedObject(self, kHasBeenPoppedKey) boolValue]) {
        [[LeakManager shareInstance] checkLeakForViewController:self];
    }
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
}

- (void)swizzled_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [[LeakManager shareInstance] checkLeakForViewController:self];
    [self swizzled_dismissViewControllerAnimated:flag completion:completion];
    
}

@end
