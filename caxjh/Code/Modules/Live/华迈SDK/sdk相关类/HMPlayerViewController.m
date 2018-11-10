//
//  HMPlayerViewController.m
//  Demo
//
//  Created by guofeixu on 15/10/22.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMPlayerViewController.h"
#import "NSCyscleBuffer.h"
#import "HMPicListViewController.h"
#import "HMRecordListViewController.h"
#import "OpenGLView20.h"

typedef enum : NSUInteger {
    Btn_Op_Record,
    Btn_Op_Pic,
    Btn_Op_Pic_List,
    Btn_Op_Hd,
    Btn_Op_Listen,
    Btn_Op_Talk,
    Btn_Op_Defense,
    Btn_Op_Record_List,
} Btn_Op;


@interface HMPlayerViewController ()<HMAudioRecorderDelegate>{
    
    local_record_handle            lrHandle;
    P_DEVICE_INFO dev_info;
    P_OPEN_VIDEO_RES video_res;
    video_handle vHandle;
    video_codec_handle vcHandle; //视频解码句柄
    audio_handle aHandle;
    audio_codec_handle acHandle; //音频解码句柄
    P_OPEN_AUDIO_RES audio_res;
    talk_handle tHandle; //对讲句柄
}

@property (strong, nonatomic) OpenGLView20 *glView; //展示视频视图
@property (strong, nonatomic) UIView *topView; //返回键，标题，声音播放图标
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGPoint viewCenter;

@property (strong, nonatomic) UIView *leftView; //左视图
@property (strong, nonatomic) UIView *rightView; //右视图

@property (assign, nonatomic) user_id userId;
@property (strong, nonatomic) NSCycleBuffer *videoBuffer;

@property (strong, nonatomic) HMAudioPlayer *audioPlayer;
@property (strong, nonatomic) HMAudioRecorder *audioRecorder;

@property (assign, nonatomic) CODE_STREAM code_stream; //设置高清与标清


@property (strong, nonatomic) NSLock *videoLock;
@property (strong, nonatomic) NSLock *audioLock;
@property (strong, nonatomic) NSLock *talkLock;
@property (assign, nonatomic) BOOL isVideoPlaying;
@property (assign, nonatomic) BOOL isListening;
@property (assign, nonatomic) BOOL isTalking;

@property (assign, nonatomic) BOOL isNeedTakePhoto;


- (void)addVideoDataToArray:(char *)data len:(NSInteger)len;
- (void)addAudioDataToArray:(char *)data len:(NSInteger)len;


@end

@implementation HMPlayerViewController

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
    
    HMPlayerViewController *playerController = (__bridge HMPlayerViewController *)(data);
    if (result == HMEC_OK) {
        
        [playerController addVideoDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
    }
    
}

#pragma mark 接收音频数据回调函数
static void audioPuData(user_data data, P_FRAME_DATA frame, hm_result result){
    
    
    HMPlayerViewController *playerController = (__bridge HMPlayerViewController *)data;
    
    if (result == HMEC_OK) {
        
        [playerController addAudioDataToArray:(pchar)frame->frame_stream len:frame->frame_len];
    }
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    
    viewCenter = self.view.center;
    
    [self initGLView];
    [self initTopView];
    [self initLeftView];
    [self initRightView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self connectVideoByNode];
    });
    
    
    
    

    
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    [self setNavTitle];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    
    [super viewWillDisappear:animated];
    
    [self releaseInfo];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)releaseInfo{
    
    
    isVideoPlaying = NO;
    
    if (vHandle != NULL) {
        
        hm_result result = hm_pu_stop_video(vHandle);
        NSLog(@"stopResult:%0x",result);
        
        if (result == HMEC_OK) {
            
            result = hm_pu_close_video(vHandle);
            NSLog(@"close result:%0x",result);
            
            if (result == HMEC_OK) {
                
                vHandle = NULL;
            }
            
        }
        
    }
    if (vcHandle != NULL) {
        
        [videoLock lock];
        hm_result result = hm_video_uninit(vcHandle);
        
        NSLog(@"uinit result:%0x",result);
        vcHandle = NULL;
        [videoLock unlock];
        
    }
    
    
    [videoLock lock];
    [glView clearFrame];
    [videoLock unlock];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    
    video_res = (P_OPEN_VIDEO_RES)malloc(sizeof(OPEN_VIDEO_RES));
    audio_res = (P_OPEN_AUDIO_RES)malloc(sizeof(OPEN_AUDIO_RES));
    dev_info = (P_DEVICE_INFO)malloc(sizeof(DEVICE_INFO));
    videoLock = [[NSLock alloc] init];
    audioLock = [[NSLock alloc] init];
    talkLock = [[NSLock alloc] init];
    
    code_stream = HME_CS_MAJOR; //默认设置为高清
    
    isVideoPlaying = NO;
    isListening = NO;
    isTalking = NO;
    isNeedTakePhoto = NO;
    
}

#pragma mark - 初始化视图信息
- (void)initGLView{
    
    glView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.height/2.0, self.view.bounds.size.width/2.0)];
    glView.center = viewCenter;
    glView.transform = CGAffineTransformMakeRotation(M_PI/2);
    glView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:glView];
    
}
- (void)initTopView{
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.height, 44)];
    topView.center = CGPointMake(self.view.bounds.size.width - topView.bounds.size.height/2, self.view.bounds.size.height/2);
    topView.backgroundColor = [UIColor grayColor];
    topView.alpha = 0.4f;
    topView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(topView.bounds.origin.x, topView.bounds.origin.y, 44, 44);
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [backButton addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(topView.bounds.origin.x + backButton.frame.origin.x + backButton.frame.size.width + 10, (topView.bounds.size.height - 30)/2, topView.bounds.size.width - (backButton.frame.origin.x + backButton.frame.size.width + 10 * 2), 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [topView addSubview:titleLabel];
    
}

#pragma mark -左边设置录像，设备抓图，抓图列表，高标清
- (void)initLeftView{
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 60, 240)];
    leftView.center = CGPointMake(self.view.bounds.size.width/2, leftView.bounds.size.width/2);
    leftView.backgroundColor = [UIColor darkGrayColor];
    leftView.alpha = 0.4f;
    leftView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:leftView];
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(leftView.bounds.origin.x + 10, leftView.bounds.origin.y + 10, 40, 40)];
    [recordButton setTitle:@"录像" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordButton.tag = Btn_Op_Record;
    [recordButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [leftView addSubview:recordButton];
    
    UIButton *picButton = [[UIButton alloc] initWithFrame:CGRectMake(recordButton.frame.origin.x, recordButton.frame.origin.y + recordButton.frame.size.height + 10, 40, 40)];
    [picButton setTitle:@"抓图" forState:UIControlStateNormal];
    [picButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    picButton.tag = Btn_Op_Pic;
    [picButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [leftView addSubview:picButton];
    
    UIButton *picListButton = [[UIButton alloc] initWithFrame:CGRectMake(picButton.frame.origin.x, picButton.frame.origin.y + picButton.frame.size.height + 10, 40, 40)];
    [picListButton setTitle:@"抓图列表" forState:UIControlStateNormal];
    picListButton.titleLabel.font = [UIFont systemFontOfSize:9];
    [picListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    picListButton.tag = Btn_Op_Pic_List;
    [picListButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [leftView addSubview:picListButton];
    
    UIButton *hdButton = [[UIButton alloc] initWithFrame:CGRectMake(picListButton.frame.origin.x, picListButton.frame.origin.y + picListButton.frame.size.height + 10, 40, 40)];
    [hdButton setTitle:@"高清" forState:UIControlStateNormal];
    [hdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdButton.tag = Btn_Op_Hd;
    [hdButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [leftView addSubview:hdButton];
    
    
}

#pragma mark -右边设置监听，对讲，布防
- (void)initRightView{
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - 240 , 60, 240)];
    rightView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - rightView.bounds.size.width/2);
    rightView.backgroundColor = [UIColor darkGrayColor];
    rightView.alpha = 0.4f;
    rightView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:rightView];
    
    UIButton *listenButton = [[UIButton alloc] initWithFrame:CGRectMake(rightView.bounds.origin.x + 10, rightView.bounds.origin.y + 10, 40, 40)];
    [listenButton setTitle:@"👂" forState:UIControlStateNormal];
    [listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    listenButton.tag = Btn_Op_Listen;
    [listenButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:listenButton];
    
    UIButton *talkButton = [[UIButton alloc] initWithFrame:CGRectMake(listenButton.frame.origin.x, listenButton.frame.origin.y + listenButton.frame.size.height + 10, 40, 40)];
    [talkButton setTitle:@"说" forState:UIControlStateNormal];
    [talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    talkButton.tag = Btn_Op_Talk;
    [talkButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:talkButton];

    UIButton *defenseButton = [[UIButton alloc] initWithFrame:CGRectMake(talkButton.frame.origin.x, talkButton.frame.origin.y + talkButton.frame.size.height + 10, 40, 40)];
    [defenseButton setTitle:@"布防" forState:UIControlStateNormal];
    [defenseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    defenseButton.tag = Btn_Op_Defense;
    [defenseButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:defenseButton];

    UIButton *recordListButton = [[UIButton alloc] initWithFrame:CGRectMake(defenseButton.frame.origin.x, defenseButton.frame.origin.y + defenseButton.frame.size.height + 10, 40, 40)];
    [recordListButton setTitle:@"录像列表" forState:UIControlStateNormal];
    recordListButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    [recordListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordListButton.tag = Btn_Op_Record_List;
    [recordListButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:recordListButton];
    
}

- (void)backBtnPressed:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -设置标题
- (void)setNavTitle{
    
    titleLabel.text = nodeObject.nodeName;
    if (nodeObject.nodeType == HME_NT_DVS) {
        
        titleLabel.text = channelObject.channelName;
    }
}


#pragma mark -登录设备
- (void)connectVideoByNode{
    
    if (nodeObject.nodeHandle == NULL) {
        
        return;
    }
    
    CONNECT_INFO connectInfo;
    
    connectInfo.ct = CT_MOBILE;
    connectInfo.cp = CPI_DEF;
    connectInfo.cm = CM_DEF;
    
    NSLog(@"连接设备");
    
    hm_result loginResult;
    
    //直连设备
    if (self.isDirectDevice) {
        
        loginResult = hm_pu_login([self.ip UTF8String],self.port, [self.sn UTF8String], [self.user UTF8String] ,"" , CT_MOBILE, &userId);
        
        NSLog(@"%0x",loginResult);
        
    }else{
        
        loginResult = hm_pu_login_ex(nodeObject.nodeHandle, &connectInfo, &userId);
        
    }
    
    NSLog(@"loginResult:%0x",loginResult);
    
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
        
        
       
        //开启视频
        if (hm_pu_open_video(userId, &videoParam, &vHandle) == HMEC_OK) {
            
            
            if (videoBuffer == NULL) {
                videoBuffer = [[NSCycleBuffer alloc] initWithCapacity:kVIDEO_DATA_BUFFER_MAXLENGTH*1.5 bytesPerBuffer:kVIDEO_DATA_BUFFER_BYTES];
            }
            //请求视频数据
            if (hm_pu_start_video(vHandle, video_res) == HMEC_OK) {
             
                
                NSLog(@"hm_pu_start_video:%d   %d",video_res->image_width,video_res->image_height);
                
                if (hm_pu_get_device_info(userId, dev_info) != HMEC_OK) {
                    
                    dev_info = nil;
                }else{
                    
                    NSLog(@"初始化音频解码器");
                    
                    if (acHandle == NULL) {
                        
                        hm_audio_init(dev_info->channel_capacity[0]->audio_code_type, &acHandle);
                    }
                }
            
                
                isVideoPlaying = YES;
                NSInvocationOperation* operationDisplay = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(HMRundisplayThread) object:nil];
                NSOperationQueue* queue = [[NSOperationQueue alloc] init];
                [queue addOperation:operationDisplay];
                
            
                
            }
        }
        
        
    }
}

#pragma mark -添加视频数据
- (void)addVideoDataToArray:(char *)data len:(NSInteger)len{
    

    if (data!=nil && len>0) {
        [videoBuffer enqueue:data dataBytesSize:len];
    }
}

#pragma mark -添加音频数据
- (void)addAudioDataToArray:(char *)data len:(NSInteger)len{
    
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
- (void)HMRundisplayThread
{
    [[NSThread currentThread] setName: @"Run display thread"];
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
            
            [self saveImage:yuv_h];
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
                
               [glView displayYUV420pData:yuv420pData width:width height:height];
                
                free(yuv420pData);
                
                
            }
            
            
        }
        
        
        if ( yuv_h != NULL) hm_video_release_yuv(yuv_h); yuv_h = NULL;
    }
    
    [videoLock lock];
    [glView clearFrame];// 清屏
    [videoLock unlock];
    
    
    
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)btnPressed:(UIButton *)sender{
    
    switch (sender.tag) {
            
        case Btn_Op_Record:
        {
            [self record];
        }
            break;
        case Btn_Op_Pic:
        {
            
            [self startPic];
        }
            break;
            
        case Btn_Op_Pic_List:
        {
            [self picList];
        }
            break;
            
        case Btn_Op_Hd:
        {
            [self hdOrSd];
        }
            break;
        case Btn_Op_Listen:
        {
            isListening = !isListening;
            [self listenOperation];
        }
            break;
        case Btn_Op_Talk:
        {
            isTalking = !isTalking;
            [self talkOperation];
        }
            break;
        case Btn_Op_Defense:
        {
            [self defenseOperation];
        }
            break;
        case Btn_Op_Record_List:
        {
            [self recordList];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark *************** 附加操作 ***************

#pragma mark -录像
- (void)record{
    
    
    int64_t actorrecord = (1<<7) & self.powerActor;
    
    if (actorrecord == 0) {
        
        NSLog(@"没有权限");
        return;
    }
    //开始录制
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docu = [filePaths lastObject];
    NSString *localFilePath = [docu stringByAppendingPathComponent:@"LocalVideoFile"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"YYYY_MM_dd_HH_mm_ss";
    NSString *currentTimeStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *devName;
    cpchar cpname;
    hm_server_get_node_name(nodeObject.nodeHandle, &cpname);
    
    if (cpname == NULL) {
        
        devName = @"NULL";
    }else{
        
        devName = [NSString stringWithUTF8String:cpname];
    }
    
    NSString* filename = [[NSString alloc] initWithFormat:@"%@_%@_%@.hmv",localFilePath,currentTimeStr,devName];
    
    pchar file_name = (pchar)[filename cStringUsingEncoding:NSUTF8StringEncoding];
    printf("file_name=%s\n",file_name);
    
    LOCAL_RECORD_PARAM param = {};
    
    strcpy(param.file_name, file_name);
    
    param.video_fps      = video_res->fps;
    param.video_width    = video_res->image_width;
    param.video_height   = video_res->image_height;
//    
    if (isListening) {
        
        param.audio_fmt = audio_res->audio_type;
        param.audio_channel= audio_res->audio_channel;
        param.audio_sample   = audio_res->sample;
    }
    
    strcpy(param.device_sn, dev_info->sn);
    
    strcpy(param.device_name ,dev_info->dev_name);
    
    
    param.record_type = HME_VR_NONE;
    
    
    hm_result result = hm_util_local_record_init(&param, &lrHandle);
    
    NSLog(@"result:%0x",result);
    
    if (result == HMEC_OK)
    {
        //请求关键帧
        if (vHandle) {
            hm_pu_force_iframe(vHandle);
        }
        NSLog(@"初始化录像成功");
    }
    
    
//    //停止录像
//     hm_util_local_record_uninit(lrHandle);
    
}

#pragma mark -执行抓图功能
- (void)startPic{
    
    
    REMOTE_CAPTURE_PIC_PARAM param ;
    param.channel = 0;
    if (nodeObject.nodeType == HME_NT_DVS) {
        
        param.channel = (uint32)channelObject.channelIndex;
    }
    hm_result picResult = hm_pu_remote_capture_pic(userId, &param);
    
    NSLog(@"picResult:%0x",picResult);
    
    if (picResult == HMEC_OK) {
        
        UIAlertView *picAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抓图成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [picAlertView show];
    }
    
}

#pragma mark -查看抓图列表
- (void)picList{
    
    [self performSegueWithIdentifier:@"picListPush" sender:self];
}

#pragma mark -高标清切换
- (void)hdOrSd{
    
    
    if (code_stream == HME_CS_MAJOR) {
        
        code_stream = HME_CS_MINOR;
    }else{
        
        code_stream = HME_CS_MAJOR;
    }
    
    [self connectVideoByNode];
    
}


#pragma mark -监听
- (void)listenOperation{
    
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
                
                
            }else{
                
                isListening = NO;
            }
        }else{
            
            isListening = NO;
        }
        
        
    }else{
        
        [audioPlayer stop];
        hm_pu_stop_audio(aHandle);
        
        isListening = NO;
        
        hm_pu_close_audio(aHandle);
        
        aHandle = NULL;
    }
}

#pragma mark -对讲
- (void)talkOperation{
    
    if (isTalking) {
        
        OPEN_TALK_PARAM param;
        param.channel = 0; //通道，1.非dvs设置为0 2.dvs通道根据channelObject.channelIndex获取
        param.audio_channel = dev_info->channel_capacity[0]->audio_channel;
        param.sample = dev_info->channel_capacity[0]->audio_sample;
        param.audio_type = HME_AE_SPEEX;
        
        if (hm_pu_open_talk(userId, &param, &tHandle) == HMEC_OK) {
            
            
            if (hm_pu_start_talk(tHandle) == HMEC_OK) {
                
                [talkLock lock];
                audioRecorder = [[HMAudioRecorder alloc] initAudioRecorder];
                [audioRecorder setAudioRecorderDelegate:self];
                [audioRecorder start];
                [talkLock unlock];
                
            }else{
                
                isTalking = NO;
            }
        }else{
            
            isTalking = NO;
        }
        
    }else{
        
        if (hm_pu_stop_talk(tHandle) == HMEC_OK)
        {
            [talkLock lock];
            
            if (audioRecorder != nil) {
                
                [audioRecorder stop];
                audioRecorder = nil;
            }
            
            [talkLock unlock];    //停止对讲
            NSLog(@"停止对讲===========》》》》》》");
            
        }
        
        hm_pu_close_talk(tHandle);
        
    }
    
}

#pragma mark -布防与撤防
- (void)defenseOperation{
    
    /* 测试布防与撤防 */
    //1.布防
//    hm_pu_arming_area(userId, 0, nil);
    //2.撤防
//    hm_pu_disarming_area(userId, 0, nil);

    
    
}

#pragma mark -查看录像列表
- (void)recordList{
    
    [self performSegueWithIdentifier:@"recordListPush" sender:self];
}


#pragma mark -本地抓图
- (void)takePhoto{
    
    isNeedTakePhoto = YES;
}

#pragma mark -抓取图片保存到本地
- (void)saveImage:(yuv_handle)yuv_h{
    
    bitmap_handle bitmap_h;
    hm_video_yuv_2_rgb(yuv_h, HME_BF_BGR32, &bitmap_h); //
    
    P_BITMAP_INFO_HEADER pBitmapInfo;
    hm_video_get_bitmap_info(bitmap_h, &pBitmapInfo);
    uint32 len;
    cpchar bitmapData ;
    hm_video_get_bitmap_data(bitmap_h,&len,&bitmapData);
    
    unsigned char* copyBit = (unsigned char*)malloc(len);
    memcpy(copyBit+1, bitmapData, len-1);
    
    float nWidth = pBitmapInfo->biWidth;
    float nHeight = fabsf(pBitmapInfo->biHeight);
    UIImage* image = [self convertBitmapRGBA8ToUIImage:copyBit withWidth:nWidth withHeight:nHeight];
    [self performSelectorOnMainThread:@selector(saveImageToAlbum:) withObject:image waitUntilDone:NO];
    free(copyBit);
    
}

- (void)saveImageToAlbum:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    NSLog(@"error:%@",error);
    
}

#pragma mark *************** 附加操作 ***************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"picListPush"]) {
        
        HMPicListViewController *listControl = segue.destinationViewController;
        listControl.userId = self.userId;
        listControl.nodeObject = nodeObject;
        listControl.channelObject = channelObject;
        
    }else if ([segue.identifier isEqualToString:@"recordListPush"]){
        
        HMRecordListViewController *listControl = segue.destinationViewController;
        listControl.nodeObject = nodeObject;
        listControl.channelObject = channelObject;
        
    }
    
    
    
}

-(UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer withWidth:(int) width withHeight:(int) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    
    
    //	CGBitmapInfo bitmapInfo = kCGBitmapByteOrder16Little;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little;
    //    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder16Big;
    //    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big;
    
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,	// data provider
                                    NULL,		// decode
                                    YES,			// should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 kCGImageAlphaPremultipliedLast);
    
    if(context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);
        CGContextRelease(context);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }
    return image;
}

//附加信息
//以下为云台控制 1.ptz_cmd 为云台控制命令2.speed为云台转动速度

/*
 hm_pu_ptz_control(userId, 0, HME_PC_LEFT, 5);
 */
@end
