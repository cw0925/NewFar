//
//  CommentViewController.m
//  NewAfar
//
//  Created by cw on 16/10/12.
//  Copyright © 2016年 afarsoft. All rights reserved.
//
#import "CommentViewController.h"
#import "EulogyModel.h"
#import "WorkplaceModel.h"
#import "PhotosContainerView.h"
#import "CommentModel.h"
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface CommentViewController ()<UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *nameArr;
@property(nonatomic,copy)NSMutableArray *commentArr;

@property(nonatomic,copy)NSMutableString *prasie_str;

@end

@implementation CommentViewController
{
    UIImageView *icon;
    UILabel *user_name;
    UILabel *postion;
    UILabel *dateTime;
    UILabel *content;
    PhotosContainerView *_photosContainer;
    UILabel *praise;
    
    UIView *commentView;
    UITextField *commentTf;
    UIView *bgView;
    
    NSUInteger name_length;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager   sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"评论" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    NSLog(@"%@",_dataModel.c_id);
    [self initUI];
    
    [self addNotification];
}
- (void)refresh:(PassValueBlock)block{
    self.passBlock = block;
}
- (void)backPage{
    [super backPage];
    if (self.passBlock != nil) {
        self.passBlock(self.commentArr.count,self.nameArr.count);
    }
}
#pragma mark - 输入框随键盘移动
- (void)onKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardRect            = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight         = MIN(CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
    
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        bgView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight+BottomHeight);
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options \
                     animations:^{
                         bgView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}
- (void)addNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(onKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self
               selector:@selector(onKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
}
- (void)initUI
{
    
    UIScrollView *scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0,45, 0));
    
    icon = [UIImageView new];
//    NSString *str = _dataModel.tx;
//    NSString *tx = [str stringByReplacingOccurrencesOfString:@"app.afarsoft.com" withString:@"192.168.0.54:8894"];
    [icon sd_setImageWithURL:[NSURL URLWithString:_dataModel.tx] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        icon.image = [image circleImage];
    }];
    
    user_name = [UILabel new];
    user_name.text = _dataModel.name;
    user_name.font = [UIFont systemFontWithSize:14];
    user_name.textColor = RGBColor(93, 106, 146);
    
    postion = [UILabel new];
    postion.text = _dataModel.zw;
    postion.textColor = [UIColor lightGrayColor];
    postion.font = [UIFont systemFontWithSize:12];
    
    dateTime = [UILabel new];
    dateTime.textColor = [UIColor lightGrayColor];
    dateTime.textAlignment = NSTextAlignmentRight;
    //date.text = _dataModel.sj;
    dateTime.font = [UIFont systemFontWithSize:11];
    // x分钟前/x小时前/x天前/x个月前/x年前
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *dateS =[dateFormat dateFromString:_dataModel.sj];
    
    dateTime.text = [self lastTimeOfChat:dateS];
    
    content = [UILabel new];
    content.text = _dataModel.nr;
    content.font = [UIFont systemFontWithSize:13];
    content.numberOfLines = 0;
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    
    if ([_dataModel.tp isEqualToString:@""]||[_dataModel.tp isEqualToString:@"0"]) {
        _photosContainer.hidden = YES;
    }else{
        _photosContainer.hidden = NO;
        NSArray *iconArr = [_dataModel.tp componentsSeparatedByString:@","];
        _photosContainer.photoNamesArray = iconArr;
    }
    UILabel *location = [UILabel new];
    if ([_dataModel.c_position isEqualToString:@"所在位置"]) {
        location.text = @"";
    }else{
        location.text = _dataModel.c_position;
    }
    location.textColor = RGBColor(93, 106, 146);
    location.font = [UIFont systemFontWithSize:11];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *shareImg = [UIImageView new];
    shareImg.image = [UIImage imageNamed:@"fenxiang"];

    UILabel *shareTxt = [UILabel new];
    shareTxt.text = @"分享";
    shareTxt.font = [UIFont systemFontWithSize:11];
    
    [shareBtn sd_addSubviews:@[shareImg,shareTxt]];
    
    shareImg.sd_layout.leftSpaceToView(shareBtn,2).topSpaceToView(shareBtn,8).widthIs(15).heightIs(15);
    
    shareTxt.sd_layout.leftSpaceToView(shareImg,2).topSpaceToView(shareBtn,6).rightSpaceToView(shareBtn,2).heightIs(20);
    
    UIButton *praiseBtn = [UIButton new];
    [praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *praiseImg = [UIImageView new];
    praiseImg.image = [UIImage imageNamed:@"support"];
    
    UILabel *praiseTxt = [UILabel new];
    praiseTxt.text = @"赞";
    praiseTxt.font = [UIFont systemFontWithSize:11];
    
    [praiseBtn sd_addSubviews:@[praiseImg,praiseTxt]];
    
    praiseImg.sd_layout.leftSpaceToView(praiseBtn,2).topSpaceToView(praiseBtn,8).widthIs(15).heightIs(15);
    
    praiseTxt.sd_layout.leftSpaceToView(praiseImg,6).topSpaceToView(praiseBtn,6).rightSpaceToView(praiseBtn,2).heightIs(20);
    
    praise = [UILabel new];
    praise.numberOfLines = 0;
    praise.font = [UIFont systemFontWithSize:11];
    
    
    commentView = [UIView new];
//    comment = [UILabel new];
//    comment.numberOfLines = 0;
//    comment.font = [UIFont systemFontWithSize:11];
    
    [scroll sd_addSubviews:@[icon,user_name,postion,dateTime,content,_photosContainer,location,shareBtn,praiseBtn,praise,commentView]];
    //评论框
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-45-BottomHeight, ViewWidth, 45)];
    bgView.backgroundColor = [UIColor lightGrayColor];
   // view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bgView];
    
    commentTf = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, ViewWidth-10, 35)];
    commentTf.font = [UIFont systemFontWithSize:13];
    commentTf.delegate = self;
    commentTf.returnKeyType = UIReturnKeySend;
    commentTf.placeholder = @"请输入评论内容";
    commentTf.borderStyle = UITextBorderStyleRoundedRect;
    [bgView addSubview:commentTf];
    
    CGFloat margin = 10.0;
    
    icon.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(scroll,margin).heightIs(40).widthIs(40);
    
    //user_name.backgroundColor = [UIColor redColor];
    user_name.sd_layout.leftSpaceToView(icon,margin).topSpaceToView(scroll,margin).rightSpaceToView(dateTime,margin).heightIs(20);
    
    //date.backgroundColor = [UIColor greenColor];
    dateTime.sd_layout.topSpaceToView(scroll,margin).rightSpaceToView(scroll,margin).widthIs(150).heightIs(20);
    
    //postion.backgroundColor = [UIColor purpleColor];
    postion.sd_layout.leftSpaceToView(icon,margin).topSpaceToView(user_name,5).rightSpaceToView(scroll,margin).heightIs(20);
    
    content.sd_layout.leftEqualToView(user_name).topSpaceToView(postion,margin).rightSpaceToView(scroll,margin).autoHeightRatio(0);
    
    _photosContainer.sd_layout.leftEqualToView(user_name).topSpaceToView(content,margin).rightSpaceToView(scroll,margin);
    
    location.sd_layout.leftEqualToView(user_name).topEqualToView(praiseBtn).rightSpaceToView(praiseBtn,5).heightIs(30);
    
    if (_photosContainer.hidden) {
        shareBtn.sd_layout.rightSpaceToView(scroll,margin).topSpaceToView(content,margin).widthIs(50).heightIs(30);
        
        praiseBtn.sd_layout.rightSpaceToView(shareBtn,5).topSpaceToView(content,margin).widthIs(45).heightIs(30);
    }else{
        shareBtn.sd_layout.rightSpaceToView(scroll,margin).topSpaceToView(_photosContainer,margin).widthIs(50).heightIs(30);
        
        praiseBtn.sd_layout.rightSpaceToView(shareBtn,5).topSpaceToView(_photosContainer,margin).widthIs(45).heightIs(30);
    }
        
    
    praise.sd_layout.leftEqualToView(user_name).topSpaceToView(shareBtn,margin).rightSpaceToView(scroll,margin).autoHeightRatio(0);
    
    commentView.sd_layout.leftEqualToView(user_name).topSpaceToView(praise,margin).rightSpaceToView(scroll,margin);
    
    [scroll setupAutoHeightWithBottomViewsArray:@[praiseBtn,shareBtn,praise,commentView] bottomMargin:margin];
    
    [self sendRequestCheckPraiseData:_dataModel.c_newid];
    [self sendRequestCheckCommentData:_dataModel.c_newid];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollGesture:)];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:gesture];
    
}
- (void)scrollGesture:(UITapGestureRecognizer *)gesture{
    [commentTf resignFirstResponder];
}
- (void)praiseClick:(UIButton *)sender
{
    if ([_dataModel.c_tel isEqualToString:[userDefault valueForKey:@"name"]]) {
        [self sendRequestPressPraiseData:_dataModel.c_newid phone:@""];
    }else{
        [self sendRequestPressPraiseData:_dataModel.c_newid phone:_dataModel.c_tel];
    }
}
//分享
- (void)shareClick:(UIButton *)sender
{
    NSLog(@"分享");
    NSArray* imageArray = @[_dataModel.tx];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if(imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_dataModel.nr
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%AE%A1%E7%BF%BC%E9%80%9A/id1144062674?mt=8"]
                                          title:_dataModel.name
                                           type:SSDKContentTypeAuto];
        //设置新浪的分享参数
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@  %@",arr[i],@"https://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"] title:nil image:[UIImage imageNamed:@"Icon"] url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
//        //设置微信的分享参数
//        [shareParams SSDKSetupWeChatParamsByText:nil title:arr[i] url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"] thumbImage:nil image:[UIImage imageNamed:@"Icon"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
//        //设置qq的分享参数
//        [shareParams SSDKSetupQQParamsByText:@"" title:arr[i] url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"] thumbImage:[UIImage imageNamed:@"Icon"] image:[UIImage imageNamed:@"Icon"] type:SSDKContentTypeAuto  forPlatformSubType:SSDKPlatformSubTypeQZone];
        // 定制新浪微博的分享内容
        //[shareParams SSDKSetupSinaWeiboShareParamsByText:@"管翼通" title:nil image:[UIImage imageNamed:@""] url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yi-tong/id1144062674?mt=8"] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        //设置简单分享菜单样式(九宫格样式)
        //[SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
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
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        if ([_dataModel.c_tel isEqualToString:[userDefault valueForKey:@"name"]]) {
            [self sendRequestPublicCommentData:_dataModel.c_newid phone:@""];
        }else{
            [self sendRequestPublicCommentData:_dataModel.c_newid phone:_dataModel.c_tel];
        }
        [commentTf resignFirstResponder];
        commentTf.text = @"";
    }
    return YES;
}
#pragma mark - 计算时间
- (NSString *)lastTimeOfChat:(NSDate *)date {
    
    NSString *str = @" ";
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:date];
    //北京时间加8小时  除以86400得到的是天数
    if ((timeInterval + 60*60*8) / 86400 > 1 && (timeInterval + 60*60*8) / 86400 < 30) {
        
        NSString *min2 =  [NSString stringWithFormat:@"%d天前",(int)(timeInterval + 60*60*8) / 86400];
        str = min2;
    }
    //今天
    else if ((timeInterval + 60*60*8) / 86400 < 1) {
        
        if (timeInterval < 60) {
            str = @"刚刚";
        }
        else if(60 < timeInterval && timeInterval < 3600){
            NSString *min2 =  [NSString stringWithFormat:@"%d分钟前",(int)timeInterval/60];
            str = min2;
        }
        else{
            NSString *min2 =  [NSString stringWithFormat:@"%d小时前",(int)timeInterval/60/60];
            str = min2;
        }
    }
    //一年前
    else if ((timeInterval + 60*60*8) / 2592000 >12){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        str = [dateFormatter stringFromDate:date];
    }
    //一个月前
    else if ((timeInterval + 60*60*8) / 86400 > 30) {
        NSString *min2 =  [NSString stringWithFormat:@"%d个月前",(int)(timeInterval + 60*60*8) / 2592000];
        str = min2;
    }
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [commentTf resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查看赞
- (void)sendRequestCheckPraiseData:(NSString *)c_id
{
    if (_nameArr.count >0||_prasie_str) {
        [_nameArr removeAllObjects];
        [_prasie_str replaceCharactersInRange:NSMakeRange(0, _prasie_str.length) withString:@""];
        NSLog(@"%@",_prasie_str);
    }
    NSString *str = @"<root><api><module>1204</module><type>0</type><query>{type=1,c_newid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,c_id,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *item in rowArr) {
            DDXMLElement *name = [item elementsForName:@"name"][0];
            [self.nameArr addObject:name.stringValue];
        }
        
        if (_nameArr.count == 0) {
            praise.text = @"";
        }else{
            for (NSString *item_str in _nameArr) {
                [self.prasie_str appendFormat:@"%@、",item_str];
            }
            [_prasie_str deleteCharactersInRange:NSMakeRange(_prasie_str.length-1, 1)];
             praise.text = [NSString stringWithFormat:@"♥️ %@ 觉得很赞",_prasie_str];
            NSLog(@"%@",_prasie_str);
        }
       
    } failure:^(NSError *error) {
        
    }];
}
//点赞
- (void)sendRequestPressPraiseData:(NSString *)c_id phone:(NSString *)phone
{
    //<root><api><module>1204</module><type>0</type><query>{type=2,c_newid=0477421492564096,alias=}</query></api><user><company></company><customeruser>18300602014</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    NSString *str = @"<root><api><module>1204</module><type>0</type><query>{type=2,c_newid=%@,alias=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,c_id,phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self sendRequestCheckPraiseData:c_id];
            [self.view makeToast:element.stringValue];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//查看评论
- (void)sendRequestCheckCommentData:(NSString *)c_id
{
    NSString *str = @"<root><api><module>1203</module><type>0</type><query>{type=1,c_newid=%@,content=,alias=}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,c_id,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            CommentModel *model = [[CommentModel alloc]init];
            DDXMLElement *name = [element elementsForName:@"name"][0];
            model.name = name.stringValue;
            DDXMLElement *nr = [element elementsForName:@"nr"][0];
            model.nr = nr.stringValue;
            [self.commentArr addObject:model];
        }
        
        UILabel *bottomLabel = nil;
        
        for (NSInteger i=0; i<_commentArr.count; i++) {
            
            CommentModel *model = _commentArr[i];
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontWithSize:11];
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",model.name,model.nr]];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBColor(93, 106, 146) range:NSMakeRange(0, model.name.length)];
            label.attributedText = attributeStr;
            [commentView addSubview:label];
            
            label.sd_layout.leftSpaceToView(commentView,0).topSpaceToView(bottomLabel,5).rightSpaceToView(commentView,0).autoHeightRatio(0);
            
            bottomLabel = label;
            
        }
        [commentView setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];

    } failure:^(NSError *error) {
        
    }];
}
//发表评论
- (void)sendRequestPublicCommentData:(NSString *)c_id phone:(NSString *)phone
{
    for (UIView *view in commentView.subviews) {
        [view removeFromSuperview];
    }
    if (_commentArr.count >0) {
        [_commentArr removeAllObjects];
    }
    NSString *str = @"<root><api><module>1203</module><type>0</type><query>{type=2,c_newid=%@,content=%@,alias=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,c_id,commentTf.text,phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
            if ([element.stringValue isEqualToString:@"评论成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    CommentModel *model = [[CommentModel alloc]init];
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    model.nr = nr.stringValue;
                    [self.commentArr addObject:model];
                }
                UILabel *bottomLabel = nil;
                
                for (NSInteger i=0; i<_commentArr.count; i++) {
                    
                    CommentModel *model = _commentArr[i];
                    UILabel *label = [UILabel new];
                    label.font = [UIFont systemFontWithSize:11];
                    
                    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",model.name,model.nr]];
                    [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBColor(93, 106, 146) range:NSMakeRange(0, model.name.length)];
                    label.attributedText = attributeStr;
                    [commentView addSubview:label];
                    
                    label.sd_layout.leftSpaceToView(commentView,0).topSpaceToView(bottomLabel,5).rightSpaceToView(commentView,0).autoHeightRatio(0);
                    
                    bottomLabel = label;
                    
                }
                [commentView setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];
            }
        }
       
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)nameArr
{
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
- (NSMutableString *)prasie_str
{
    if (!_prasie_str) {
        _prasie_str = [NSMutableString string];
    }
    return _prasie_str;
}
- (NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
