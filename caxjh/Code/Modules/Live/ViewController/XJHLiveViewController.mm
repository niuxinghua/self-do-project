//
//  XJHLiveViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHLiveViewController.h"
#import "HMSDKManager.h"
#import "XJHLiveRoomViewController.h"
#import "UIViewController+StatusBar.h"
#import "XJHChatViewController.h"
#import "XJHVideoPlayBackViewController.h"
#include <stdio.h>
#include <vector>
#import "DeviceStore.h"
#import <IQKeyboardManager.h>
#import "XJHIMTokenResponse.h"
#import <RongIMKit/RongIMKit.h>
#import <sys/utsname.h>
#import "DBSlider.h"
#import "XJHLandViewController.h"
@interface XJHLiveViewController (){
    local_record_handle  lrHandle;
    P_DEVICE_INFO dev_info;
    P_OPEN_VIDEO_RES video_res;
    video_handle vHandle;
    video_codec_handle vcHandle; //视频解码句柄
    audio_handle aHandle;
    audio_codec_handle acHandle; //音频解码句柄
    P_OPEN_AUDIO_RES audio_res;
    talk_handle tHandle; //对讲句柄
    playback_handle phandle ;//回放句柄
    dispatch_queue_t workQueue;
     NSOperationQueue* threadQueue;
}
@property (strong, nonatomic) OpenGLView20 *glView; //展示视频视图
@property (atomic,strong) NSMutableArray *threadList;
@property (strong,nonatomic) UIImageView *videoPlaceHolder;
@property (strong,nonatomic) UIButton *messageButton;
@property (strong,nonatomic) UIButton *deviceButton;
@property (strong,nonatomic) UIButton *playBackButton;

@property (strong,nonatomic) UIViewController *currentVC;
@property (strong,nonatomic) XJHChatViewController *chatVC;
@property (strong,nonatomic) XJHLiveRoomViewController *roomVC;
@property (strong,nonatomic) XJHVideoPlayBackViewController *playbackVC;
@property (strong,nonatomic) UIView *sliderView;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) BOOL isPlayBackMode;
@property (nonatomic,assign) BOOL isPaused;
@property (nonatomic,strong) UIButton *audioButton;
@property (nonatomic,strong) DBSlider *slider;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,strong) UIButton *resumeBackButton;
@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,strong) UIBarButtonItem *rightButton;
@property (nonatomic,strong) NSArray *studentIDs;
@property (nonatomic,copy) NSString *studentID;
@property (nonatomic,assign) BOOL canChangeID;
@property (strong, nonatomic) UIView *topView; //返回键，标题，声音播放图标
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGPoint viewCenter;
@property (nonatomic,strong) UIButton *fullScreenButton;
@property (nonatomic,strong) UIButton *halfScreenButton;
@property (strong, nonatomic) UIView *leftView; //左视图
@property (strong, nonatomic) UIView *rightView; //右视图

@property (assign, nonatomic) user_id userId;
@property (strong, nonatomic) NSCycleBuffer *videoBuffer;

@property (strong, nonatomic) HMAudioPlayer *audioPlayer;
@property (strong, nonatomic) HMAudioRecorder *audioRecorder;

@property (assign, nonatomic) CODE_STREAM code_stream; //设置高清与标清

@property (nonatomic,assign)BOOL isLandScape;
@property (nonatomic,assign)CGFloat widthScale;
@property (nonatomic,assign)CGFloat heightScale;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (strong, nonatomic) NSLock *videoLock;
@property (strong, nonatomic) NSLock *audioLock;
@property (strong, nonatomic) NSLock *talkLock;
@property (assign, nonatomic) BOOL isVideoPlaying;
@property (assign, nonatomic) BOOL isListening;
@property (assign, nonatomic) BOOL isTalking;
@property (assign,nonatomic) BOOL canChat;
@property (nonatomic, copy) NSString *fileName;
@property (assign, nonatomic) BOOL isNeedTakePhoto;

@property (strong, nonatomic) UILabel *leftTimeLable;

- (void)addVideoDataToArray:(char *)data len:(NSInteger)len;
- (void)addAudioDataToArray:(char *)data len:(NSInteger)len;

@property (nonatomic, readwrite, strong) XJHIMTokenResponse *IMTokenResponse;

@end

@implementation XJHLiveViewController
@synthesize glView;
@synthesize topView;
@synthesize titleLabel;
@synthesize viewCenter;

@synthesize leftView;
@synthesize rightView;

@synthesize nodeObject;
@synthesize channelObject;
@synthesize userId;
@synthesize videoBuffer;
@synthesize audioPlayer;
@synthesize audioRecorder;

@synthesize code_stream;


@synthesize videoLock;
@synthesize audioLock;
@synthesize talkLock;
@synthesize isVideoPlaying;
@synthesize isListening;
@synthesize isTalking;
@synthesize isNeedTakePhoto;

#pragma mark 接收视频数据回调函数
static void videoPuData(user_data data, P_FRAME_DATA frame, hm_result result){
    XJHLiveViewController *playerController = (__bridge XJHLiveViewController *)(data);
    if (result == HMEC_OK) {
        
        [playerController addVideoDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
    }
}

#pragma mark 接收音频数据回调函数
void audioPuData(user_data data, P_FRAME_DATA frame, hm_result result){
    XJHLiveViewController *playerController = (__bridge XJHLiveViewController *)data;
    
    if (result == HMEC_OK && !playerController.isPlayBackMode) {
        
        [playerController addAudioDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
    }
}

#pragma mark -playback
void playback_video_data(user_data data, bool over, P_FRAME_DATA frame, hm_result res)
{
    XJHLiveViewController *playerController = (__bridge XJHLiveViewController *)(data);
    if (res == HMEC_OK) {
        switch (frame->frame_info.frame_type) {
            case HME_RFT_I:
            case HME_RFT_P:
            case HME_RFT_H265_I:
            case HME_RFT_H265_P:
                [playerController addVideoDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
                break;
                
            case HME_RFT_G711U:
            case HME_RFT_PCM:
            case HME_RFT_SPEEX:
            case HME_RFT_AAC:
            case HME_RFT_G711A:
                [playerController addAudioDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
                break;
        }
    }
}

- (NSMutableArray *)getplayBackFile:(NSString*)time {
    std::vector<FIND_FILE_DATA> file_list;
    NSMutableArray *fileList = [[NSMutableArray alloc]init];
    [fileList removeAllObjects];
    if (videoBuffer == NULL) {
        videoBuffer = [[NSCycleBuffer alloc] initWithCapacity:kVIDEO_DATA_BUFFER_MAXLENGTH*1.5 bytesPerBuffer:kVIDEO_DATA_BUFFER_BYTES];
    }
    if (vcHandle == NULL) {
        hm_video_init(HME_VE_H264, &vcHandle);
    }
    hm_result res;
    find_file_handle handle = 0;
    FIND_FILE_PARAM param = {};
    param.channel = 0;
    param.record_type = HME_VR_ALARMTYPE;
    param.search_mode = HME_SM_BEG_AND_END_TIME;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [format dateFromString:time];
    NSDate *datenext = [[NSDate alloc]initWithTimeInterval:24 * 60 * 60 sinceDate:date];
    NSString *nextStr = [format stringFromDate:datenext];
    char nowChar[260];
    char nextChar[260];
    strcpy(nowChar,(char *)[time UTF8String]);
    strcpy(nextChar,(char *)[nextStr UTF8String]);
    memcpy((void*)param.start_time, nowChar, strlen(nowChar));
    memcpy((void*)param.end_time,    nextChar, strlen(nextChar));
    res = hm_pu_find_file(userId, &param, &handle);
    
    FIND_FILE_DATA fd = {};
    while((res = hm_pu_find_next_file(handle, &fd)) == HMEC_OK)
    {
        file_list.push_back(fd);
        NSLog(@"filename-----%s",fd.file_name);
        NSString * tempString = [NSString stringWithFormat:@"%s",fd.file_name];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[NSString stringWithFormat:@"%s",fd.start_time] forKey:@"start"];
        [dic setValue:[NSString stringWithFormat:@"%s",fd.end_time] forKey:@"end"];
        
        [dic setObject:tempString forKey:@"name"];
        [fileList addObject:dic];
    }
    hm_pu_close_find_file(handle);
    return fileList;
}

- (void)showGlView {
    isVideoPlaying = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!_isLandScape)
        {
        [self.view addSubview:_scrollView];
        [self.view bringSubviewToFront:_scrollView];
        [self.view bringSubviewToFront:_audioButton];
        [self.view bringSubviewToFront:_fullScreenButton];
        [self.view bringSubviewToFront:_slider];
        [self.view bringSubviewToFront:_leftTimeLable];
        }
        _fullScreenButton.hidden = NO;
    });
    
    NSInvocationOperation* operationDisplay = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(HMRundisplayThread) object:nil];
   
    [threadQueue addOperation:operationDisplay];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        _currentVC.view.userInteractionEnabled = YES;
    });
}

- (void)playBackVideo:(NSString*)filename {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:_currentVC.view animated:NO];
        _currentVC.view.userInteractionEnabled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_currentVC.view animated:NO];
            _currentVC.view.userInteractionEnabled = YES;
            [self resume];
        });
    });
    dispatch_async(dispatch_get_main_queue(), ^{
       _audioButton.hidden = YES;
    });
    hm_result res;
    phandle = 0;
    PLAYBACK_RES pres = {};
    PLAYBACK_PARAM pparam = {};
    char tempChar[260];
    
    strcpy(tempChar,(char *)[filename UTF8String]);
    memcpy((void*)pparam.file_name, tempChar, strlen(tempChar));
    pparam.cb_data = playback_video_data;
    pparam.data = (__bridge user_data) (self);
    pparam.play_mode = HME_PBM_NAME_TIME;
    pparam.play_time = _progress;
    res = hm_pu_open_playback(userId, &pparam, &pres, &phandle);
    [self showGlView];
    if(res) return;
    [self startPlayBack];
    [self listenOperation];
}

- (void)didTapresumeButton:(UIButton *)btn
{
    _videoPlaceHolder.hidden = YES;
}

- (void)startPlayBack
{
    hm_pu_start_playback(phandle);
}

- (void)pausePlayBack
{
    if (_isPlayBackMode && !_isPaused) {
        
        [_scrollView bringSubviewToFront:_resumeBackButton];
        _resumeBackButton.hidden = NO;
        hm_pu_pause_playback(phandle);
        _isPaused = YES;
        if (audioPlayer) {
            [audioPlayer stop];
        }
    }else if (_isPlayBackMode && _isPaused)
    {
        [self resumePlayBack];
        if (audioPlayer) {
            [audioPlayer start];
        }
    }
}

- (void)resumePlayBack
{
    hm_pu_resume_playback(phandle);
    _isPaused = NO;
    _resumeBackButton.hidden = YES;
}

- (void)sliderValueChanged:(UISlider *)slider {
    _progress = slider.value;
    self.slider.hidden = NO;
    _audioButton.hidden = YES;
    _isPlayBackMode = YES;
    
    _isPaused = NO;
    
    _resumeBackButton.hidden = YES;
    
    // dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self config];
    // });
}

- (void)scrollTimer {
    if (!_isPaused) {
        _slider.value += 0.5;
        NSString *left;
        NSString *secondstr;
        int minute = (int)_slider.value/60.0;
        int second = (int)(((int)_slider.value)%60);
        if (second >= 10) {
            secondstr = [NSString stringWithFormat:@"%d",second];
        }else{
            secondstr = [NSString stringWithFormat:@"0%d",second];
            
        }
        if (minute > 0) {
            left = [NSString stringWithFormat:@"%d:%@",minute,secondstr];
        }else{
            left = [NSString stringWithFormat:@"00:%@",secondstr];
        }
        _leftTimeLable.text = [NSString stringWithFormat:@"%@/30:00",left];
    }
}

- (void)getIMToken {
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSDictionary *dictionary = @{
                                 @"columns" : @[@"id", @"avatar", @"name", @"address"],
                                 @"order" : @{},
                                 @"filter" : @{@"id" : @{@"eq" : userID}},
                                 @"table" : @"Member"
                                 };
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary success:^(id responseObject) {
        NSArray *array = [responseObject objectForKey:@"data"];
        
        if ([array isEqual:[NSNull null]]) {
            return ;
        }
        
        if (array.count == 0) {
            return ;
        }
        
        NSString *name = [responseObject objectForKey:@"data"][0][@"name"];
        NSString *avatar = [responseObject objectForKey:@"data"][0][@"avatar"];
        
        name = [name isEqual:[NSNull null]] ? @"" : name;
        avatar = [avatar isEqual:[NSNull null]] ? @"" : avatar;
        
        if (name.length == 0) {
            name = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_PHONE"];
            name = [name isEqual:[NSNull null]] ? @"" : name;
        }
        
        NSDictionary *dic = @{
                              @"userId" : userID,
                              @"name" : name,
                              @"portraitUri" : avatar,
                              };
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
        [PPNetworkHelper POST:kAPIIMTokenURL parameters:dic success:^(id responseObject) {
            XJHIMTokenResponse *response = [XJHIMTokenResponse mj_objectWithKeyValues:responseObject];
            if ([response.code isEqualToString:@"200"]) {
                self.IMTokenResponse = response;
                
                // [[RCIM sharedRCIM] initWithAppKey:@"k51hidwqknxeb"];
                
                // 生产环境
                // [[RCIM sharedRCIM] initWithAppKey:@"tdrvipkstqo75"];
                
                [[RCIM sharedRCIM] connectWithToken:self.IMTokenResponse.token success:^(NSString *userId) {
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userID name:name portrait:avatar];
                    [RCIM sharedRCIM].currentUserInfo = userInfo;
                    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
                } error:^(RCConnectErrorCode status) {
                    
                } tokenIncorrect:^{
                    
                }];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)canGoChat {
    if (!_canChat) {
        return NO;
    }
    if (self.IMTokenResponse) {
        if (self.studentID.length > 0) {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    videoLock = [[NSLock alloc] init];
    audioLock = [[NSLock alloc] init];
    talkLock = [[NSLock alloc] init];
    workQueue = dispatch_queue_create("workQueue", NULL);
    threadQueue = [[NSOperationQueue alloc]init];
    threadQueue.maxConcurrentOperationCount = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    _threadList = [[NSMutableArray alloc]init];
    [self setStatusBarDefaultColor];
    [self initRoomList];
    [self initGLView];
    [self initTabsInCondition];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    [self pause];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLogout) name:@"NOTIFICATION_SHOULD_LOGOUT" object:nil];
    _rightButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchArrowButton)];
    [_rightButton setTintColor:[UIColor blackColor]];
    
    self.navigationItem.rightBarButtonItem = _rightButton;
    
    self.IMTokenResponse = nil;
    [self getIMToken];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPortriat) name:@"doportrit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:@"bindchange" object:nil];
}

- (void)didChange:(NSNotification *)notification
{
    
    _studentIDs = notification.object;
    
}
-(void)didTouchArrowButton
{
//    if (!_canChangeID) {
//        [self.view makeToast:@"请切换到设备列表进行选择"];
//        
//        return;
//        
//    }
//    if (![_currentVC isKindOfClass:[XJHLiveRoomViewController class]]) {
//        
//        [self.view makeToast:@"请切换到设备列表进行选择"];
//        
//        return;
//    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    if (!_studentIDs.count) {
        return;
    }
    for(NSDictionary *dic in _studentIDs)
    {
        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:[dic objectForKey:@"stuName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _canChat = [[dic objectForKey:@"liveValid"] boolValue];
            if ([_studentID isEqualToString:[dic objectForKey:@"stuId"]]) {
                return ;
            }
            [_rightButton setTitle:[dic objectForKey:@"stuName"]];
            _studentID = [dic objectForKey:@"stuId"];
            [_roomVC filterStudentId:_studentID];
            if (_playbackVC) {
            _playbackVC.videoList = @[].mutableCopy;
            }
        }];
        [alertController addAction:actionTeacher];
        
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)pause {
    [_myTimer setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    [_myTimer setFireDate:[NSDate date]];
}

- (void)shouldLogout {
    [self releaseInfo];
    [DeviceStore sharedInstance].deviceList = @[].mutableCopy;
    [HMSDKManager sharedInstance].realNodeList = @[].mutableCopy;
    
}

- (void)config {
    [self.videoBuffer reset];
    self.videoBuffer = NULL;
    [self releaseInfo];
    [self initData];
}

- (void)initRoomList {
    _canChangeID = YES;
    if (!_roomVC) {
        _roomVC = [[XJHLiveRoomViewController alloc]init];
    }
    if ([HMSDKManager sharedInstance].realNodeList) {
        _roomVC.datalist = [HMSDKManager sharedInstance].realNodeList;
    }
    
    [self addChildViewController:_roomVC];
    
    [self.view addSubview:_roomVC.view];
    _currentVC = _roomVC;
    __weak XJHLiveViewController *weaklive = self;
    _roomVC.tapRoomBlock = ^(HMNodeObject *node) {
        if (node) {
            // dispatch_async(dispatch_get_global_queue(0, 0), ^{
            weaklive.audioButton.hidden = NO;
            _isPlayBackMode = NO;
            weaklive.nodeObject = node;
            [weaklive config];
            // });
        }
    };
    
    _roomVC.selectStuBlock = ^(NSString *stuName, NSString *stuId, NSArray *ids) {
        
        [weaklive.rightButton setTitle:stuName];
        _studentIDs = ids;
        _studentID = stuId;
        for (NSDictionary *dic in ids) {
            if ([stuName isEqualToString:[dic objectForKey:@"stuName"]]) {
                _canChat = [[dic objectForKey:@"liveValid"] boolValue];
            }
        }
    };
}

- (void)gotoChat {
    if (![self canGoChat]) {
        return ;
    }
    // 原来测试用的 targetId 是 ios_testUser1 后来改用了融云返回的 userId 现在根据需求改成学生id
    //        XJHChatViewController *viewController = [[XJHChatViewController alloc] initWithConversationType:ConversationType_CHATROOM targetId:self.studentID];
    //        viewController.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:viewController animated:YES];
    
    XJHChatViewController *viewController = [[XJHChatViewController alloc] initWithConversationType:ConversationType_CHATROOM targetId:self.studentID];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
    
    return ;
    
    if (!_chatVC) {
        _chatVC = [[XJHChatViewController alloc] initWithConversationType:ConversationType_CHATROOM targetId:@"ios_testUser1"];
        _chatVC.view.frame = CGRectMake(0, 260, CGRectGetWidth(self.view.frame), 400);
    }
    if (![_currentVC isKindOfClass:[XJHChatViewController class]]) {
        [_currentVC removeFromParentViewController];
        [_currentVC.view removeFromSuperview];
        [self addChildViewController:_chatVC];
        [self.view addSubview:_chatVC.view];
        [_currentVC didMoveToParentViewController:self];
        _currentVC = _chatVC;
    }
    _canChangeID = YES;
    [self.view bringSubviewToFront:_scrollView];
    [self.view bringSubviewToFront:_messageButton];
    [self.view bringSubviewToFront:_deviceButton];
    [self.view bringSubviewToFront:_playBackButton];
    [self.view bringSubviewToFront:_sliderView];
    if (!nodeObject) {
        [self.view bringSubviewToFront:_videoPlaceHolder];
    }
    [_messageButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    [_deviceButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [_playBackButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _sliderView.center = CGPointMake(self.view.frame.size.width/6.0, _sliderView.center.y);
    }];
}

-(void)gotoDevice {
    if (!_roomVC) {
        _roomVC = [[XJHLiveRoomViewController alloc]init];
    }
    if (![_currentVC isKindOfClass:[XJHLiveRoomViewController class]]) {
        [_currentVC removeFromParentViewController];
        [_currentVC.view removeFromSuperview];
        [self addChildViewController:_roomVC];
        [self.view addSubview:_roomVC.view];
        _currentVC = _roomVC;
    }
    _canChangeID = YES;
    _slider.hidden = YES;
    _audioButton.hidden = NO;
    _resumeBackButton.hidden = YES;
    [self.view bringSubviewToFront:_scrollView];
    [self.view bringSubviewToFront:_messageButton];
    [self.view bringSubviewToFront:_deviceButton];
    [self.view bringSubviewToFront:_playBackButton];
    [self.view bringSubviewToFront:_sliderView];
   // [self.view bringSubviewToFront:_audioButton];
    if (!nodeObject) {
        [self.view bringSubviewToFront:_videoPlaceHolder];
    }
    [_deviceButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    [_messageButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [_playBackButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        if ([self shouldShowChatTab]) {
            _sliderView.center = CGPointMake(self.view.frame.size.width/4.0 * 2, _sliderView.center.y);
        } else {
            _sliderView.center = CGPointMake(self.view.frame.size.width/4.0, _sliderView.center.y);
        }
    }];
}

- (void)gotoPlayback {
    if (!_playbackVC) {
        _playbackVC = [[XJHVideoPlayBackViewController alloc]init];
        __weak XJHVideoPlayBackViewController *weakSelf = _playbackVC;
        __weak XJHLiveViewController *weakLive = self;
        _playbackVC.playbackBlock = ^(HMNodeObject *node, NSString *time) {
            nodeObject = node;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                weakSelf.videoList =  [weakLive getplayBackFile:time];
            });
            
        };
        _canChangeID = NO;
        _playbackVC.playfileBlock = ^(HMNodeObject *node,NSString *fileName) {
            weakLive.slider.value = 0.0;
            nodeObject = node;
            weakLive.slider.hidden = NO;
            weakLive.audioButton.hidden = YES;
            _isPlayBackMode = YES;
            _fileName = fileName;
            // dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakLive config];
            //  });
            
        };
    }
    
    NSDictionary *currentDic;
    for (NSDictionary *dic in _studentIDs) {
        if([_studentID isEqualToString:[dic objectForKey:@"stuId"]])  {
            currentDic = dic;
        }
    }
    if ([[currentDic objectForKey:@"showPlayback"] isEqualToString:@"no"]) {
        [self.view makeToast:@"不支持回放"];
        _playbackVC.deviceList = @[].mutableCopy;
        
    } else {
        _playbackVC.deviceList = [DeviceStore sharedInstance].deviceList;
    }
    if (![_currentVC isKindOfClass:[XJHVideoPlayBackViewController class]]) {
        [_currentVC removeFromParentViewController];
        [_currentVC.view removeFromSuperview];
        [self addChildViewController:_playbackVC];
        [self.view addSubview:_playbackVC.view];
        _currentVC = _playbackVC;
    }
    [self.view bringSubviewToFront:_scrollView];
    [self.view bringSubviewToFront:_messageButton];
    [self.view bringSubviewToFront:_deviceButton];
    [self.view bringSubviewToFront:_playBackButton];
    [self.view bringSubviewToFront:_sliderView];
    _slider.hidden = NO;
   // [self.view bringSubviewToFront:_audioButton];
    [_playBackButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    [_messageButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [_deviceButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        if ([self shouldShowChatTab]) {
            _sliderView.center = CGPointMake(self.view.frame.size.width/6.0 * 5, _sliderView.center.y);
        } else {
            _sliderView.center = CGPointMake(self.view.frame.size.width/4.0 * 3, _sliderView.center.y);
        }
    }];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if (![self canGoChat]) {
        [self getIMToken];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(orientationChanged)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
    // [IQKeyboardManager sharedManager].enable = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)releaseInfo {
    
    @synchronized (self) {
        
        isVideoPlaying = NO;
        if (vHandle != NULL) {
            
            hm_result result = hm_pu_stop_video(vHandle);
            result = hm_pu_close_video(vHandle);
            vHandle = NULL;
        }
        if (vcHandle != NULL) {
            
            [videoLock lock];
            hm_video_uninit(vcHandle);
            vcHandle = NULL;
            [videoLock unlock];
            
        }
        if (phandle) {
            hm_pu_stop_playback(phandle);
            hm_pu_close_playback(phandle);
        }
        [videoLock lock];
        [glView clearFrame];
        if (videoBuffer) {
            
            [videoBuffer reset];
        }
        
        if (acHandle != NULL) {
            [audioLock lock];
            hm_audio_uninit(acHandle);
            acHandle = NULL;
            [audioLock unlock];
        }
        
        //关闭音频
        if (aHandle != NULL) {
            
            
            [audioPlayer stop];
            [audioPlayer resetAudioData];
            
            
            hm_pu_stop_audio(aHandle);
            hm_pu_close_audio(aHandle);
            aHandle = NULL;
        }
    }
    
    [videoLock unlock];
}

- (void)initData {
    @synchronized (self){
        video_res = (P_OPEN_VIDEO_RES)malloc(sizeof(OPEN_VIDEO_RES));
        audio_res = (P_OPEN_AUDIO_RES)malloc(sizeof(OPEN_AUDIO_RES));
        dev_info = (P_DEVICE_INFO)malloc(sizeof(DEVICE_INFO));
        
        code_stream = HME_CS_MAJOR;
        
        isVideoPlaying = NO;
        isTalking = NO;
        isNeedTakePhoto = NO;
        dispatch_async(workQueue, ^{
            [self connectVideoByNode];
        });
    }
}

#pragma mark - 初始化视图信息
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return glView;
}
- (void)initGLView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
    glView.frame = _scrollView.bounds;
    //  glView.userInteractionEnabled = NO;
    [_scrollView addSubview:glView];
    _scrollView.minimumZoomScale = 1.0;   // 最小缩放值
    _scrollView.maximumZoomScale = 3.0;  // 最大缩放值
    _scrollView.delegate = self;
    _videoPlaceHolder = [[UIImageView alloc]initWithFrame:glView.frame];
    [_videoPlaceHolder setImage:[UIImage imageNamed:@"videoPlaceHolder"]];
    [self.view addSubview:_videoPlaceHolder];
    
    
    
    
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pausePlayBack)];
    [glView addGestureRecognizer:gesture];
    
    _resumeBackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    _resumeBackButton.center = CGPointMake(_scrollView.center.x, _scrollView.center.y);
    _resumeBackButton.hidden = YES;
    
    [_resumeBackButton addTarget:self action:@selector(pausePlayBack) forControlEvents:UIControlEventTouchUpInside];
    
    [_resumeBackButton setBackgroundImage:[UIImage imageNamed:@"pauseplayback"] forState:UIControlStateNormal];
    
    [_scrollView addSubview:_resumeBackButton];
    
    
    
   
    
    
    
    _slider = [[DBSlider alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width-130, 10)];
    
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 30 * 60.0;
    _slider.continuous = NO;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.hidden = YES;
    [self.view addSubview:_slider];
    
    _leftTimeLable = [[UILabel alloc]init];
    _leftTimeLable.frame = CGRectMake(_slider.frame.size.width, 190, 60, 30);
    _leftTimeLable.textAlignment = NSTextAlignmentCenter;
    _leftTimeLable.font = [UIFont systemFontOfSize:8];
    _leftTimeLable.center = CGPointMake(_leftTimeLable.center.x, _slider.center.y);
    
    _leftTimeLable.textColor = [UIColor grayColor];
    [self.view addSubview:_leftTimeLable];
    [self.view bringSubviewToFront:_leftTimeLable];
    
    
    
    _audioButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 180, 30, 30)];
    [self.view addSubview:_audioButton];
    _audioButton.hidden = YES;
  //  _audioButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [_audioButton setImage:[UIImage imageNamed:@"openAudio"] forState:UIControlStateNormal];
    isListening = YES;
    [_audioButton addTarget:self action:@selector(didTapAudio) forControlEvents:UIControlEventTouchUpInside];
    
    _fullScreenButton = [[UIButton alloc]initWithFrame:CGRectMake(glView.frame.size.width - 40, 180, 30, 30)];
    //_fullScreenButton.hidden = YES;
   // _fullScreenButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_fullScreenButton addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_fullScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    [self.view addSubview:_fullScreenButton];
    _halfScreenButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.tabBarController.view.frame.size.height - 40, 30, 30)];
    [_halfScreenButton addTarget:self action:@selector(halfScreen) forControlEvents:UIControlEventTouchUpInside];
    [_halfScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    [self.tabBarController.view addSubview:_halfScreenButton];
    
    [self.view bringSubviewToFront:_videoPlaceHolder];
}


#pragma mark - 横屏处理

- (void)fullScreen{
    
   
    
    [self doLandScapeLeft];
    _halfScreenButton.hidden = NO;
    _fullScreenButton.hidden = YES;

    
    
}

- (void)halfScreen
{
    
    [self doPortriat];
    _halfScreenButton.hidden = YES;
    _fullScreenButton.hidden = NO;
   
}





- (void)doPortriat
{
    [self showPlugins];
    [_scrollView setZoomScale:1.0];
    _scrollView.transform = CGAffineTransformIdentity;
    glView.transform = CGAffineTransformIdentity;
    _scrollView.frame =  _videoPlaceHolder.frame;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:glView];
    [self.view bringSubviewToFront:_scrollView];
    glView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.view bringSubviewToFront:_fullScreenButton];
    [self.view bringSubviewToFront:_audioButton];
    [self.view bringSubviewToFront:_slider];
    [self.view bringSubviewToFront:_leftTimeLable];
    _resumeBackButton.center = CGPointMake(_scrollView.center.x, _scrollView.center.y);
    [_scrollView bringSubviewToFront:_resumeBackButton];
    [self.view addSubview:_slider];
    _slider.frame = CGRectMake(0, 190, self.view.frame.size.width-130, 10);
    [self.view bringSubviewToFront:_slider];
    _leftTimeLable.frame = CGRectMake(_slider.frame.size.width, 190, 60, 30);
    _leftTimeLable.center = CGPointMake(_leftTimeLable.center.x, _slider.center.y);
    [self.view addSubview:_leftTimeLable];
    [self.view bringSubviewToFront:_leftTimeLable];
    _isLandScape = NO;
    
}
- (void)doLandScapeLeft
{
    XJHLandViewController *land = [[XJHLandViewController alloc]init];
    land.backscrollView = _scrollView;
  //  land.halfScreenButton = _halfScreenButton;
    land.glview = glView;
    land.resumeButton = _resumeBackButton;
    land.slider = _slider;
    land.leftLable = _leftTimeLable;
    [self presentViewController:land animated:NO completion:^{
    _isLandScape = YES;
    }];
    
    
    return;
    
    
  
}




- (void)hidePlugins
{
    _audioButton.hidden = YES;
    _slider.hidden = YES;
    _leftTimeLable.hidden = YES;
    _fullScreenButton.hidden = NO;
    
}
- (void)showPlugins
{
  
    _fullScreenButton.hidden = NO;
    if (_isPlayBackMode) {
        _audioButton.hidden = YES;
        _leftTimeLable.hidden = NO;
        _slider.hidden = NO;
        _fullScreenButton.hidden = NO;
    }else{
        _leftTimeLable.hidden = YES;
        _audioButton.hidden = NO;
        _slider.hidden = YES;
        _fullScreenButton.hidden = NO;
    }
    
    
}
-(void)didTapAudio
{
    isListening = !isListening;
    [self listenOperation];
    if(isListening)
    {
        [_audioButton setImage:[UIImage imageNamed:@"openAudio"] forState:UIControlStateNormal];
        if (audioPlayer) {
            [audioPlayer start];
        }
    }else{
        [_audioButton setImage:[UIImage imageNamed:@"closeAudio"] forState:UIControlStateNormal];
        if (audioPlayer) {
            [audioPlayer stop];
        }
    }
}

#pragma mark -登录设备
- (void)connectVideoByNode {
     isVideoPlaying = NO;
    [threadQueue cancelAllOperations];
    if (nodeObject.nodeHandle == NULL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    });
    CONNECT_INFO connectInfo;
    
    connectInfo.ct = CT_MOBILE;
    connectInfo.cp = CPI_DEF;
    connectInfo.cm = 4;
    NSLog(@"连接设备");
    hm_result loginResult;
    loginResult = hm_pu_login_ex(nodeObject.nodeHandle, &connectInfo, &userId);
    NSLog(@"loginResult:%0x",loginResult);
    if (loginResult != HMEC_OK) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            _currentVC.view.userInteractionEnabled = YES;
            
            [self.view makeToast:@"连接设备失败"];
            return;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        });
        return;
    }
    
    if (loginResult == HMEC_OK) {
        if (vcHandle == NULL) {
            
            //初始化视频解码句柄
            hm_video_init(HME_VE_H264, &vcHandle);
        }
        
        OPEN_VIDEO_PARAM videoParam = {};
        
        videoParam.channel = 0;
        
        if (nodeObject.nodeType == HME_NT_DVS) {
            
            videoParam.channel = (uint32)channelObject.channelIndex;
        }
        
        videoParam.cs_type = code_stream;
        videoParam.vs_type = HME_VS_REAL;
        videoParam.cb_data = &videoPuData;
        videoParam.data = (__bridge user_data)(self);
        
        
        if (videoBuffer == NULL) {
            videoBuffer = [[NSCycleBuffer alloc] initWithCapacity:kVIDEO_DATA_BUFFER_MAXLENGTH*1.5 bytesPerBuffer:kVIDEO_DATA_BUFFER_BYTES];
        }
      //  [videoBuffer reset];
        if (_isPlayBackMode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                _currentVC.view.userInteractionEnabled = YES;
                _audioButton.hidden = YES;
            });
            [self playBackVideo:_fileName];
            if (hm_pu_get_device_info(userId, dev_info) != HMEC_OK) {
                
            } else {
                
                NSLog(@"初始化音频解码器");
                
                if (acHandle == NULL) {
                    @synchronized (self) {
                        if (!dev_info) {
                            dev_info = (P_DEVICE_INFO)malloc(sizeof(DEVICE_INFO));
                        }
                        hm_audio_init(dev_info->channel_capacity[0]->audio_code_type, &acHandle);
                    }
                    
                }
            }
            return;
        }
        
        //开启视频
        if (hm_pu_open_video(userId, &videoParam, &vHandle) == HMEC_OK) {
            
            
            [self pause];
            //请求视频数据
            hm_result resultstart = hm_pu_start_video(vHandle, video_res);
            if (resultstart != HMEC_OK ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"拉取视频失败"];
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                });
                return;
            }
            if (resultstart == HMEC_OK) {
                
                
                NSLog(@"hm_pu_start_video:%d   %d",video_res->image_width,video_res->image_height);
                
                if (hm_pu_get_device_info(userId, dev_info) != HMEC_OK) {
                    
                    // dev_info = nil;
                    
                    
                }else{
                    
                    NSLog(@"初始化音频解码器");
                    
                    if (acHandle == NULL) {
                        @synchronized (self) {
                            if (!dev_info) {
                                dev_info = (P_DEVICE_INFO)malloc(sizeof(DEVICE_INFO));
                            }
                            hm_audio_init(dev_info->channel_capacity[0]->audio_code_type, &acHandle);
                        }
                        
                    }
                }
                
                
                isVideoPlaying = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!_isLandScape){
                        [self.view addSubview:_scrollView];
                        [self.view bringSubviewToFront:_scrollView];
                        [self.view bringSubviewToFront:_audioButton];
                        [self.view bringSubviewToFront:_fullScreenButton];
                    }
                });
                NSInvocationOperation* operationDisplay = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(HMRundisplayThread) object:nil];
                [threadQueue addOperation:operationDisplay];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    _currentVC.view.userInteractionEnabled = YES;
                });
                [self listenOperation];
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"获取视频失败"];
            });
            
        }
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"获取视频失败"];
        });
    }
   
}

#pragma mark -添加视频数据
- (void)addVideoDataToArray:(char *)data len:(NSInteger)len {
    
    
    if (data!=nil && len>0) {
        [videoBuffer enqueue:data dataBytesSize:len];
    }
}

#pragma mark -添加音频数据
- (void)addAudioDataToArray:(char *)data len:(NSInteger)len {
    
    char* out_data = (char*)malloc(320);
    memset(out_data, 0, 320);
    int32 out_len = 320;
    if (hm_audio_decode(acHandle, out_data, &out_len, data, len, 8000)== 0) {
        if (audioPlayer) {
            [audioPlayer enqueueData:(char*)out_data dataBytesSize:out_len];
        }
    }
    free(out_data);
}

#pragma mark -
#pragma mark 播放视频线程
- (void)HMRundisplayThread {
    for (NSThread *thread in _threadList) {
        [thread cancel];
    }
    [_threadList removeAllObjects];
  //  [[NSThread currentThread] setName: @"Run display thread"];
    [_threadList addObject:[NSThread currentThread]];
    NSInteger           	nLen;			//数据长度
    const char		*pdata = NULL;			//数据区
    
    if (vcHandle == NULL) return;
    while (isVideoPlaying)
    {
        nLen = 0;
        pdata = [videoBuffer dequeue:&nLen];
        
        if (pdata == NULL) {
            
            sleep(0.05);
            continue;
        }
        yuv_handle      yuv_h = NULL;
        
        hm_result decodeResult = hm_video_decode_yuv(vcHandle, (char*)pdata, nLen,&yuv_h);
        
        if (isNeedTakePhoto) {
            isNeedTakePhoto = NO;
        }
        
        if (yuv_h != NULL && decodeResult == HMEC_OK) {
            
            YUV_PICTURE yuv_pic;
            
            hm_result yuvResult = hm_video_get_yuv_data(yuv_h, &yuv_pic);
            
            if (isNeedTakePhoto) {
                
            }
            
            if (glView != nil && yuvResult == HMEC_OK && isVideoPlaying) {
                
                uint8_t *yuv420pData = (uint8_t *)malloc(yuv_pic.width * yuv_pic.height * 3/2);
                
                int width = yuv_pic.width;
                int height = yuv_pic.height;
                
                for (int i = 0; i < height; i++) {
                    
                    if (yuv_pic.ydata) {
                        
                        memcpy(yuv420pData + i * width, yuv_pic.ydata + i * yuv_pic.ystripe, width);
                    }
                }
                
                int a = width * height;
                
                for (int i = 0; i < height / 2; i++)
                {
                    if (yuv_pic.udata) {
                        
                        memcpy(yuv420pData + a, yuv_pic.udata + i * yuv_pic.ustripe,width / 2);
                        a += width / 2;
                    }
                    
                    
                }
                
                for (int i = 0; i < height / 2; i++)
                {
                    if (yuv_pic.vdata) {
                        
                        memcpy(yuv420pData + a, yuv_pic.vdata + i * yuv_pic.vstripe, width / 2);
                        a += width / 2;
                    }
                    
                    
                }
                @synchronized (self){
                    [glView displayYUV420pData:yuv420pData width:width height:height];
                    
                }
                
                
                free(yuv420pData);
                
            }
            
            
        }
        
        
        if ( yuv_h != NULL) hm_video_release_yuv(yuv_h); yuv_h = NULL;
    }
    
    [videoLock lock];
    [glView clearFrame];// 清屏
    [videoLock unlock];
}

#pragma mark -监听
- (void)listenOperation{
    dispatch_async(workQueue, ^{
        if (isListening) {
            OPEN_AUDIO_PARAM audioParam = {};
            audioParam.channel = 0;
            audioParam.data = (__bridge user_data)(self);
            audioParam.cb_data = &audioPuData;
            
            if (hm_pu_open_audio(userId, &audioParam, audio_res, &aHandle) == HMEC_OK) {
                
                if (hm_pu_start_audio(aHandle) == HMEC_OK) {
                    
                    //打开音频成功以后，初始化音频播放器
                    NSInteger bitsPerChannel = 16;  //不管是speex还是pcm经过解码之后，都应该使用  16 值
                    UInt32    fomat          = HME_AE_SPEEX;     //  值为0表示PCM，值为2表示SPEEX
                    if(audio_res->audio_type == HME_AE_PCMS8) fomat = HME_AE_PCMS8;
                    
                    if (audioPlayer == NULL) {
                        
                        audioPlayer = [[HMAudioPlayer alloc] initAudioPlayer:fomat bitsPerChannel:bitsPerChannel SampleRate:audio_res->sample Channel:audio_res->channel];
                        int size = kAUDIO_DATA_BUFFER_MAXLENGTH;
                        if (audio_res->audio_type == HME_AE_PCMS8) size = kAUDIO_DATA_SIMULATE_LENGTH;
                        [audioPlayer startWithEmptyDataSize:size];
                    }
                    
                    [audioPlayer start];
                    
                    
                } else {
                    
                    
                }
            } else {
                
            }
        } else {
            
            [audioPlayer stop];
            hm_pu_stop_audio(aHandle);
            
            isListening = NO;
            
            hm_pu_close_audio(aHandle);
            
            aHandle = NULL;
        }
    });
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_myTimer invalidate];
    _myTimer = nil;
}

#pragma mark - 隐藏显示那一项来控制是否隐藏跳转到聊天

- (BOOL)shouldShowChatTab {
    // 家长支持聊天 显示 return YES
    // 孩子老师不支持
    
    NSString *userDataType = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_TYPE"];
    if ([userDataType isEqualToString:@"1"]) { // 1 表示家长
        return YES;
    }
    
    return NO;
}

- (void)initTabsInCondition {
    _messageButton = [[UIButton alloc] init];
    _deviceButton = [[UIButton alloc] init];
    _playBackButton = [[UIButton alloc] init];
    
    [_messageButton setTitle:@"家人同看共议" forState:UIControlStateNormal];
    [_messageButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateSelected];
    [_messageButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.view addSubview:_messageButton];
    
    [_deviceButton setTitle:@"设备列表" forState:UIControlStateNormal];
    [_deviceButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    [self.view addSubview:_deviceButton];
    
    [_playBackButton setTitle:@"回放视频" forState:UIControlStateNormal];
    [_playBackButton setTitleColor:[UIColor colorWithHex:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.view addSubview:_playBackButton];
    
    [_messageButton addTarget:self action:@selector(gotoChat) forControlEvents:UIControlEventTouchUpInside];
    [_deviceButton addTarget:self action:@selector(gotoDevice) forControlEvents:UIControlEventTouchUpInside];
    [_playBackButton addTarget:self action:@selector(gotoPlayback) forControlEvents:UIControlEventTouchUpInside];
    
    _sliderView = [[UIView alloc] init];
    _sliderView.backgroundColor = [UIColor colorWithHex:@"#ff6767"];
    [self.view addSubview:_sliderView];
    
    if ([self shouldShowChatTab]) {
        _messageButton.frame = CGRectMake(0, 210, self.view.frame.size.width/3.0, 50);
        _deviceButton.frame = CGRectMake(self.view.frame.size.width/3.0, 210, self.view.frame.size.width/3.0, 50);
        _playBackButton.frame = CGRectMake(self.view.frame.size.width/3.0*2, 210, self.view.frame.size.width/3.0, 50);
        _sliderView.frame = CGRectMake(self.view.frame.size.width/3.0, 260, self.view.frame.size.width/3.0, 2);
    } else {
        _messageButton.frame = CGRectMake(0, 210, 0, 0);
        _deviceButton.frame = CGRectMake(0, 210, self.view.frame.size.width/2.0, 50);
        _playBackButton.frame = CGRectMake(self.view.frame.size.width/2.0, 210, self.view.frame.size.width/2.0, 50);
        _sliderView.frame = CGRectMake(0, 260, self.view.frame.size.width/2.0, 2);
    }
}

@end
