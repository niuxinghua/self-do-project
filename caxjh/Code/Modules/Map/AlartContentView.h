//
//  AlartContentView.h
//  caxjh
//
//  Created by niuxinghua on 2017/12/4.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlartContentView : UIView
@property (nonatomic,strong)UIButton *topButton;
@property (nonatomic,strong)UIButton *middleButton;
@property (nonatomic,strong)UIButton *bottomButton;
@property (nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic,copy)NSString *selectedTimeStr;
@property (nonatomic,assign)CGFloat timeinterval;
- (NSString *)getselectedTime;
@end
