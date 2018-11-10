//
//  XJHCallView.h
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseView.h"

@class XJHCallView;
@protocol XJHCallViewDelegate <NSObject>

- (void)didTouchCallView:(XJHCallView *)callView;

@end

@interface XJHCallView : XJHBaseView

@property (nonatomic, readwrite, weak) id<XJHCallViewDelegate> delegate;

@end
