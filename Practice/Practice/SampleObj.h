//
//  AObj.h
//  Practice
//
//  Created by Shenglin Fan on 2019/12/1.
//  Copyright © 2019 Shenglin Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+Leak.h"

@interface SampleObj : NSObject<NSCoding>

@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSObject* obj;
- (void)testB;

@end
