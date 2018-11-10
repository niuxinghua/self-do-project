//
//  MallDetilViewController.h
//  caxjh
//
//  Created by niuxinghua on 2017/10/28.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHBaseViewController.h"

@interface MallDetilViewController : XJHBaseViewController
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *firstHeadLable;
@property (nonatomic,strong)UILabel *secondHeadLable;
@property (nonatomic,strong)UILabel *thirdHeadLable;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIButton *buyButton;
@end
