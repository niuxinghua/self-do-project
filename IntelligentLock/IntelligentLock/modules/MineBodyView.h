//
//  MineBodyView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/24.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didtouchView)(void);

@interface MineBodyView : UIView

- (void)setLeftText:(NSString *)lefttext;

//@property (nonatomic,strong)LoginModel *loginModel;

- (void)setButtonText:(NSString *)text;

@property (nonatomic,copy)didtouchView block;

@end
