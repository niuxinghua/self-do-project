//
//  CustomEnterView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didtapScanButtonBlock)(void);

@interface CustomEnterView : UIView

@property (nonatomic,copy)didtapScanButtonBlock scanBlock;

@property (nonatomic,strong)UITextField *editTextField;

- (void)setPlaceHolder:(NSString *)holder;

@end
