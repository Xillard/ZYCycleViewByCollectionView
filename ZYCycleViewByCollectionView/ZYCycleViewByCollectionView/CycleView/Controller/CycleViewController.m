//
//  CycleViewController.m
//  ZYCycleViewByCollectionView
//
//  Created by  xiazhiyao on 2018/4/3.
//  Copyright © 2018年  xiazhiyao. All rights reserved.
//

#import "CycleViewController.h"
#import "ZYCycleView.h"

@interface CycleViewController ()

@end

@implementation CycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZYCycleView *cycleView = [ZYCycleView initWithFrameCycleViewFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 220) imageArray:@[@"背景1",@"背景2",@"背景1",@"背景2"]];
    [self.view addSubview:cycleView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
