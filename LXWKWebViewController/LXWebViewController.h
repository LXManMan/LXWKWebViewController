//
//  LXWebViewController.h
//  LXWKWebViewController
//
//  Created by chenergou on 2018/2/11.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXWebViewController : UIViewController
-(instancetype)initWithUrl:(NSString *)url title:(NSString *)title;
@property(nonatomic,assign)BOOL isPresent;
@end
