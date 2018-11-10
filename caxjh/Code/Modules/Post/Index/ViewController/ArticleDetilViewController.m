//
//  ArticleDetilViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/31.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "ArticleDetilViewController.h"
#import "UIBarButtonItem+UC.h"
#import "UIColor+EAHexColor.h"
#import "UIImageView+WebCache.h"
@interface ArticleDetilViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UILabel *nameLable;
@property (nonatomic,strong)UILabel *sourceLable;
@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIView *bgInfoView;
@property (nonatomic,strong)UILabel *lostLable;
@property (nonatomic,strong)UILabel *childnameLable;
@property (nonatomic,strong)UILabel *ageLable;
@property (nonatomic,strong)UILabel *lostTimeLable;
@property (nonatomic,strong)UIImageView *avatarView;
@property (nonatomic,strong)UIScrollView *backScrollView;
@end

@implementation ArticleDetilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文章详情";
//    if (_type == ArticleTypeVIP) {
//        self.title = @"幼儿园热点事件";
//    }
    _backScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backScrollView];
    self.view.backgroundColor = [UIColor whiteColor];
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 30)];
    _nameLable.textColor = [UIColor blackColor];
    _nameLable.text = [_dic objectForKey:@"name"];
    [_backScrollView addSubview:_nameLable];
    
    _sourceLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, 100, 30)];
    if (![[_dic objectForKey:@"publishingSource"] isEqual:[NSNull null]]) {
        _sourceLable.text = [_dic objectForKey:@"publishingSource"];
    }
    
    _sourceLable.textColor = [UIColor grayColor];
    [_backScrollView addSubview:_sourceLable];
    
    _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-180, 60, 180, 30)];
    _timeLable.textColor = [UIColor grayColor];
    _timeLable.text = [self cStringFromTimestamp:[[_dic objectForKey:@"createTime"] longValue]/1000];
    [_backScrollView addSubview:_timeLable];
    
       self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setuplostinfo];
}
- (void)setuplostinfo
{
    
    
    if (_type == ArticleTypeLost) {
        
    
    _bgInfoView = [[UIView alloc]initWithFrame:CGRectMake(15, 110, self.view.frame.size.width - 30, 124)];
    _bgInfoView.backgroundColor = [UIColor colorWithHex:@"#ecf9ff"];
    _bgInfoView.layer.cornerRadius = 3;
    _bgInfoView.layer.masksToBounds = YES;
    [_backScrollView addSubview:_bgInfoView];
    
    _lostLable = [[UILabel alloc]init];
    _childnameLable = [[UILabel alloc]init];
    _ageLable  = [[UILabel alloc]init];
    _lostLable = [[UILabel alloc]init];
    _avatarView = [[UIImageView alloc]init];
    
    
    _avatarView.frame = CGRectMake(12, 6, 100, 100);
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"image"]]];
    [_bgInfoView addSubview:_avatarView];
    
    _lostLable.text = @"走失儿童档案";
    _lostLable.textColor = [UIColor colorWithHex:@"#333333"];
    _lostLable.font = [UIFont systemFontOfSize:16];
    _lostLable.frame = CGRectMake(0, 10, 100, 40);
    [_bgInfoView addSubview:_lostLable];
    _lostLable.center = CGPointMake(_bgInfoView.center.x + 56, _lostLable.center.y);
    
    _childnameLable.frame = CGRectMake(142, 50, 100, 20);
    _childnameLable.font = [UIFont systemFontOfSize:14];
    _childnameLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];
    _childnameLable.text = [NSString stringWithFormat:@"姓名:%@",[_dic objectForKey:@"childName"]] ;
    [_bgInfoView addSubview:_childnameLable];
        
        _ageLable.frame = CGRectMake(142, 70, 100, 20);
        _ageLable.font = [UIFont systemFontOfSize:14];
        _ageLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];
        int age =(int) [[_dic objectForKey:@"childAge"] longValue];
        _ageLable.text = [NSString stringWithFormat:@"年龄:%d",age];
        [_bgInfoView addSubview:_ageLable];
        
        _lostTimeLable = [[UILabel alloc]init];
        _lostTimeLable.frame = CGRectMake(142, 90, 200, 20);
        _lostTimeLable.font = [UIFont systemFontOfSize:14];
        _lostTimeLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];

        _lostTimeLable.text = [NSString stringWithFormat:@"失踪时间:%@", [self cStringFromTimestamp:[[_dic objectForKey:@"missingTime"] longValue]/1000]];
        [_bgInfoView addSubview:_lostTimeLable];
    
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 224, self.view.bounds.size.width, self.view.bounds.size.height-224)];
        _webView.delegate = self;
        [_backScrollView addSubview:_webView];
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView loadHTMLString:[_dic objectForKey:@"detail"] baseURL:nil];
    }else{
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-120)];
        [_backScrollView addSubview:_webView];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView loadHTMLString:[_dic objectForKey:@"detail"] baseURL:nil];
        
        
    }
    _webView.userInteractionEnabled = NO;
    
}
#pragma mark -webview
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    _backScrollView.contentSize = CGSizeMake(self.view.frame.size.width, newFrame.size.height + 64 + 44 + 64);
    if(_type == ArticleTypeLost)
    {
    _backScrollView.contentSize = CGSizeMake(self.view.frame.size.width, newFrame.size.height + 64 + 44 + 64 + 124);
        
    }
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, newFrame.size.height + 64);
 
    
}
-(NSString *)cStringFromTimestamp:(long)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

@end
