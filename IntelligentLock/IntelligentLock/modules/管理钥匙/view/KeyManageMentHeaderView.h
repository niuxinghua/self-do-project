//
//  KeyManageMentHeaderView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fblock)(void);
typedef void(^sblock)(void);
typedef void(^tblock)(void);
typedef void(^foblock)(void);


@interface KeyManageMentHeaderView : UIView

@property (nonatomic,strong)UIButton *fbutton;

@property (nonatomic,strong)UIButton *sbutton;

@property (nonatomic,strong)UIButton *tbutton;

@property (nonatomic,strong)UIButton *fobutton;

@property (nonatomic,copy)fblock fblock;

@property (nonatomic,copy)sblock sblock;

@property (nonatomic,copy)tblock tblock;

@property (nonatomic,copy)foblock foblock;

@end
