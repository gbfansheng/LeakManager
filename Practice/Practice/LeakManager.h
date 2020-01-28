//
//  LeakManager.h
//  Practice
//
//  Created by Shenglin Fan on 2019/12/18.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LeakManager : NSObject

+ (instancetype)shareInstance;
- (void)createTableForViewController:(UIViewController*)vc;
- (void)createPropertyTableForViewController:(UIViewController*)vc;
- (void)referPropertiesForViewContronller:(UIViewController*)vc;
- (void)checkLeakForViewController:(UIViewController*)vc;
- (void)checkRepeatReferenceForViewController:(UIViewController*)vc;

- (void)updatePropertyReferencForController:(UIViewController*)vc;
@property (strong, nonatomic) UIViewController* currentViewController;
- (void)weakRefferObj:(NSObject*)obj;

@end

