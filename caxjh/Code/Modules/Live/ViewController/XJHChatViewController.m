//
//  XJHChatViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHChatViewController.h"
#import "UIViewController+PlaceHolderImageView.h"
#import <IQKeyboardManager.h>
#import "UIViewController+StatusBar.h"
#import "UIView+Toast.h"

@interface XJHChatViewController ()

@property (nonatomic, readwrite, assign) CGFloat valueForDefaultStatus;

@end

@implementation XJHChatViewController

- (void)openSystemCamera {
    [[UIApplication sharedApplication].keyWindow makeToast:@"拍摄功能暂时不可用" duration:1.0 position:CSToastPositionCenter];
}

#pragma mark -

- (UIBarButtonItem *)uc_backBarButtonItemWithAction:(void (^)())action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"下返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"下返回"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button bk_addEventHandler:^(id sender) {
        action();
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [self uc_backBarButtonItemWithAction:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self setStatusBarDefaultColor];
    
    self.title = @"家人同看共议";
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    self.conversationMessageCollectionView.frame = CGRectMake(CGRectGetMinX(self.conversationMessageCollectionView.frame),
//                                                              CGRectGetMinY(self.conversationMessageCollectionView.frame),
//                                                              CGRectGetWidth(self.view.frame),
//                                                              100);
//    self.chatSessionInputBarControl.frame = CGRectMake(CGRectGetMinX(self.conversationMessageCollectionView.frame),
//                                                       CGRectGetMaxY(self.conversationMessageCollectionView.frame),
//                                                       CGRectGetWidth(self.conversationMessageCollectionView.frame),
//                                                       CGRectGetHeight(self.chatSessionInputBarControl.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)chatInputBar:(RCChatSessionInputBarControl *)chatInputBar shouldChangeFrame:(CGRect)frame {
//
//        if (frame.origin.y > self.valueForDefaultStatus && chatInputBar.currentBottomBarStatus == KBottomBarDefaultStatus) {
//            self.valueForDefaultStatus = frame.origin.y;
//
//            self.chatSessionInputBarControl.frame = CGRectMake(0,
//                                                               400  - 50,
//                                                               CGRectGetWidth(frame),
//                                                               CGRectGetHeight(self.chatSessionInputBarControl.frame));
//            self.conversationMessageCollectionView.frame = CGRectMake(0,
//                                                                      0,
//                                                                      CGRectGetWidth(frame),
//                                                                      self.chatSessionInputBarControl.frame.origin.y);
//        }
//
//        else if (frame.origin.y < self.valueForDefaultStatus) {
//            self.chatSessionInputBarControl.frame = CGRectMake(0,
//                                                               400  - CGRectGetHeight(self.chatSessionInputBarControl.frame) - (self.valueForDefaultStatus - frame.origin.y),
//                                                               CGRectGetWidth(frame),
//                                                               CGRectGetHeight(self.chatSessionInputBarControl.frame));
//            self.conversationMessageCollectionView.frame = CGRectMake(0,
//                                                                      0,
//                                                                      CGRectGetWidth(frame),
//                                                                      self.chatSessionInputBarControl.frame.origin.y);
//        } else {
//            self.valueForDefaultStatus = frame.origin.y;
//
//            self.chatSessionInputBarControl.frame = CGRectMake(0,
//                                                               400  - 50,
//                                                               CGRectGetWidth(frame),
//                                                               CGRectGetHeight(self.chatSessionInputBarControl.frame));
//            self.conversationMessageCollectionView.frame = CGRectMake(0,
//                                                                      0,
//                                                                      CGRectGetWidth(frame),
//                                                                      self.chatSessionInputBarControl.frame.origin.y);
//        }
//
//
//        NSLog(@"%@", NSStringFromCGRect(frame));
//
//
//
////    if (chatInputBar.currentBottomBarStatus == KBottomBarDefaultStatus) {
////        if (frame.origin.y > self.valueForDefaultStatus) {
////            self.valueForDefaultStatus = frame.origin.y;
////
////            self.chatSessionInputBarControl.frame = CGRectMake(0,
////                                                               400  - 50,
////                                                               CGRectGetWidth(frame),
////                                                               CGRectGetHeight(self.chatSessionInputBarControl.frame));
////            self.conversationMessageCollectionView.frame = CGRectMake(0,
////                                                                      0,
////                                                                      CGRectGetWidth(frame),
////                                                                      self.chatSessionInputBarControl.frame.origin.y);
////        }
////
////
////    }
////
////    if (frame.origin.y < self.valueForDefaultStatus) {
////        self.chatSessionInputBarControl.frame = CGRectMake(0,
////                                                           400  - CGRectGetHeight(self.chatSessionInputBarControl.frame) - (self.valueForDefaultStatus - frame.origin.y),
////                                                           CGRectGetWidth(frame),
////                                                           CGRectGetHeight(self.chatSessionInputBarControl.frame));
////        self.conversationMessageCollectionView.frame = CGRectMake(0,
////                                                                  0,
////                                                                  CGRectGetWidth(frame),
////                                                                  self.chatSessionInputBarControl.frame.origin.y);
////    } else {
////        self.valueForDefaultStatus = frame.origin.y;
////
////        self.chatSessionInputBarControl.frame = CGRectMake(0,
////                                                           400  - 50,
////                                                           CGRectGetWidth(frame),
////                                                           CGRectGetHeight(self.chatSessionInputBarControl.frame));
////        self.conversationMessageCollectionView.frame = CGRectMake(0,
////                                                                  0,
////                                                                  CGRectGetWidth(frame),
////                                                                  self.chatSessionInputBarControl.frame.origin.y);
////    }
////
////
////    NSLog(@"%@", NSStringFromCGRect(frame));
//
//
//
//}

@end
