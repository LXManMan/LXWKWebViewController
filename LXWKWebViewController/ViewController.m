//
//  ViewController.m
//  LXWKWebViewController
//
//  Created by chenergou on 2018/2/11.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "ViewController.h"
#import "LXWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(id)sender {
    
    LXWebViewController *changeVc =[[LXWebViewController alloc]initWithUrl:@"https://www.baidu.com/" title:@"百度搜索"];

    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
