//
//  UINavigationController+Leak.m
//  Practice
//
//  Created by Shenglin Fan on 2019/12/23.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import "UINavigationController+Leak.h"
#import <objc/runtime.h>
#import "NSObject+Leak.h"
#import "LeakManager.h"

@implementation UINavigationController (Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(swizzled_popViewControllerAnimated:)];
        [self swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(swizzledPushViewController:animated:)];
    });
}

- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = [self swizzled_popViewControllerAnimated:animated];
    
    if (!poppedViewController) {
        return nil;
    }
    
    // VC is not dealloced until disappear when popped using a left-edge swipe gesture
    // pop的时候更新property 表和 普通表
    [[LeakManager shareInstance] updatePropertyReferencForController: poppedViewController];
    [[LeakManager shareInstance] checkRepeatReferenceForViewController: poppedViewController];
    extern const void *const kHasBeenPoppedKey;
    objc_setAssociatedObject(poppedViewController, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    
    return poppedViewController;
}


- (void)swizzledPushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    [self swizzledPushViewController: vc animated: animated];
}



@end
