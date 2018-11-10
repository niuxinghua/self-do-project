//
//  define.h
//  HM_server_demo
//
//  Created by 邹 万里 on 13-8-2.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#ifndef HM_server_demo_define_h
#define HM_server_demo_define_h


#define iPod				@"iPod1,1"
#define iPod2G				@"iPod1,2"
#define iPhone				@"iPhone1,1"
#define iPhone3G			@"iPhone1,2"
#define iPhoneSimulator		@"x86_64"


#define NET_NONE            0
#define NET_WIFI            1
#define NET_3G_OR_GPRS      2

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO

#define SWS_BICUBIC           4
#define SWS_FAST_BILINEAR     1

#define USE_DEPTH_BUFFER 1
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)
#define kHWMachine							"hw.machine"


#define kAUDIO_QUEUE_NUM_BUFFERS            3 //队列缓冲个数
#define kAUDIO_DATA_BUFFER_MAXLENGTH        320   //320 音频队列最大长度，超过这个长度，有可能被直接抛弃
#define kAUDIO_DATA_BUFFER_BYTES			4096
#define kAUDIO_DATA_SIMULATE_LENGTH			320	//音频队列中无数据时，以这个长度的空白数据插入到AudioQueue缓冲区中，以便保持AudioQueue有效

#define kTALK_DATA_SAMPLE_DURATION			0.02									//对讲声音数据采样时间片

#define AVCODEC_MAX_AUDIO_FRAME_SIZE        4096*2// (0x10000)/4


#define kDATETIMEFORMAT						@"yyyy-MM-dd HH:mm:ss"						//日期时间格式化


#define kVIDEO_DATA_BUFFER_MAXLENGTH 		80     // 200
#define kVIDEO_DATA_BUFFER_BYTES			2048   // 4096

#define TableViewListLineHeight             49
#define TableViewSnapLineHeitht             76



//自定义提示模块
#define HMAlertTypeUpdate                   0          //更新提示类型
#define HMAlertTypeAlert                    1          //报警提示类型
#define HMAlertTypeModify                   2          //修改名称类型
#define HMAlertTypeWifiSet                  3          //输入wifi名称和密码

#define HMAlertBtnOk                        0
#define HMAlertBtnCancel                    1

//ptz相关定义
#define kPTZ_DirectionLeft					1
#define kPTZ_DirectionRight					3
#define kPTZ_DirectionTop					4
#define kPTZ_DirectionBottom				2
#define kPTZ_ZOOMOUT						9
#define kPTZ_ZOOMIN							10
#define kPTZ_NEAR							7
#define kPTZ_FARWAY							8
#define kPTZ_DFT_PTZSPEED					3

//存储路径文件
#define DevAlarmInfofile                    @"AlarmInfoDict"

//Tags
#define kTagOfRemoteNotificationAlertView	401										//推送通知弹出界面
#define kTagOfAppSettingsButton				301										//应用程序设置按钮

//推送通知相关
#define kPushGatewayServiceUrlKey			@"PushGatewayServiceUrl"
#define kPushNotificationUploadHashFormat	@"%@%@%d%d%@huamai"
#define kNotificationDeviceStringSperator	@","
#define kRemoteNotificationAPSKey			@"aps"
#define kRemoteNotificationAPSAlertKey		@"alert"

#define kRemoteNotificationCountRefresh     @"kRemoteNotificationCountRefresh"

//程序加载
#define kLaunchOptionKeySN					@"sn"
#define kLaunchOptionKeyChannel				@"channel"


#define kSnapShotSoundFileName				@"snapshot"								//截图时播放声音的文件名
#define kSnapShotSoundFileType				@"caf"									//截图时播放声音的文件类型
#define kControlBarHidden					@"controlBarHidden"
#define kSnapshotCurlUp						@"snapshotCurlUp"

#define LocalSettingfile                    @"settingfile"                          //本地设置配置信息 
#define StartAnimationfile                  @"startanimation"                       //启动动画


//保存密码配置相关定义
#define UserProfile							@"userprofile"
#define CurUserfile                         @"curuserfile"
#define WifiInfoUserfile                    @"wifiinfouserfile"

//按钮taget
#define kTagOfBackLoginButton               201
#define kTagOfAddDevButton                  202 
#define kTagOfAlarmCountButton              203



#define kDateTimePickerSettingsType			@"DateTimePicker"						//日期选择配置的Type
//通知设置相关定义
#define kEnableNotificationSettingsKey		@"enableNotification"
#define kEnableAllDeviceSettingsKey			@"enableAllDevice"						//开启所有设备通知
#define kSelectedNotificationDeviceListSettingsKey	@"selectedNotificationDeviceList"	//通知设备列表
#define kNotificationStartTimeSettingsKey	@"notificationStartTime"				//通知开始时间
#define kNotificationEndTimeSettingsKey		@"notificationEndTime"					//通知结束时间

//表格单元格标示符
#define kNotificationDeviceTableViewCell	@"NotificationDeviceTableViewCell"		//通知设备列表单元格标示符
#define kDeviceListTableViewCell			@"DeviceListTableViewCell"				//设备列表单元格标示符
#define kUserListTableViewCell			    @"UserListTableViewCell"				//用户列表单元格标示符

#endif
