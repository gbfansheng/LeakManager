//
//  CViewController.m
//  Practice
//
//  Created by Shenglin Fan on 2020/1/28.
//  Copyright © 2020 Shenglin Fan. All rights reserved.
//

#import "SampleViewController.h"
#import "SampleObj.h"

@interface SampleViewController ()

@property (strong, nonatomic) SampleObj* c;


@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.c = [[SampleObj alloc] init];
    SampleObj* a = [[SampleObj alloc] init];
    SampleObj* b = [[SampleObj alloc] init];
    a.obj = b;
    b.obj = _c;
    _c.obj = a;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
