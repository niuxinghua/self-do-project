//
//  RegisterViewController.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BaseViewController.h"
#import "Const.h"
#import "Masonry.h"
#import "RegisterItemView.h"
#import "XWCountryCodeController.h"
@interface RegisterViewController : BaseViewController
@property(nonatomic, strong) RegisterItemView *introView;

@property(nonatomic, strong) RegisterItemView *enterTeleView;

@property(nonatomic, strong) RegisterItemView *enterVerify;

@property(nonatomic, strong) RegisterItemView *enterPassView;

@property(nonatomic, strong) RegisterItemView *enterPassViewAgain;

@property(nonatomic, strong) UIButton *registerButton;

@end
