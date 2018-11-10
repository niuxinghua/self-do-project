//
//  XJHVideoPlayBackViewController.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/25.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMNodeObject.h"
typedef void(^didTapPlayback)(HMNodeObject* node,NSString *time);
typedef void(^Playfileblock)(HMNodeObject* node,NSString *time);
@interface XJHVideoPlayBackViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *deviceList;

@property (nonatomic,copy)didTapPlayback playbackBlock;

@property (nonatomic,copy)Playfileblock playfileBlock;

@property (nonatomic,strong)NSMutableArray *videoList;
@end
