//
//  RecordViewController.m
//  NewAfar
//
//  Created by cw on 17/3/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "RecordViewController.h"
#import <WebKit/WebKit.h>
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface RecordViewController ()<WKNavigationDelegate>

@end

@implementation RecordViewController
{
    NSString *module;
    NSString *urlStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isManage) {
        [self customNavigationBar:@"巡场情况统计" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@""];
    }else{
        [self customNavigationBar:@"客诉情况统计" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@""];
    }
    [self sendRequestRecordData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    if (isRight) {
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(0, 0, 40, 30);
        [right setTitle:@"讲评" forState:UIControlStateNormal];
        [right setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
        right.titleLabel.font = [UIFont systemFontWithSize:14];
        [right addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    }
}
- (void)commentClick:(UIButton *)sender{
    [self shareToOther];
}
//分享
- (void)shareToOther
{
    NSLog(@"分享");
    UIImage *image = [UIImage imageNamed:@"placehold"];
    NSArray* imageArray = @[image];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if(imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (_isManage) {
            [shareParams SSDKSetupShareParamsByText:@"巡场管理讲评"
                                             images:imageArray
                                                url:[NSURL URLWithString:urlStr]
                                              title:@"管翼通"
                                               type:SSDKContentTypeAuto];
        }else{
            [shareParams SSDKSetupShareParamsByText:@"客诉处理讲评"
                                             images:imageArray
                                                url:[NSURL URLWithString:urlStr]
                                              title:@"管翼通"
                                               type:SSDKContentTypeAuto];
        }
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       NSLog(@"%@",error);
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [ShowAlter showAlertToController:self title:@"分享成功！" message:@"" buttonAction:@"取消" buttonBlock:^{
                                   
                               }];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               [ShowAlter showAlertToController:self title:@"分享失败！" message:@"" buttonAction:@"取消" buttonBlock:^{
                                   
                               }];
                               
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}
- (void)initUI:(NSString *)url{
    self.automaticallyAdjustsScrollViewInsets = NO;

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc]init];
    
    wkWebConfig.userContentController = wkUController;
    // 自适应屏幕宽度js
    
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 添加自适应屏幕宽度js调用的方法
    
    [wkUController addUserScript:wkUserScript];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64) configuration:wkWebConfig];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.view makeToast:@"加载失败！"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequestRecordData{
    if (_isManage) {
        module = @"1608";
    }else{
        module = @"1707";
    }
    NSString *str = @"<root><api><module>%@</module><type>0</type><query>{sdt=%@,edt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,module,_s_date,_e_date,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *urlArr = [doc nodesForXPath:@"//url" error:nil];
        if (urlArr.count>0) {
            for (DDXMLElement *item in urlArr) {
                [self initUI:item.stringValue];
                urlStr = item.stringValue;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
