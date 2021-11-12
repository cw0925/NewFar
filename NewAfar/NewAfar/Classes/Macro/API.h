//
//  API.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#ifndef API_h
#define API_h

/**UUID*/
//设备的UUID（app卸载重装也不会改变,通用-还原-抹掉所有内容和设置会改变）
//2.Target-Capabilities-Keychain Sharing-ON  未设置
#define UUID [GenerateUUID generateDeviceUniqueIdentifier]
//#define UUID @"lblblblblblbtt"
//当前日期
#define Date [CurrentDate getCurrentDate]
/**
 *  一期相关接口
 */
#define FirstBaseURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFace",[userDefault valueForKey:@"domain"]]
//加载信息
#define InfoURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFace/AppQueryInfo",[userDefault valueForKey:@"domain"]]
/**
 *  二期相关接口
 */
#define BaseURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo",[userDefault valueForKey:@"domain"]]
//搜索
#define SearchURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo/MoHuSelect",[userDefault valueForKey:@"domain"]]
//加载查询信息
#define LoadInfoURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo/AppQueryTwo",[userDefault valueForKey:@"domain"]]
//上传图片
#define uploadURL [NSString stringWithFormat:@"http://%@/AppInterface/ImageService.aspx",[userDefault valueForKey:@"domain"]]
//判断用户是否绑定企业
#define BindCompanyURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo/Ifbangding",[userDefault valueForKey:@"domain"]]
//验证码
#define CodeURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo/SendCode",[userDefault valueForKey:@"domain"]]
//忘记密码
#define FindURL [NSString stringWithFormat:@"http://%@/AppInterface/AppService.svc/AppFaceTwo/ChangePWD",[userDefault valueForKey:@"domain"]]
//轮播图
#define ScrollXML @"<root><api><module>0000</module><type>0</type><querytype>10</querytype><query>[c_name like '%%']</query></api><user><company/><customeruser/></user></root>"
//登录
#define LoginXML @"<root><api><module>1002</module><type>0</type><query>{psw=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>"
//验证码
#define CodeXML @"<root><api><module>1001</module><type>0</type></api><user><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>"
//通讯录
#define AddressbookXML @"<root><api><module>1104</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>"
//职场圈
#define WorkplaceXML @"<root><api><module>1201</module><type>0</type><query>{type=0}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>"
//商翼客服
#define ServiceURL @"http://mp.weixin.qq.com/s?__biz=MjM5NzE1NDkwMg==&mid=400985765&idx=1&sn=54c21db1036ccbd2267750c7bba97fa3&scene=4#wechat_redirect"
#endif /* API_h */
