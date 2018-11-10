//
//  MallDetilViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/10/28.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MallDetilViewController.h"
#import "UIBarButtonItem+UC.h"
#import "Masonry.h"
#import "UIColor+UC.h"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "XJHWechatSign.h"
#import "MJExtension.h"
#import "XJHPayMethodView.h"
#import "XJHUserStuffViewController.h"
#import "XJHOrderObject.h"

@interface MallDetilViewController () <XJHPayMethodViewDelegate,UIWebViewDelegate>

@property (nonatomic, readwrite, strong) UIView *payMethodViewBackgroundView;
@property (nonatomic, readwrite, strong) XJHPayMethodView *payMethodView;

@property (nonatomic, readwrite, copy) NSString *lastID; // 最后一次成功创建订单的时候返回的id 用来填到payCode里
@property (nonatomic, readwrite, assign) float payablePrice; // 最后一次成功创建订单的时候返回的价格

@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *nickname;
@property (nonatomic, readwrite, copy) NSString *avatar;

@end

@implementation MallDetilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"商品详情";
    _backScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backScrollView];
    _avatarImageView = [[UIImageView alloc]init];
    _firstHeadLable = [[UILabel alloc]init];
    _firstHeadLable.numberOfLines = 0;
    _firstHeadLable.textColor = [UIColor colorWithRed:42/255.0 green:41/255.0 blue:42/255.0 alpha:1.0];
    _secondHeadLable = [[UILabel alloc]init];
    _secondHeadLable.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:56/255.0 alpha:1.0];
    _thirdHeadLable = [[UILabel alloc]init];
    _thirdHeadLable.textColor = [UIColor colorWithRed:42/255.0 green:41/255.0 blue:42/255.0 alpha:1.0];
    
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
   // _webView.scrollView.scrollEnabled = NO;
    _webView.userInteractionEnabled = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    
    _buyButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    _buyButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:57/255.0 alpha:1.0];
    [_buyButton addTarget:self action:@selector(didTouchBuyButton) forControlEvents:UIControlEventTouchDown];
    
    [_backScrollView addSubview:_avatarImageView];
    _avatarImageView.backgroundColor = [UIColor grayColor];
    [_backScrollView addSubview:_firstHeadLable];
    [_backScrollView addSubview:_secondHeadLable];
    [_backScrollView addSubview:_thirdHeadLable];
    [_backScrollView addSubview:_webView];
    [self.view addSubview:_buyButton];
    
    _backScrollView.scrollEnabled = YES;
    
    [self setData:_dic];
    
    [self.view addSubview:self.payMethodViewBackgroundView];
    [self.view addSubview:self.payMethodView];
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(CGRectGetHeight(self.view.bounds)));
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.payMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(210);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateBackIfSuccess) name:@"WECHAT_PAY_SUCCESS" object:nil];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self makeConstrains];
}
- (void)makeConstrains
{
    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backScrollView.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@220);
    }];
    [_firstHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [_secondHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstHeadLable.mas_bottom).offset(10);
        make.left.equalTo(_avatarImageView.mas_left);
        make.right.equalTo(_avatarImageView.mas_right);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [_thirdHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondHeadLable.mas_bottom).offset(10);
        make.left.equalTo(_avatarImageView.mas_left);
        make.right.equalTo(_avatarImageView.mas_right);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thirdHeadLable.mas_bottom).offset(10);
        make.left.equalTo(_avatarImageView.mas_left);
        make.right.equalTo(_avatarImageView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)setData:(NSDictionary *)dic
{
    
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"productplaceholder.png"]];
    
    _firstHeadLable.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"name"],[dic objectForKey:@"resume"]];
    CGFloat p = [[dic objectForKey:@"price"] doubleValue];
    NSString *price = [NSString stringWithFormat:@"¥:%0.2f",p];
    _secondHeadLable.text = price;
    
    _thirdHeadLable.text = @"产品介绍";
    if (![[_dic objectForKey:@"detail"] isKindOfClass:[NSNull class]]) {
        [_webView loadHTMLString:[_dic objectForKey:@"detail"] baseURL:nil];
    }
}

#pragma mark -webview
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, newFrame.size.height);
    _backScrollView.contentSize = CGSizeMake(self.view.frame.size.width, newFrame.size.height + 320 + 64);
    
}

- (void)didTouchBuyButton {
    [self checkInfo];
}

#pragma mark - 检查信息

- (void)checkInfo {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    
    NSDictionary *dictionary = @{
                                 @"columns" : @[@"id", @"avatar", @"name", @"address"],
                                 @"order" : @{},
                                 @"filter" : @{@"id" : @{@"eq" : userID}},
                                 @"table" : @"Member"
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *data = [responseObject objectForKey:@"data"];
        if (data.count > 0) {
            NSDictionary *d = [data objectAtIndex:0];
            NSString *address = [d objectForKey:@"address"];
            NSString *nickname = [d objectForKey:@"name"];
            NSString *avatar = [d objectForKey:@"avatar"];
            
            if ([address isEqual:[NSNull null]] || [nickname isEqual:[NSNull null]]) {
                if ([address isEqual:[NSNull null]]) {
                    [self.view makeToast:@"请完善收货地址" duration:1.0 position:CSToastPositionTop];
                } else if ([nickname isEqual:[NSNull null]]) {
                    [self.view makeToast:@"请完善收货姓名" duration:1.0 position:CSToastPositionTop];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    XJHUserStuffViewController *viewController = [[XJHUserStuffViewController alloc] init];
                    viewController.address = address;
                    viewController.userName = nickname;
                    viewController.avatar = avatar;
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                });
                
                return ;
            }
            
            else if (address.length == 0 || nickname.length == 0) {
                if (address.length == 0) {
                    [self.view makeToast:@"请完善收货地址" duration:1.0 position:CSToastPositionTop];
                } else if (nickname.length == 0) {
                    [self.view makeToast:@"请完善收货姓名" duration:1.0 position:CSToastPositionTop];
                }
                
                // 复制了上边一块
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    XJHUserStuffViewController *viewController = [[XJHUserStuffViewController alloc] init];
                    viewController.address = address;
                    viewController.userName = nickname;
                    viewController.avatar = avatar;
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                });
                
                return ;
            }
            
            else if (address.length > 0 && nickname.length > 0) {
                
                self.address = address;
                self.nickname = nickname;
                self.avatar = avatar;
                
                if ([self.nickname isEqual:[NSNull null]]) {
                    self.nickname = @"";
                }
                
                // 下一步
                [self generateGoodsOrder];
            }
            
        } else {
            // 提示
            [self.view makeToast:@"请求失败" duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark - 生成订单

- (void)generateGoodsOrder {
    
    NSLog(@"%@", _dic);
    NSString *goodsID = [_dic objectForKey:@"id"];
    if ([goodsID isEqual:[NSNull null]]) {
        return ;
    }
    
    if (goodsID.length == 0) {
        return ;
    }
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSDictionary *dic = @{@"userId":userId, @"goodsId":goodsID, @"memberId": userId};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIGoodsOrder parameters:dic success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
//        2017-10-29 17:43:58.107706+0800 caxjh[7011:2383879] {
//            code = 0;
//            content = "\U8ba2\U5355\U521b\U5efa\U6210\U529f";
//            data =     {
//                actualPrice = "0.01";
//                goodsOrderId = bbb1af9e5f62fdb1015f67843361006c;
//                orderNumber = 20171029501704821743585193;
//            };
//            recordsFiltered = "<null>";
//            text = "\U8ba2\U5355\U521b\U5efa\U6210\U529f";
//            type = success;
//        }
        
        NSString *type = [responseObject objectForKey:@"type"];
        if ([type isEqualToString:@"success"]) {
            CGFloat price = [[[responseObject objectForKey:@"data"] objectForKey:@"actualPrice"] floatValue];
            NSString *orderid = [[responseObject objectForKey:@"data"] objectForKey:@"orderNumber"];
            
            if (price >= 0 && orderid.length > 0) {
                self.payablePrice = price;
                self.lastID = orderid;
                [self showPayMethodPopView];
            } else {
                NSLog(@"订单生成异常");
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark -

#pragma mark - 选择微信还是支付宝

// 选择支付方式的弹窗的位置

- (void)showPayMethodPopView {
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.payMethodView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
}

- (void)hidePayMethodPopView {
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(CGRectGetHeight(self.view.bounds)));
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.payMethodView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(210);
    }];
}

#pragma mark - 签名

- (NSDictionary *)dictionaryForMethod:(NSString *)method {
    NSString *goodsName = [_dic objectForKey:@"name"];
    if ([goodsName isEqual:[NSNull null]]) {
        goodsName = @"诚安相见孩";
    } else if (goodsName.length == 0) {
        goodsName = @"诚安相见孩";
    }
    NSDictionary *dictionary = @{
                                 @"toPay" : [NSString stringWithFormat:@"%.2f", self.payablePrice],
                                 @"payCode" : self.lastID,
                                 @"sellerCode" : @"",
                                 @"sellerName" : @"",
                                 @"orderCode" : goodsName,
                                 @"invalidTime" : @"",
                                 @"createTime" : @"",
                                 @"onLineStyle" : method,
                                 @"browseType" : @"app"
                                 };
    return dictionary;
}

- (void)authAlipay {
    
    NSDictionary *dictionary = [self dictionaryForMethod:@"alipay"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    
    [PPNetworkHelper POST:kAPISignURl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *sign = [[responseObject objectForKey:@"data"] objectForKey:@"signature"];
        if (sign.length > 0) {
            [self aliPayWithSign:sign];
        } else {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)authWechat {
    
    NSDictionary *dictionary = [self dictionaryForMethod:@"wechat"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    
    [PPNetworkHelper POST:kAPISignURl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *sign = [[responseObject objectForKey:@"data"] objectForKey:@"signature"];
        if (sign.length > 0) {
            [self wechatPayWithSign:sign];
        } else {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 调起支付

- (void)aliPayWithSign:(NSString *)sign {
    [[AlipaySDK defaultService] payOrder:sign fromScheme:@"xjh" callback:^(NSDictionary *resultDic) {
        
        // 只要有起调，不管结果是什么，就通知一下，用来刷新套餐
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XJH_PAYMENT_HAVE_RESULT" object:nil];
        
        NSLog(@"alipay result = %@", resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            [self.view makeToast:@"订单支付成功" duration:2.0 position:CSToastPositionTop];
            
            [self navigateBackIfSuccess];
        }
        
        else if ([resultStatus isEqualToString:@"8000"]) {
            [self.view makeToast:@"正在处理中，支付结果未知" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"4000"]) {
            [self.view makeToast:@"订单支付失败" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"5000"]) {
            [self.view makeToast:@"重复请求" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6001"]) {
            [self.view makeToast:@"用户中途取消" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6002"]) {
            [self.view makeToast:@"网络连接出错" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6004"]) {
            [self.view makeToast:@"支付结果未知" duration:2.0 position:CSToastPositionTop];
        }
        
        else {
            [self.view makeToast:@"其他支付错误" duration:2.0 position:CSToastPositionTop];
        }
        
    }];
}

- (void)wechatPayWithSign:(NSString *)sign {
    // [WXApi registerApp:@"wxa1fbfdb142a2f2e1"];
    
    XJHWechatSign *wechatSign = [XJHWechatSign mj_objectWithKeyValues:sign];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wechatSign.partnerid;
    request.prepayId = wechatSign.prepayid;
    request.nonceStr = wechatSign.noncestr;
    request.timeStamp = [wechatSign.timestamp longLongValue];
    request.package = @"Sign=WXPay";
    request.sign = wechatSign.sign;
    
    [WXApi sendReq:request];
}

#pragma mark - XJHPayMethodViewDelegate

- (void)confirmWithMethod:(NSUInteger)method {
    [self hidePayMethodPopView];
    
    if (method == 1) {
        [self authAlipay];
    }
    
    else if (method == 2) {
        [self authWechat];
    }
}

#pragma mark -

- (UIView *)payMethodViewBackgroundView {
    if (!_payMethodViewBackgroundView) {
        _payMethodViewBackgroundView = [[UIView alloc] init];
        _payMethodViewBackgroundView.backgroundColor = [[UIColor colorWithHex:@"#000000"] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchPayMethodBackgroundView)];
        [_payMethodViewBackgroundView addGestureRecognizer:recognizer];
    }
    return _payMethodViewBackgroundView;
}

- (void)didTouchPayMethodBackgroundView {
    [self hidePayMethodPopView];
}

- (XJHPayMethodView *)payMethodView {
    if (!_payMethodView) {
        _payMethodView = [[XJHPayMethodView alloc] init];
        _payMethodView.delegate = self;
    }
    return _payMethodView;
}

#pragma mark - 回去

- (void)navigateBackIfSuccess {
    [self performSelector:@selector(navigateBack) withObject:nil afterDelay:2.0];
}

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
