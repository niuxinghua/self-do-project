//
//  BindAdminiViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BindAdminiViewController.h"
#import "CustomEnterView.h"
#import "Masonry.h"
#import "UCQRCodeViewController.h"
#import "BlueToothManager.h"
@interface BindAdminiViewController ()

@property (nonatomic,strong)CustomEnterView *enterView;

@property (nonatomic,strong)UIButton *bindButton;

@property (nonatomic,strong)UIImageView *textImageView;


@property (nonatomic,strong)UILabel *flable;

@property (nonatomic,strong)UILabel *slable;

@property (nonatomic,strong)UILabel *tlable;

@property (nonatomic,strong)UILabel *fourlable;

@property (nonatomic,strong)UILabel *fivelable;

@property (nonatomic,strong)UIView *lineView;

@end

@implementation BindAdminiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
    [self.navigationController setNavigationBarHidden:NO];
    _enterView = [[CustomEnterView alloc]initWithFrame:CGRectMake(0, 100, 300, 40)];
    [_enterView setPlaceHolder:[kMultiTool getMultiLanByKey:@"shurusuodizhi"]];
    
    _enterView.scanBlock = ^{
      
        UCQRCodeViewController *controller = [[UCQRCodeViewController alloc]init];
        controller.backBlock = ^(NSString *icon) {
            _enterView.editTextField.text = icon;
        };
        [self.navigationController pushViewController:controller animated:NO];
        
    };
    
    _bindButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 80, 40)];
    [_bindButton addTarget:self action:@selector(bind) forControlEvents:UIControlEventTouchUpInside];
    [_bindButton setTitle:[kMultiTool getMultiLanByKey:@"bindadmin"] forState:UIControlStateNormal];
    [_bindButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forState:UIControlStateNormal];
    [_bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bindButton.layer.cornerRadius = 10;
    _bindButton.layer.masksToBounds = YES;
    [self.view addSubview:_bindButton];
    [self.view addSubview:_enterView];
    _textImageView = [[UIImageView alloc]init];
    _textImageView.image = [UIImage imageNamed:@"textimage"];
    [self.view addSubview:_textImageView];
    
   // bindsuccess
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popself) name:@"bindsuccess" object:nil];
    
    
    _flable = [[UILabel alloc]init];
    _flable.textColor = UICOLOR_HEX(0x727973);
    _flable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_flable];
    [_flable setText:[kMultiTool getMultiLanByKey:@"caozuovbuzhou"]];
    
    
    _slable = [[UILabel alloc]init];
    [self.view addSubview:_slable];
    _slable.textColor = UICOLOR_HEX(0x727973);
    _slable.font = [UIFont systemFontOfSize:12];
    
    [_slable setText:[kMultiTool getMultiLanByKey:@"tianjiasuo1"]];
    
    _tlable = [[UILabel alloc]init];
    [self.view addSubview:_tlable];
    _tlable.textColor = UICOLOR_HEX(0x727973);
    _tlable.font = [UIFont systemFontOfSize:12];
    
    [_tlable setText:[kMultiTool getMultiLanByKey:@"tianjiasuo2"]];
    
    
    _fourlable = [[UILabel alloc]init];
    [self.view addSubview:_fourlable];
    _fourlable.textColor = UICOLOR_HEX(0x727973);
    _fourlable.font = [UIFont systemFontOfSize:12];
    [_fourlable setText:[kMultiTool getMultiLanByKey:@"tianjiasuo3"]];
    
    
    _fivelable = [[UILabel alloc]init];
    [self.view addSubview:_fivelable];
    _fivelable.textColor = UICOLOR_HEX(0x727973);
    _fivelable.font = [UIFont systemFontOfSize:12];
    [_fivelable setText:[kMultiTool getMultiLanByKey:@"tianjiasuo4"]];
    
    _lineView = [[UIView alloc]init];
    [self.view addSubview:_lineView];
    [self makeConstrains];
    
    
    
}
- (void)popself
{
    [kWINDOW hideToastActivity];
    [LockStoreManager sharedManager].selectedLock = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deletesuccess" object:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)bind{
    if (_enterView.editTextField.text && _enterView.editTextField.text.length) {
      [self.view endEditing:YES];
         [kWINDOW makeToastActivity:CSToastPositionCenter];
         [[BlueToothManager sharedManager] BindAdmin:_enterView.editTextField.text];
        
        
    }else{
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurusuodizhi"] ];
    }
   
    
    
}
- (void)makeConstrains
{
    [_enterView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@280);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(100);
        
    }];
    [_bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_enterView.mas_bottom).offset(60);
        
    }];
   

//    [_textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(40);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.bottom.equalTo(self.view);
//        make.top.equalTo(_bindButton.mas_bottom).offset(20);
//    }];
//    _textImageView.contentMode = UIViewContentModeCenter;
    [_fivelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [_fourlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.bottom.equalTo(_fivelable.mas_top);
    }];
    [_tlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.bottom.equalTo(_fourlable.mas_top);
    }];
    [_slable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.bottom.equalTo(_tlable.mas_top);
    }];
    [_flable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
        make.bottom.equalTo(_slable.mas_top);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_flable.mas_top).offset(-30);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
  
   
    
}

- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"bindadmin"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self popself];
        
    }];
    
}



@end
