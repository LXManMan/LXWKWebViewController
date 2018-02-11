//
//  LXWebViewController.m
//  LXWKWebViewController
//
//  Created by chenergou on 2018/2/11.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "LXWebViewController.h"
#import <WebKit/WebKit.h>
#import "LxButton.h"
#import "LXWebViewProgressView.h"
@interface LXWebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    BOOL isFirstLoad;
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) LXWebViewProgressView *progressView;
@end

@implementation LXWebViewController
-(instancetype)initWithUrl:(NSString *)url title:(NSString *)title{
    
    self  = [super init];
    if (self) {
        
        self.url = url;
        self.navTitle = title;
    }
    return self;
}
-(void)setIsPresent:(BOOL)isPresent{
    _isPresent  = isPresent;
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (isFirstLoad) {
        [self.webView reload];
    }else{
        isFirstLoad = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.navTitle;
    [self setup];
    [self configNavBar];
    [self responData];
}
-(void)configNavBar{
    
    UIView *container =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    LxButton *backBtn = [LxButton LXButtonWithTitle:nil titleFont:nil Image:[UIImage imageNamed:@"LX_back"] backgroundImage:nil backgroundColor:nil titleColor:nil frame:CGRectMake(5, 14, 25, 25)];
    backBtn.enlargeSize = CGSizeMake(20, 20);
    [container addSubview:backBtn];
    
    LxButton *closeBtn = [LxButton LXButtonWithTitle:nil titleFont:nil Image:[UIImage imageNamed:@"LX_close"] backgroundImage:nil backgroundColor:nil titleColor:nil frame:CGRectMake(50, 14, 25, 25)];
    closeBtn.enlargeSize = CGSizeMake(20, 20);

    [container addSubview:closeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:container];
    WS(weakSelf);
    [backBtn addClickBlock:^(UIButton *button) {
        if (_webView.canGoBack) {
            [_webView goBack];
        } else {
            if (weakSelf.isPresent) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
    [closeBtn addClickBlock:^(UIButton *button) {
        if (weakSelf.isPresent) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
-(void)responData{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}
-(void)setup{
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.progressView];
    
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}
#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        double progress = self.webView.estimatedProgress;
        
        self.progressView.progress = progress;
        
    }
}
-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.configuration.allowsInlineMediaPlayback = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return _webView;
}
-(LXWebViewProgressView *)progressView{
    if (!_progressView) {
        
        CGFloat ProgressY = 0;
        if (self.navigationController.navigationBar && !self.navigationController.navigationBar.hidden) {
            ProgressY = 64;
        }
        _progressView =[[LXWebViewProgressView alloc]initWithFrame:CGRectMake(0, ProgressY, CGRectGetWidth(self.view.frame), 2.5)];
        _progressView.progress = 0.00;
        
    }
    return _progressView;
}
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
