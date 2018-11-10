/****************************************************\
*	Copyright (c) �ɶ�����ͨ�ż������޹�˾��Ȩ����	*
*													*
*	�ļ����� : hm_sdk.h								*
*	��ǰ�汾 : 2.3									*
*	��дĿ�� : �ṩ���ο�����Ҫ�ĺ����ӿ�֮����		*
*	�״�������� : 2013-12-16						*
\****************************************************/
#ifndef __HM_SDK_H__
#define __HM_SDK_H__

typedef const char*			cpchar;
typedef char*				pchar;
typedef void*				pointer;
typedef const void*			cpointer;
typedef signed char			int8;
typedef unsigned char		uint8;
typedef signed short		int16;
typedef unsigned short		uint16;
typedef signed int			int32;
typedef unsigned int		uint32;
typedef long long			int64;
typedef unsigned long long	uint64;
typedef float				real32;
typedef double				real64;
typedef uint32				hm_result;					//	���ش���������
typedef pointer				window_handle;				//	���ھ��������Windowsƽ̨����Ч
typedef pointer				user_id;					//	��½�豸�ķ���ֵ
typedef pointer				video_handle;				//	ʵʱ��Ƶ���
typedef pointer				audio_handle;				//	ʵʱ��Ƶ���
typedef pointer				talk_handle;				//	�Խ����
typedef pointer				alarm_handle;				//	�������
typedef pointer				alarm_host_handle;			//	�������
typedef pointer				record_handle;				//	�ֶ�¼����
typedef pointer				find_file_handle;			//	¼����Ҿ��
typedef pointer				playback_handle;			//	¼��طž��
typedef pointer				get_file_handle;			//	����¼����	
typedef pointer				find_picture_handle;		//	ͼƬ���Ҿ��
typedef pointer				get_picture_handle;			//	����ͼƬ���	
typedef pointer				search_wifi_handle;			//	��ȡwifi��Ϣ���
typedef pointer				get_online_user_handle;		//	��ȡ�����û����
typedef pointer				upgrade_handle;				//	�������
typedef pointer				server_id;					//	����ƽ̨�ķ���ֵ
typedef pointer				tree_handle;				//	�豸�����
typedef pointer				node_handle;				//	�豸���
typedef pointer				audio_codec_handle;			//	��Ƶ�������
typedef pointer				video_codec_handle;			//	��Ƶ������
typedef pointer				yuv_handle;					//	yuv���
typedef pointer				bitmap_handle;				//	λͼ���
typedef pointer				audio_capture_handle;		//	��Ƶ���ݲɼ����
typedef pointer				audio_player_handle;		//	��Ƶ���ž��
typedef pointer				local_record_handle;		//	����¼����
typedef pointer				local_playback_handle;		//	������Ƶ���
typedef	pointer				lan_device_search_handle;	//	�������豸�������
typedef pointer 			push_service_handle;		//	���ͷ�����
typedef pointer				port_handle;				//	�˿ھ��������Windowsƽ̨����Ч
typedef pointer				listen_handle;				//	��������������豸��������
typedef pointer				get_handle;					//	�������
typedef pointer				user_data;					//	�û�����

#define hm_stdcall
#define hm_cdecl
#define hm_fastcall
#define hm_call

#define OPERATION_TIMEOUT 20000

/****************\
*	�����붨��	*
\****************/
typedef enum _HM_ERROR_CODE
{
	HMEC_OK							= 0,			//	�ɹ�

	HMEC_GEN_SDK_INIT				= 0x01000001,	//	SDK��ʼ��ʧ��
	HMEC_GEN_CREATE_HANDLE,							//	�����������
	HMEC_GEN_PARAM_INVALID,							//	������Ч
	HMEC_GEN_NODE_INVALID,							//	�ڵ���Ч
	HMEC_GEN_URL_INVALID,							//	URL��Ч
	HMEC_GEN_FIND_FILE_OVER,						//	�ļ���ѯ���
	HMEC_GEN_VIDEO_PLAYER_INIT,						//	��ʼ����Ƶ������ʧ��
	HMEC_GEN_INIT_LISTEN,							//	��ʼ��������ʧ��
	HMEC_GEN_START_LISTEN,							//	����ʧ��
	HMEC_GEN_NOT_SUPPORT,							//	�ӿڲ���֧��
	HMEC_GEN_INTERNAL,								//	�ڲ�����

	HMEC_ERR_UTIL_INIT				= 0x00A00001,	//	��ʼ��ʧ��
	HMEC_ERR_UTIL_FILE_INVALID,						//	�ļ���Ч
	HMEC_ERR_UTIL_FILE_NOT_OPEN,					//	���ļ�ʧ��
	HMEC_ERR_UTIL_FILE_READ_FAIL,					//	��ȡ�ļ�ʧ��
	HMEC_ERR_UTIL_FILE_WRITE_FAIL,					//	д���ļ�ʧ��
	HMEC_ERR_UTIL_FILE_CREATE,						//	����¼���ļ�ʧ��
	HMEC_ERR_UTIL_RECORD_STOP,						//	ֹͣ¼��
	HMEC_ERR_UTIL_END_OF_FILE,						//	�ļ���ȡ���
	HMEC_ERR_UTIL_PARAM_INVALID,					//	������Ч
	HMEC_ERR_UTIL_IP_NOT_FOUND,						//	IPδʶ��
	HMEC_ERR_UTIL_SEND_MODE,						//	����ķ���ģʽ
	HMEC_ERR_UTIL_NOT_SUPPORT_IN_MODE,				//	��ǰģʽ�²�֧�ָ�����

	HMEC_ERR_PU_UNDEF				= 0x00800001,	//	δ�������
	HMEC_ERR_PU_BUSY,								//	�豸æ
	HMEC_ERR_PU_BAD_PARAM,							//	����Ĳ���
	HMEC_ERR_PU_BAD_FORMAT,							//	����ĸ�ʽ
	HMEC_ERR_PU_INTERNAL,							//	�ڲ�����
	HMEC_ERR_PU_UNREG_CMD,							//	����ʶ�������
	HMEC_ERR_PU_MAX_CONNECTION,						//	�������������
	HMEC_ERR_PU_NOT_LOGIN,							//	δ��֤
	HMEC_ERR_PU_BAD_USER,							//	������û���
	HMEC_ERR_PU_UNSUPPORT,							//	��֧�ֵĲ���������Խ���ʽ��
	HMEC_ERR_PU_DISK_NOT_EXIST,						//	�洢���ʲ�����
	HMEC_ERR_PU_DISK_FULL,							//	������
	HMEC_ERR_PU_CHANNEL_USED,						//	ͨ��æ
	HMEC_ERR_PU_CHANNEL_CLOSED,						//	��ǰͨ���ѹر�
	HMEC_ERR_PU_CHANNEL_ERR,						//	�����ͨ����
	HMEC_ERR_PU_OPERATION_ABORT		= 0x00800050,	//	�����ж�
	HMEC_ERR_PU_READ_LESS_LENGTH,					//	��ȡ�����ݳ���̫С
	HMEC_OPERATION_TIMEOUT,							//	������ʱ
	HMEC_ERR_PU_NONSUPPORT,							//	δ��֧�ֵĲ�������Э�鲻����
	HMEC_ERR_PU_SEND_DATA_INVALID,					//	����������Ч
	HMEC_ERR_PU_NR_ERROR,							//	��ת��͸ʧ��
	HMCE_ERR_PU_GET_STATUS_ERROR,					//	��ȡ��������״̬ʧ��

	HMEC_ERR_SERVER_NETWORK			= 0x00700001,	//	�������
	HMEC_ERR_SERVER_COMMAND,						//	�������
	HMEC_ERR_SERVER_USER_OR_PWD,					//	�û������������
	HMEC_ERR_SERVER_NOT_AUTH,						//	δ��֤
	HMEC_ERR_SERVER_ALREADY_LOGIN,					//	�ظ���¼
	HMEC_ERR_SERVER_GET_GROUP_LIST,					//	��ȡ����ʧ��
	HMEC_ERR_SERVER_GET_DEVICE_LIST,				//	��ȡ�豸�б�ʧ��
	HMCE_ERR_SERVER_GET_DEVICE,						//	��ȡ�豸��Ϣʧ��
	HMEC_ERR_SERVER_GET_SERVER_TIME,				//	��ȡ������ʱ��ʧ��
	HMEC_ERR_SERVER_GET_USER_INFO,					//	��ȡ�û���Ϣʧ��
	HMEC_ERR_SERVER_GET_TRANSFER_INFO,				//	��ȡ��ת��͸��Ϣʧ��
	HMEC_ERR_SERVER_GET_DEVICE_TRANSFER_CONFIG,		//	��ȡ�豸��ת��͸����ʧ��
	HMEC_ERR_SERVER_BIND_DEVICE,					//	���豸ʧ��
	HMEC_ERR_SERVER_UNBIND_DEVICE,					//	����豸ʧ��
	HMEC_ERR_SERVER_DELETE_GROUP,					//	ɾ������ʧ��
	HMEC_ERR_SERVER_MOVE_GROUP,						//	�ƶ�����ʧ��
	HMEC_ERR_SERVER_USER_CANCEL,					//	�û�ȡ������
	HMEC_ERR_SERVER_REGUSR,							//	ע���û�ʧ��
	HMEC_ERR_SERVER_MODIFYPWD,						//	�޸�����ʧ��
	HMEC_ERR_SERVER_USER_ALREADY_EXIST,				//	�û����Ѵ���
	HMEC_ERR_SERVER_USER_NOT_EXIST,					//	�û���������
	HMEC_ERR_SERVER_MOBILE_ERROR,					//	�ֻ��������
	HMEC_ERR_SERVER_CAPTCHA_ERROR,					//	��֤�����
	HMEC_ERR_SERVER_CAPTCHA_EXPIRED,				//	��֤���ѹ���
	HMEC_ERR_SERVER_NICKNAME_UESD,					//	�ǳ��ѱ�ע��
	HMEC_ERR_SERVER_EMAIL_ERROR,					//	�������
	HMEC_ERR_SERVER_SM_UNAVAILABLE,					//	���ŷ��񲻿���
	HMEC_ERR_SERVER_USER_MOBILE_INCORRECT,			//	�û����ֻ��Ų�ƥ��
	HMEC_ERR_SERVER_ERROR_MOBILE,					//	�ֻ������ʽ����
	HMEC_ERR_SERVER_MOBILE_USED,					//	�ֻ����Ѿ���ע��
	HMEC_ERR_SERVER_ERROR_PASSWORD,					//	�����ʽ����ȷ
	HMEC_ERR_SERVER_USER_EMAIL_INCORRECT,			//	�û������䲻ƥ��
	HMEC_ERR_SERVER_EMAIL_NOT_AUTH,					//	����δ��֤
	HMEC_ERR_SERVER_EMAIL_SERV_UNAVAILABLE,			//	�ʼ����񲻿���
	HMEC_ERR_SERVER_CANNOT_RESET_PWD,				//	�޷��������һ�
	HMEC_ERR_SERVER_NO_GUARD_EMAIL,					//	û���ܱ�����
	HMEC_ERR_SERVER_NO_GUARD_MOBILE,				//	û���ܱ��ֻ�
	HMEC_ERR_SERVER_MOBILE_NOT_AUTH,				//	�ֻ���δ��֤
	HMEC_ERR_SERVER_INTERNAL,						//	�������ڲ�����
	HMEC_ERR_SERVER_SET_PRIVACY,					//	��˽����ʧ��
	HMEC_ERR_SERVER_GET_VERSION,					//	��ȡ�������汾ʧ��
	HMEC_ERR_SERVER_UPDATE_PARAM,					//	������������
	HMEC_ERR_SERVER_UPDATE_HASH,					//	��֤�����
	HMEC_ERR_SERVER_UPDATE_PACKAGE,					//	��������
	HMEC_ERR_SERVER_GET_HISTORY_ERROR,				//	��ȡ������ʷ��Ϣʧ��
	HMEC_ERR_SERVER_GET_HISTORY_UNREAD_COUNT_ERROR,	//	��ȡ����δ������ʧ��
	HMEC_ERR_SERVER_MARK_ALARM_HISTORY_READ_ERROR,	//	����Ѷ�ʧ��
	HMEC_ERR_SERVER_GET_ALARM_INFO_ERROR,			//	��ȡ������Ϣʧ��
	HMEC_ERR_SERVER_DELETE_ALARM_ERROR,				//	ɾ��������Ϣʧ��
	HMEC_ERR_SERVER_MARK_PARAM_ERROR,				//	��������ȷ
	HMEC_ERR_SERVER_MARK_NO_ALARM,					//	û���ҵ�����
	HMEC_ERR_SERVER_SYS_NOTI_ERROR,					//	��ȡϵͳ֪ͨ��Ϣʧ��
	HMEC_ERR_SERVER_UPGRADE_USERNAME,				//	�����û���Ϣʧ��
	HMEC_ERR_SERVER_MAXERR,

	HMEC_ERR_VIDEO_FIND_DECODER		= 0x00300001,	//	δ֪��������
	HMEC_ERR_VIDEO_ALLOC_CONTEXT,					//	����������ʧ��
	HMEC_ERR_VIDEO_CODEC_OPEN,						//	�򿪽�����ʧ��
	HMEC_ERR_VIDEO_ALLOC_FRAME,						//	����洢�ռ�ʧ��
	HMEC_ERR_VIDEO_STATE_DECODING,					//	����ʧ��
	HMCE_ERR_VIDEO_STATE_ENCODING,					//	����ʧ��
	HMEC_ERR_VIDEO_PARAM,							//	�����������
	HMEC_ERR_AUDIO_SPEEX_INIT,						//	��ƵSPEEX�������ʼ��ʧ��
	HMEC_ERR_AUDIO_BUF_LEN			= 0x0030000A,	//	��Ƶ������������С�����Դ������
	HMEC_ERR_AUDIO_FIND_DECODER,					//	��Ƶ�������ʹ���
	HMEC_ERR_AUDIO_FIND_ENCODER,					//	��Ƶ�������ʹ���
	HMEC_ERR_AUDIO_CAP_INIT,						//	��Ƶ�ɼ���ʼ��ʧ��
	HMEC_ERR_AUDIO_CAP_ALREADY_INIT,				//	��Ƶ�ɼ��ظ���ʼ��
	HMEC_ERR_AUDIO_CAPING			= 0x00300010,	//	�ɼ�ʧ��
	HMEC_ERR_AUDIO_PLAYER_CREATE,					//	��Ƶ����������ʧ��
	HMEC_ERR_AUDIO_PLAYER_ALREADY_INIT,				//	��Ƶ�������ظ���ʼ��
	HMEC_ERR_AUDIO_PLAYER_UNKNOWN_TYPE,				//	δ֪��Ƶ����
	HMEC_ERR_AUDIO_PLAYER_SET_COOP_LEVEL,			//	����Э����ʧ��
	HMEC_ERR_AUDIO_PLAYER_CREATE_BUF				//	����洢�ռ�ʧ��
} HM_ERROR_CODE;

// ��Ƶ��������
typedef enum _VIDEO_ENCODE
{
	HME_VE_H264		= 1,
	HME_VE_MPEG4	= 2,
	HME_VE_H265		= 4,
} VIDEO_ENCODE;

// ��Ƶ��������
typedef enum _AUDIO_ENCODE
{
	HME_AE_NONE = -1,
	HME_AE_PCMS8 = 0,
	HME_AE_ARM,
	HME_AE_SPEEX,
	HME_AE_ADPCM,
	HME_AE_AAC,
	HME_AE_G711A,
	HME_AE_G711U,
} AUDIO_ENCODE;

typedef enum _ALARM_DEVICE_TYPE
{
	HME_ADT_VIDEO_DEV			=	0x00000001,	//	��Ƶ�豸
	HME_ADT_GPIO_DEV			=	0x00000002,	//	GPIO�豸
	HME_ADT_STORGE_DEV			=	0x00000004,	//	�洢�豸
	HME_ADT_REMOTECTRL_DEV		=	0x00000008,	//	ң��
	HME_ADT_MAGNETOMETER_DEV	=	0x00000010,	//	�Ŵ�
	HME_ADT_INFRARED_DEV		=	0x00000020,	//	����
	HME_ADT_SMOKE_DEV			=	0x00000040,	//	�̸�
	HME_ADT_COAL_DEV			=	0x00000080,	//	ú��
	HME_ADT_WATER_DEV			=	0x00000100,	//	ˮ��
	HME_ADT_QUAKE_DEV			=	0x00000200,	//	��
	HME_ADT_PC_CLIENT			=	0x00000400,	//	PC�ͻ���
	HME_ADT_PHONE_CLIENT		=	0x00000800,	//	�ֻ��ͻ���
	HME_ADT_WEB_PLUGIN			=	0x00001000,	//	��ҳ��� 
	HME_ADT_KEEP_NIGHT_WATCH	=	0x00002000,	//	Ѳ��
	HME_ADT_GUARDBAIL			=	0x00004000,	//	����
	HME_ADT_BOUNDARY			=	0x00008000,	//	�ܽ�
	HME_ADT_DANGER_BUTTON		=	0x00010000,	//	������ť
	HME_ADT_PLATFORM_SERVER		=	0x00020000	//	ƽ̨������
} ALARM_DEVICE_TYPE;

typedef enum _ALARM_TYPE
{
	HME_AT_SENSOR				=	0x00000001,	//	���������汨��
	HME_AT_MOTION				=	0x00000002,	//	�ƶ����
	HME_AT_VIDEO_OCCUSION		=	0x00000004,	//	��Ƶ�ڵ�
	HME_AT_VIDEO_LOSS			=	0x00000008,	//	��Ƶ��ʧ
	HME_AT_SD_FULL				=	0x00000010,	//	SD����
	HME_AT_SD_ERROR				=	0x00000020,	//	SD������
	HME_AT_SD_NOTEXIST			=	0x00000040,	//	SD��������
	HME_AT_ARM					=	0x00000080,	//	����
	HME_AT_DISARM				=	0x00000100,	//	����
	HME_AT_EMERGENCY			=	0x00000200,	//	����
	HME_AT_POWER_LOW			=	0x00000400,	//	��������
	HME_AT_SENSOR_LOSS_HEART	=	0x00000800,	//	������������ʧ
	HME_AT_SENSOR_REMOVED		=	0x00001000,	//	���������
	HME_AT_POWER_RESUME			=	0x00002000	//	��ѹ�ָ�
} ALARM_TYPE;

//	����Ƶ
typedef enum _CODE_STREAM
{
	HME_CS_NONE		= -1,
	HME_CS_ULTRA_HD = 0,
	HME_CS_MAJOR	= 1,
	HME_CS_MINOR	= 2,
} CODE_STREAM;

typedef enum _VIDEO_STREAM
{
	HME_VS_NONE			= 0,
	HME_VS_REAL			= 1,
	HME_VS_PRERECORD	= 2
} VIDEO_STREAM;

//	��̨��������
typedef enum _PTZ_COMMAND
{
	HME_PC_NONE			= 0,
	HME_PC_UP			= 1,	//	��ת
	HME_PC_LEFT			= 2,	//	��ת
	HME_PC_DOWN			= 3,	//	��ת
	HME_PC_RIGHT		= 4,	//	��ת
	HME_PC_FOCUSUP		= 7,	//	���� : ��
	HME_PC_FOCUSDOWN	= 8,	//	���� : ��
	HME_PC_ZOOMIN		= 9,	//	�Ŵ�
	HME_PC_ZOOMOUT		= 10,	//	��С
	HME_PC_APTSMALL		= 11,	//	��Ȧ : ��С
	HME_PC_APTBIG		= 12,	//	��Ȧ : ����
	HME_PC_LIGHTON		= 13,	//	�ƹ⿪
	HME_PC_LIGHTOFF		= 14	//	�ƹ��
} PTZ_COMMAND;

typedef enum _PTZ_INTERVAL
{
	HME_PI_NONE		= 0,
	HME_PI_LR	    = 5,	//	����Ѳ��
	HME_PI_END		= 6,	//	ֹͣѲ��
	HME_PI_UDLR		= 19,	//	��������Ѳ��
	HME_PI_UD	    = 20	//	����Ѳ��
} PTZ_INTERVAL;

// �ڵ�����
typedef enum _NODE_TYPE_INFO
{
	HME_NT_NONE = 0,
	HME_NT_DEVICE,		// �豸�ڵ�
	HME_NT_DVS,			// DVS�ڵ�
	HME_NT_GROUP,		// ����ڵ�
	HME_NT_CHANNEL		// ͨ���ڵ�
} NODE_TYPE_INFO;

typedef enum _SEARCH_MODE
{
	HME_SM_NONE				= 0,
	HME_SM_BEG_AND_END_TIME	= 1,	
	HME_SM_MONTH			= 2,
} SEARCH_MODE;


//	¼���ѯ���������
typedef enum _VIDEO_RECORD
{
	HME_VR_NONE			= 0,
	HME_VR_HANDLER		= 1,
	HME_VR_ALARMTYPE	= 2,
	HME_VR_TIMER		= 4,
} VIDEO_RECORD;

typedef enum _REMOTE_PLAYBACK_MODE
{
	HME_PBM_NONE		= 0,
	HME_PBM_NAME_TIME	= 1,	//	�����ļ������ļ�����ʱ��ط�
	HME_PBM_START_END	= 2,	//	�ӿ�ʼʱ�䴦��ʼ�طŵ�����ʱ�䴦Ϊֹ
	HME_PBM_ALARM_KEY	= 3,	//	���ݱ���key�����ļ��ط�
	HME_PBM_DOWNLOAD    = 4,    //  ����Զ��¼������
} REMOTE_PLAYBACK_MODE;

//	ͼƬ��ز���
typedef enum _PIC_CAP_TYPE
{
	HME_PCT_NONE		= 0,
	HME_PCT_HANDLER		= 1,
	HME_PCT_ALARMTYPE	= 2,
	HME_PCT_TIMER		= 4,
} PIC_CAP_TYPE;

typedef enum _PIC_DOWNLOAD_MODE
{
	HME_PDM_NONE			= 0,
	HME_PDM_FILENAME		= 1,
	HME_PDM_START_END_TIME	= 2,
	HME_PDM_KEY				= 3
} PIC_DOWNLOAD_MODE;

typedef enum _RAW_FRAME_TYPE
{
	HME_RFT_NONE	= -1,
	HME_RFT_P		= 0,
	HME_RFT_I		= 1,
	HME_RFT_AUDIO	= 2,
	HME_RFT_H265_P  = 0x20,
	HME_RFT_H265_I	= 0x21,
	HME_RFT_PCM		= 5,
	HME_RFT_SPEEX	= 6,
	HME_RFT_AAC		= 7,
	HME_RFT_ARM		= 8,
	HME_RFT_ADPCM	= 0xA,
	HME_RFT_G711A	= 0xB,
	HME_RFT_G711U	= 0xC,	
	HME_RFT_INFO	= 9, 
} RAW_FRAME_TYPE;

typedef enum _BITMAP_FORMAT
{
	HME_BF_NONE = 0,
	HME_BF_RGB32,
	HME_BF_BGR32,
	HME_BF_RGBA32,
	HME_BF_RGB16_565
} BITMAP_FORMAT;

//	�û�����
typedef enum _USER_ROLE
{
	HME_UR_MANAGER	=	3,	//	������
	HME_UR_OPERATOR	=	2,	//	������
	HME_UR_OBSERVER	=	1,	//	�۲���
	HME_UR_VISITOR  =   0	//  �ÿ�
} USER_ROLE;

//	�ط�ģʽ
typedef enum _PB_MODE
{
	HME_PM_NONE		= 0,
	HME_PM_ACTIVE	= 1,	//	����ģʽ
	HME_PM_PASSIVE	= 2		//	����ģʽ
} PB_MODE;

//	�ط�����
typedef enum _PLAYBACK_RATE
{
	HME_PBR_NONE	= 0,	//	��Чֵ
	HME_PBR_1X		= 1,	//	ԭʼ����
	HME_PBR_2X		= 2,	//	2����
	HME_PBR_4X		= 4,	//	4����
	HME_PBR_8X		= 8,	//	8����
	HME_PBR_S2X		= -2,	//	1/2����
	HME_PBR_S4X		= -4,	//	1/4����
	HME_PBR_S8X		= -8	//	1/8����
} PLAYBACK_RATE;

typedef enum _LAN_SEARCH_MODE
{
	HME_LSM_NONE	= 0,	//	��Чֵ
	HME_LSM_BC		= 1,	//	�㲥����
	HME_LSM_MC		= 2		//	�ಥ����
} LAN_SEARCH_MODE;

typedef enum _UPDATE_TYPE
{
	HME_UT_BOOTLOADER = 1,
	HME_UT_KERNEL,
	HME_UT_ROOTFS
} UPDATE_TYPE;

typedef enum _DISPLAY_MODE
{
	HME_DM_NONE = 0,
	HME_DM_DX,				//	DXģʽ��ʾ
	HME_DM_VFW				//	VFWģʽ��ʾ
} DISPLAY_MODE;

typedef enum _PIC_QUALITY
{
	HME_PQ_HIGH = 1,		//	�߻���
	HME_PQ_LOW				//	�ͻ���
} PIC_QUALITY;

typedef enum _DEV_PRIVACY
{
	HME_DP_NONE = -1,	//	��Чֵ
	HME_DP_OFF  = 0,	//	��˽������
	HME_DP_ON			//	��˽������
} DEV_PRIVACY;

typedef enum _MATCH_SENSOR_RESULT
{
	MSR_UNKNOWN_RESULT,
	MSR_SUCCUSS,
	MSR_NOT_LEARN_MOD,
	MSR_NO_SENSOR	
} MATCH_SENSOR_RESULT;

//	�ͻ�������
typedef enum _CLIENT_TYPE
{
	CT_MOBILE	= 0,	//	�ƶ�
	CT_PC		= 1,	//	PC
	CT_PLUGIN	= 2,	//	���
	CT_PLAT		= 3,	//	ƽ̨
	CT_PU		= 10	//	�豸
} CLIENT_TYPE;

//	����ģʽ��֧�������
typedef enum _CONNECT_MODE
{
	CM_DIR		= 1,	//	��ֱ��
	CM_NAT		= 2,	//	����͸
	CM_RLY		= 4,	//	����ת
	CM_DEF		= 7		//	Ĭ�ϣ�ֱ������͸����תͬʱ���ӣ�
} CONNECT_MODE;

//	�������ȼ�
typedef enum _CONNECT_PRI
{
	CPI_DIR	= 1,		//	ֱ������
	CPI_NAT	= 2,		//	��͸����
	CPI_RLY	= 3,		//	��ת����
	CPI_DEF	= 4			//	Ĭ�����ȼ���ֱ�� = ��͸ > ��ת��
} CONNECT_PRI;

#pragma pack(push)
#pragma pack(1)

typedef void (hm_call * cb_pu_net) (user_data data, hm_result result, uint32 connect_type);
typedef struct _FRAME_INFO
{
	uint16	channel;			//	ͨ���� 0��1��2��
	uint16	data_type;			//	������ 1-ʵʱ 2-Ԥ¼ 3-�ط�
	uint16	stream_type;		//	�������� 1-������ 2-������ 3-������
	uint16	frame_type;			//	֡���� 0-P֡(H264) 1-I֡(H264) 0x20-P֡(H265) 0x21-I֡(H265) 3-�����仯֡ 5-PCM��Ƶ֡ 6-SPEEX��Ƶ֡ 7-AAC��Ƶ֡ 9-��Ϣ֡
	uint64	absolute_timestamp;	//	ʱ�������λ����
} FRAME_INFO, *P_FRAME_INFO;

typedef struct _FRAME_DATA
{
	FRAME_INFO frame_info;
	uint32     frame_len;		//	����������
	cpointer   frame_stream;	//	����
} FRAME_DATA, *P_FRAME_DATA;

//	DVSͨ�������������豸����Ӧ1��ͨ����ͨ����Ϊ0��
typedef struct _CHANNEL_CAPACITY
{
	char	channel_name[260];			//	ͨ������
	char	video_name[260];			//	��Ƶ����
	bool	video_support;				//	��Ƶ֧��
	bool	audio_support;				//	��Ƶ֧��
	bool	talk_support;				//	�Խ�֧��
	bool	ptz_support;				//	��̨֧��
	AUDIO_ENCODE audio_code_type;		//	��Ƶ����
	int32	audio_sample;				//	������
	int32	audio_channel;				//	����
} CHANNEL_CAPACITY, *P_CHANNEL_CAPACITY;

// �豸��Ϣ
typedef struct _DEVICE_INFO
{
	char	dev_name[260];		//	�豸����
	char	dev_type[64];		//	�豸����
	char	sn[14];				//	�豸SN��
	int32	total_channel;		//	ͨ������
	int32	alram_in_count;		//	��������ͨ����
	int32	alarm_out_count;	//	�������ͨ����
	int32	sensor_count;		//	����������
	int32   support_third_stream; // 0:���豸 1:���豸֧�������� 2:���豸��֧��������
	P_CHANNEL_CAPACITY  channel_capacity[200];	//	DVSͨ�������������豸����Ӧ1��ͨ����ͨ����Ϊ0��
} DEVICE_INFO, *P_DEVICE_INFO;

typedef void (hm_call * cb_pu_data) (user_data data, P_FRAME_DATA frame, hm_result result);
typedef struct _OPEN_VIDEO_PARAM
{
	uint32		 channel;
	CODE_STREAM  cs_type;
	VIDEO_STREAM vs_type;
	cb_pu_data   cb_data;
	window_handle wnd;
	user_data	 data;
} OPEN_VIDEO_PARAM, *P_OPEN_VIDEO_PARAM;

typedef struct _OPEN_VIDEO_RES
{
	uint32 channel;
	VIDEO_ENCODE encode_type;
	int32 image_width;
	int32 image_height;
	int32 fps;
	int64 basetime;
} OPEN_VIDEO_RES, *P_OPEN_VIDEO_RES;

//	����Ƶ�������
typedef struct _OPEN_AUDIO_PARAM
{
	uint32 channel;
	cb_pu_data cb_data;
	user_data  data;
} OPEN_AUDIO_PARAM, *P_OPEN_AUDIO_PARAM;

//	����Ƶ��Ӧ
typedef struct _OPEN_AUDIO_RES
{
	uint32			channel;
	AUDIO_ENCODE	audio_type;
	int32			sample;
	int32			audio_channel;
} OPEN_AUDIO_RES, *P_OPEN_AUDIO_RES;

//	�򿪶Խ��������
typedef struct _OPEN_TALK_PARAM
{
	uint32			channel;
	AUDIO_ENCODE	audio_type;
	int32			sample;
	int32			audio_channel;
} OPEN_TALK_PARAM, *P_OPEN_TALK_PARAM;

typedef struct _OPEN_TALK_RESP
{
	AUDIO_ENCODE audio_type;
	int autio_sample;
	int audio_channel;
	int device_channel;
}OPEN_TALK_RESP, *P_OPEN_TALK_RESP;

//	�ֶ�ץȡͼƬ�������
typedef struct _REMOTE_CAPTURE_PIC_PARAM
{
	uint32 channel;
} REMOTE_CAPTURE_PIC_PARAM, *P_REMOTE_CAPTURE_PIC_PARAM;

//	������Ϣ
typedef struct _ALARM_INFO
{
	int32	alarm_dev_type;
	int32	alarm_type; 
	int32	channel;
	int32	area_id;
	char	key[512];
	char	sn[14];
	char	dev_name[260];
	char	happen_time[25];
	char	content[1024];
	char	expand[1024];
	char	hash[32];
} ALARM_INFO, *P_ALARM_INFO;

// OSD ��Ϣ
typedef struct _OSD_INFO
{
	int32	position_x;
	int32   position_y; 
	cpchar  font_name;
	int32   font_heigth; 
	int32   font_width;
	int32   text_color;
	cpchar	context;
	bool    isShow;
} OSD_INFO, *P_OSD_INFO;

typedef void (hm_call * cb_pu_alarm) (user_data data, P_ALARM_INFO alarm_info, hm_result result);
typedef	struct OPEN_ALARM_PARAM_
{
	cb_pu_alarm cb_alarm;
	user_data	data;
} OPEN_ALARM_PARAM, *P_OPEN_ALARM_PARAM;

//	������Ϣ
typedef	struct AREA_INFO_PARAM_
{
	char	area_name[260];
	uint32	area_id;
	uint32	emergency;
	uint32	channel;
} AREA_INFO_PARAM, *P_AREA_INFO_PARAM;

//	��������Ϣ
typedef	struct SENSOR_INFO_PARAM_
{
	char	sensor_name[260];
	char	sensor_id[260];
	char	sensor_type[260];
	char	area_id[260];
} SENSOR_INFO_PARAM, *P_SENSOR_INFO_PARAM;

//	��ȡ��Ե��Ĵ�������Ӧ
typedef struct MATCH_SENSOR_RES_
{
	MATCH_SENSOR_RESULT  result;
	char	sensor_id[260];
	char	sensor_type[260];
} MATCH_SENSOR_RES, *P_MATCH_SENSOR_RES;

//  wifi����
typedef struct _WIFI_INFO
{
	char	ssid_name[260];	//	wifi����
	uint8	wifi_mode;
	uint8	is_encrypt;		//	�Ƿ���� 
	uint8	encrypt_type;	//	�������ͣ�1(WEP64)��2(WEP128)��3(TKIP)��4(AES)	
	uint8	key_type;		//	�������ͣ�0(16����)��1(ASICC)
} WIFI_INFO, *P_WIFI_INFO;

typedef void (hm_call * cb_pu_wifi) (user_data data,  WIFI_INFO wifi_info);
typedef struct _QUERY_WIFI_PARAM
{
	cb_pu_wifi	cb_wifi;
	user_data	data;
} QUERY_WIFI_PARAM, *P_QUERY_WIFI_PARAM;

typedef struct _FIND_FILE_PARAM
{
	uint32			channel;
	int32			record_type;		//	¼������ 1-�ֶ�¼�� 2-����¼�� 4-��ʱ¼������λ��
	SEARCH_MODE		search_mode;		//	��ѯ��ʽ 1-���ݿ�ʼʱ�䣬����ʱ����Ҷ�Ӧ�ļ� 2-����SearchTime���²�ѯ��SearchTime(��ѯʱ��)��ʽΪ"2012-08"
	char			start_time[25];		//	ʱ���ʽ����"2009-09-29 13:50:32"
	char			end_time[25];		//	ͬ��
	char			search_month[10];
} FIND_FILE_PARAM, *P_FIND_FILE_PARAM;

typedef struct _FIND_FILE_DATA
{
	char			start_time[25];
	char			end_time[25];
	char			file_name[260];
	VIDEO_RECORD	record_type;
} FIND_FILE_DATA, *P_FIND_FILE_DATA;

typedef struct _DELETE_RECORD_FILE_PARAM
{
	int32	channel;
	char	file_name[260];
} DELETE_RECORD_FILE_PARAM, *P_DELETE_RECORD_FILE_PARAM;

//	��Ƶ�ط���Ϣ
typedef void (hm_call * cb_pu_playback_data) (user_data data, bool over, P_FRAME_DATA frame, hm_result);
typedef struct _PLAYBACK_PARAM
{
	uint32			channel;
	REMOTE_PLAYBACK_MODE play_mode;
	char			file_name[260];
	uint64			play_time;
	uint64			start_time;
	uint64			end_time;
	char			key[512];
	int32			frame_type;
	cb_pu_playback_data	cb_data;
	window_handle	wnd;
	user_data		data;
} PLAYBACK_PARAM, *P_PLAYBACK_PARAM;

typedef struct _PLAYBACK_RES
{
	uint32	video_format;
	uint32	video_fps;
	uint32	video_width;
	uint32	video_height;
	int32	audio_format;
	uint32	audio_channel;
	uint32	audio_sample;
	uint64	continuous_time;
} PLAYBACK_RES, *P_PLAYBACK_RES;

// ¼����������
typedef void (hm_call * cb_pu_download_file)(user_data data, cpointer file_data, uint32 len, hm_result result);
typedef struct _GET_FILE_PARAM
{
	uint32	channel;
	char	file_name[260];
	int32	offset;
	cb_pu_download_file cb_data;
	user_data	data;
} GET_FILE_PARAM, *P_GET_FILE_PARAM;

typedef struct _GET_FILE_RES
{
	char	file_name[260];
	uint32	file_size;
	char	md5[33];
} GET_FILE_RES, *P_GET_FILE_RES;

typedef struct _FIND_PICTURE_PARAM
{
	uint32			channel;
	int32			cap_type;
	SEARCH_MODE		search_mode;
	char			search_month[10];
	char			start_time[25];		//	[��ѯ��ʼʱ���ʽ��%04d-%02d-%02d %02d: %02d: %02d���� 2009-09-29 13:50:32]
	char			end_time[25];		//	[��ѯ����ʱ���ʽ��%04d-%02d-%02d %02d: %02d: %02d���� 2009-09-29 13:55:32]
} FIND_PICTURE_PARAM, *P_FIND_PICTURE_PARAM;

typedef struct _FIND_PICTURE_DATA
{
	char			file_name[260];
	int64			file_size;
	PIC_CAP_TYPE	cap_type;
	char			cap_time[25];
} FIND_PICTURE_DATA, *P_FIND_PICTURE_DATA;

//	��Ƭɾ��
typedef struct  _DELETE_PICTURE_PARAM
{
	uint32	channel;
	char	file_name[260];
} DELETE_PICTURE_PARAM, *P_DELETE_PICTURE_PARAM;

//	ͼƬ����
typedef struct _DOWNLOAD_PIC_INFO
{
	uint32	file_serial;
	uint32	file_size;
	uint64	abs_timestamp;
	char	file_name[40];
} DOWNLOAD_PIC_INFO, *P_DOWNLOAD_PIC_INFO;

typedef void (hm_call * cb_pu_download_picture)(user_data, P_DOWNLOAD_PIC_INFO, cpointer, uint32, int32);
typedef struct _GET_PICTURE_PARAM
{
	uint32		channel;
	char		file_name[260];
	PIC_DOWNLOAD_MODE download_mode;
	uint64		start_time;
	uint64		end_time;
	char		key[512];
	cb_pu_download_picture cb_data;
	user_data	data;
} GET_PICTURE_PARAM, *P_GET_PICTURE_PARAM;

typedef struct _GET_PICTURE_RES
{
	uint32 file_count;
} GET_PICTURE_RES, *P_GET_PICTURE_RES;

//	upnp ���
typedef struct _DETECT_UPNP
{
	uint8	result;
	uint16	port;
	uint8	on_line;
} DETECT_UPNP, *P_DETECT_UPNP;

//	ϵͳ��Ϣ
typedef struct _NETWORK_INFO
{
	int32	dhcp;
	char	network_card[30];
	char	link_state[4];
	char	ip[20];
	char	mask[20];
	char	gate_way[20];
} NETWORK_INFO, *P_NETWORK_INFO;

typedef struct _PT_SYSTEM_INFO
{
	char sn[14];
	char soft_version[30];
	char hard_version[30];
	P_NETWORK_INFO pei[10];
	char	dns_addr[10][20];
	int32	mode_3g;
	int32	status_3g;
	int32	device_on3g;
	int32	service_3g;
	int32	vendor_3g;
	int32	online_time3g;
	int32	online_count3g;
	int32	upnp;
	int32	ext_port;
	char	plt_url[20];
	uint16	plt_port;
	int32	log_in_ret;
	int32	eddns;
	int32	ddns_status;
	int32	sd_status;
	uint32	sd_size;
	uint32	sd_free_size;
	real64	sd_persent;
	char	time[25];
	char	hd_date[25];
	int32	runtime;
	real64	free_percent;
	int32	check_key;
	int32	region;
	int32	spt_platform;
	int32	ver_limit;
} PT_SYSTEM_INFO, *P_PT_SYSTEM_INFO;

//	��������
typedef void (hm_call * cb_pu_upgrade_firm)(user_data data, uint32 flag, hm_result result);
typedef struct _HARD_UPDATE_PARAM
{
	cpchar file_cont;
	uint32 file_size;
	user_data data;
	cb_pu_upgrade_firm cb_firm;
} HARD_UPDATE_PARAM, *P_HARD_UPDATE_PARAM;

//	�û�������Ϣ
typedef struct _ONLINE_USER_DATA
{
	char	user_name[260];
	char	ip[20];
	char	log_time[25];
	uint32	online_time;
} ONLINE_USER_DATA, *P_ONLINE_USER_DATA;

//	��Ƶ����
typedef struct _CONFIG_VIDEO
{
	int32		channel;		//	ͨ����
	int32		fps;			//	֡��
	int32		bitrate;		//	������С��16-4096
	CODE_STREAM	stream_type	;	//	�������� 0-��Ч 1-������ 2-������
	char		resolution[20];	//	�ֱ��� 160*120��176*144��176*120��320*240��352*288��352*240��640*480��704*576��704*480��1280*720��1280*960 
} CONFIG_VIDEO, *P_CONFIG_VIDEO;

//	3G����
typedef struct _CONFIG_3G
{
	int32	mode_3g;		//	3g����ģʽ
	int32	service_3g;		//	3g������
	int32	offline_mode;	//	����ģʽ
	int32	time_out;		//	����ʱ��
	bool	limit_tel_mode;	//	�绰��������
	char	limittel[20];	//	���Ƶĵ绰����
	char	sm_on_cmd[10];	//	����ָ��
	char	sm_off_cmd[10];	//	����ָ��
} CONFIG_3G, *P_CONFIG_3G;

//	����
typedef struct _CONFIG_NET
{
	int32	dhcp_mode;				//	���÷�ʽ
	char	ip[20];					//	IP��ַ
	char	mask[20];				//	��������
	char	gateway[20];			//	����
	char	dns1[20];				//	DNS1
	char	dns2[20];				//	DNS2
	char	device_name[260];		//	������
	bool	is_open_wireless;		//	������������
	int32	wireless_dhcp_mode;		//	���÷�ʽ
	char	wireless_ip[20];		//	IP��ַ
	char	wireless_mask[20];		//	��������
	char	wireless_gateway[20];	//	����
	uint16  service_port;			//	�������˿�
	uint16	web_port;				//	web�˿�
	bool	is_open_nat;			//	NAT��͸
} CONFIG_NET, *P_CONFIG_NET;

//	DDNS
typedef struct _CONFIG_DDNS 
{
	bool	enable;			//	�Ƿ���DDNS
	char	service[50];	//	������(��www.3322.org/dyndns.com)
	char	url[50];		//	����
	char	user_name[260];	//	�û���
	char	password[260];	//	����
} CONFIG_DDNS, *P_CONFIG_DDNS;

//	PPPOE
typedef struct _CONFIG_PPPOE 
{
	bool	is_open_pppoe;	//	����PPPOE����
	char	user_name[260];	//	�ʺ�
	char	password[260];	//	����
	char	mode[20];		//	���ŷ�ʽ
} CONFIG_PPPOE, *P_CONFIG_PPPOE;

//	upnp����
typedef struct _CONFIG_UPNP
{
	int32	upnp_mode;		//	�Զ�ӳ��/�ֶ�ӳ��
	int32	port;			//	ӳ��˿ں�
	char	ip[20];			//	һ�㲻�����ã����ж������IP����ʱ����
} CONFIG_UPNP, *P_CONFIG_UPNP;

//	wifi����
typedef struct _CONFIG_WIFI
{
	int32	network_type;		//	����ģʽ
	int32	auth_mode;			//	��ȫ����
	int32	encry_type;			//	��������
	int32   key_type;
	char	wap_name[260];		//	��������
	char	password[260];		//	��������
} CONFIG_WIFI, *P_CONFIG_WIFI;

//	��Ƶ�����������
typedef struct _CONFIG_VIDEO_ENCODE 
{
	int32		channel;
	bool		enable_main;		//	����������
	bool		enable_smooth_m;	//	����ƽ���䶯
	int32		fix_bit_m;			//	��������0:�̶�������1:�̶�����
	int32		quality_m;			//	��������
	int32		qmax_m;				//	(0-51)
	int32		qmin_m;				//	(0-51)
	int32		bit_rate_m;			//	������С
	int32		width_m;			//	�ֱ���(width_m * height_m)
	int32		height_m;
	int32		framerate_m;		//	֡��(1-25)
	int32		frame_interval_m;	//	֡���(1-120)
	bool		enable_sec;			//	���������
	bool		enable_smooth_s;	//	����ƽ���䶯
	int32		fix_bit_s;			//	��������0:�̶�������1:�̶�����
	int32		quality_s;			//	��������
	int32		qmax_s;				//	(0-51)
	int32		qmin_s;				//	(0-51)
	int32		bit_rate_s;			//	������С
	int32		width_s;			//	�ֱ���(width_s * height_s)
	int32		height_s;
	int32		framerate_s;		//	֡��(1-25)
	int32		frame_interval_s;	//	֡���(1-120)
} CONFIG_VIDEO_ENCODE, *P_CONFIG_VIDEO_ENCODE;

//	��Ƶ��������
typedef struct _CONFIG_AUDIO_ENCODE
{
	int32	channel;
	bool	enable;				//	������Ƶ
	bool	enable_vbr;			//	�Ƿ����ɱ������
	bool	enable_denoise;		//	�Ƿ�����������
	real64	volume;				//	����
	int32	audio_channel;		//	ͨ��
	int32	sample;				//	������(8K/16K)
	int32	format;				//	�����ʽ(speex/pcm)
	int32	quality;			//	��������(0-10)
	int32	audio_input;		//	��Ƶ����Դ
	int32	bit_mode;
} CONFIG_AUDIO_ENCODE, *P_CONFIG_AUDIO_ENCODE;

//	OSD���ýṹ(nXPos��nYPosȡֵ0-511)
typedef struct _OSD_STRING 
{
	bool		enable;
	int32		x_pos;
	int32		y_pos;
	char		osd_str[70];	//	���ӵ��ַ������ܹ�������32byte�����Ļ�Ӣ��
} OSD_STRING, *P_OSD_STRING;

typedef struct _OSD_BITRATE 
{
	bool		enable;
	int32		x_pos;
	int32		y_pos;
} OSD_BITRATE, *P_OSD_BITRATE;

typedef struct _OSD_TIME 
{
	bool		enable;
	int32		time_format;	//	ʱ���ʽ 0(YY-MM-DD HH:MM:SS)��1(HH:MM:SS YY-MM-DD)
	int32		x_pos;
	int32		y_pos;
} OSD_TIME, *P_OSD_TIME;

typedef struct _CONFIG_OSD
{
	int32		channel;
	int32		front_color;	//	ǰ��ɫ
	int32		back_color;	
	int32		transp;			//	͸����
	OSD_STRING	osd_string1;
	OSD_STRING	osd_string2;
	OSD_BITRATE	osd_bitrate;
	OSD_TIME	osd_time;
} CONFIG_OSD, *P_CONFIG_OSDG;	

//	��̨��ͼ������
typedef struct _CONFIG_IMAGE_AND_PTZ
{
	int32		channel;
	//	ͼ���������
	int32		brightness;			//	����
	int32		contrast;			//	�Աȶ�
	int32		saturation;			//	���Ͷ�
	int32		flip;				//	ͼ��ת
	int32		effects;			//	ͼ����Ч
	int32		scene;				//	����
	bool		enable_night;		//	�Ƿ�����ҹ��ģʽ
	//	��̨��һЩ����
	char		ptz_protocol[20];	//	��̨Э��			
	int32		baud_rate;		
	int32		addr;
	int32		reverse;
	int32		inout;
	int32		leftright;
	int32		updown;
} CONFIG_IMAGE_AND_PTZ, *P_CONFIG_IMAGE_AND_PTZ;

//	�ƶ������������
typedef struct _MOTION_AREA
{
	bool		enable;
	int32		left_top_x;
	int32		left_top_y;
	int32		right_bottom_x;
	int32		right_bottom_y;
	int32		threshold;
	int32		sensitivity;
} MOTION_AREA, *P_MOTION_AREA;

typedef struct _CONFIG_MOTION_AREA
{
	int32		channel;
	int32		frame_interval;		//	���ʱ����
	int32		sensitivity;		//	���������
	MOTION_AREA	area1;
	MOTION_AREA	area2;
	MOTION_AREA	area3;
} CONFIG_MOTION_AREA, *P_CONFIG_MOTION_AREA;

typedef struct _ARMING_TIME			//	����(GPIO���ƶ���⹲��)
{
	char	start_time[25];			//	��ʼ����ʱ��
	char	end_time[25];			//	��������ʱ��
} ARMING_TIME, *P_ARMING_TIME;

typedef struct _ARMING_WEEK_TIME
{
	int32		week_day;			//	�ܼ�����(���ѡ����û�����)
	ARMING_TIME	arming_time[3];		//	ÿ������3������ʱ��
} ARMING_WEEK_TIME, *P_ARMING_WEEK_TIME;

//	�ƶ����ʱ������
typedef struct _CONFIG_MOTION_TIME
{
	int32		 channel;
	bool		 enable;
	ARMING_WEEK_TIME  time;
} CONFIG_MOTION_TIME, *P_CONFIG_MOTION_TIME;

typedef struct _CONFIG_GPIO_TIME
{
	int32		channel;
	bool		enable;				//	������
	bool		enable_pin;			//	����pin�ź�����
	int32		elect_level;		//	��ƽ ����������
	ARMING_WEEK_TIME	time;
} CONFIG_GPIO_TIME, *P_CONFIG_GPIO_TIME;

//	�������ԣ����á���ȡ��
typedef struct _CONFIG_ALARM_POLICY
{
	bool	enable_video_record;	//	����¼��ʹ��
	uint32	record_time_long;		//	¼��ʱ�䳤��

	bool	enable_capture_image;	//	����ץͼʹ��
	uint32	capture_count;			//	ץ�Ĵ���
	uint32	capture_interval_time;	//	ץ�ļ��ʱ��

	uint32	enable_gpio_out;		//	�����˿����
	uint32	gpio_time_long;			//	���ʱ��
	uint32	elect_level;			//	�����Ƶ�����������գ�
	//	ftp
	bool	enable_ftp;				//	�Ƿ���FTP�ϴ�
	uint32	ftp_start_time;			//	��ʼʱ�䣨0-24Сʱ��
	uint32	ftp_end_time;			//	����ʱ��
	uint16	ftp_port;				//	�˿ں�
	uint32	ftp_connect_mode;		//	����ģʽ��������������
	char	ftp_user_name[260];		//	�û���
	char	ftp_password[260];		//	�û�����
	char	ftp_ip[20];				//	FTP��ַ
	char	ftp_dir[260];			//	FTP�ϴ�Ŀ¼
	//	mail
	bool	enable_email;			//	�Ƿ����ʼ����͹���
	bool	enable_send_cap;		//	�Ƿ���ץͼ���͹���
	bool	enabl_email_auth;		//	�Ƿ���������������֤
	uint16	email_port;				//	�����ʼ��������˿�
	uint32	email_interval;			//	�����ʼ����ʱ��
	char	email_from[50];			//	������
	char	email_to[50];			//	�ռ���
	char	email_user[260];		//	�������û���
	char	email_password[260];	//	����������
	char	email_server[50];		//	�ʼ���������ַ
} CONFIG_ALARM_POLICY, *P_CONFIG_ALARM_POLICY;

//	��ʱ¼������
typedef struct _CONFIG_TIME_RECORD
{
	int32	channel;
	bool	enable;					//	�Ƿ�����ʱ¼��
	bool	audio_record;			//	�Ƿ�¼����Ƶ
	int32	check[7][24*4];			//	��ʱ¼��ʱ���
} CONFIG_TIME_RECORD, *P_CONFIG_TIME_RECORD;

typedef struct _USER_MANGER_INFO
{
	char		user_name[260];		//	�û���
	char		user_password[260];	//	����
	USER_ROLE	user_perm;			//	�û�Ȩ��
} USER_MANGER_INFO, *P_USER_MANGER_INFO;

typedef struct _CONFIG_USER_MANAGER
{
	bool enable;					//	�Ƿ����û���֤
	USER_MANGER_INFO user_info[10];	//	���֧������10���û�
} CONFIG_USER_MANAGER, *P_CONFIG_USER_MANAGER;

//	ʱ������
typedef struct _CONFIG_TIME
{
	int32	time_mode;				//	ʱ�����÷�ʽ��1 �ֶ����ã�2 NTP��
	char	ntp_server[50];			//	NTP������
	char	cur_time[25];			//	��ǰʱ��
	char	time_zone[20];			//	ʱ������
} CONFIG_TIME, *P_CONFIG_TIME;

//	sd������
typedef struct _STORAGE_INFO
{
	uint64		total;				//	������
	uint64		free;				//	ʣ������
} STORAGE_INFO, *P_STORAGE_INFO;

//	��ȡԤ��λ���Զ�Ѳ������Ϣ
typedef struct _PREPOINT_INFO
{
	char	prepoint[64][260];		//	Ԥ��λ
	uint32	cruise[4][16];			//	�Զ�Ѳ�����õ�
	uint32	cruise_interval[4];		//	Ѳ��ʱ����
	bool	curise_status;
} PREPOINT_INFO, *P_PREPOINT_INFO;

typedef struct _LOGIN_SERVER_INFO
{
	cpchar ip;						//	ƽ̨��ַ
	uint16 port;					//	ƽ̨�˿�
	cpchar user;					//	�û���
	cpchar password;				//	����
	cpchar plat_type;				//	ϵͳ���ͣ�pc��android��ios��
	cpchar hard_ver;				//	Ӳ���汾��PC��CPU�ͺţ��ֻ�ƽ̨���ֻ��ͺţ�
	cpchar soft_ver;				//	����汾����v1.0.0.1001��
	uint32 keep_time;				//	���ӱ���ʱ��
} LOGIN_SERVER_INFO, *P_LOGIN_SERVER_INFO;

typedef struct _USER_INFO
{
	int32	id;
	cpchar	name;
	cpchar	nick_name;
	cpchar	tel;
	cpchar	mobile;
	cpchar	address;
	cpchar	reg_date;
	cpchar	last_login_date;
	cpchar  email;
	bool	email_valid;
	int32	actor;
	cpchar  role1;
	cpchar  role2;
	bool	use_alarm_service;
	int32	use_transfer_service;
} USER_INFO, *P_USER_INFO;

typedef struct _UPDATE_INFO
{
	char	pack_name[256];
	char	pack_ver[20];
	int32	importance;
	int32	pack_type;
	bool	force_update;
	char	release_date[20];
	char	release_notes[256];
	char	license[256];
	char	message[256];
	struct FILES
	{
		char file_name[256];
		char download_path[256];
	}* files;
	int32	file_count;
} UPDATE_INFO, *P_UPDATE_INFO;

typedef struct _CHANNEL_INFO
{
	int32	index;
	cpchar	name;
} CHANNEL_INFO, *P_CHANNEL_INFO;

typedef struct _BITMAP_INFO_HEADER
{
	uint32	biSize;
	int32	biWidth;
	int32	biHeight;
	uint16	biPlanes;
	uint16	biBitCount;
	uint32	biCompression;
	uint32	biSizeImage;
	uint32	biXPelsPerMeter;
	uint32	biYPelsPerMeter;
	uint32	biClrUsed;
	uint32	biClrImportant;
} BITMAP_INFO_HEADER, *P_BITMAP_INFO_HEADER;

typedef struct _BITMAP_INFO_HEADER_EX
{
	BITMAP_INFO_HEADER bih;
	uint32 mask[3];
} BITMAP_INFO_HEADER_EX, *P_BITMAP_INFO_HEADER_EX;

typedef struct YUV_PICTURE
{
	uint32	width;		//	ͼ����
	uint32	height;		//	ͼ��߶�
	uint32	ystripe;	//	Yͨ��ÿɨ���е����ݿ�ȣ��ֽڵ�λ
	uint32	ustripe;	//	Uͨ��ÿɨ���е����ݿ�ȣ��ֽڵ�λ
	uint32	vstripe;	//	Vͨ��ÿɨ���е����ݿ�ȣ��ֽڵ�λ
	uint8*	ydata;		//	Yͨ������
	uint8*	udata;		//	Uͨ������
	uint8*	vdata;		//	Vͨ������
} YUV_PICTURE, *P_YUV_PICTURE;

typedef struct DISPLAY_OPTION
{
	DISPLAY_MODE dm;
	PIC_QUALITY  pq;
} DISPLAY_OPTION, *P_DISPLAY_OPTION;

typedef struct _RAW_FRAME
{
	RAW_FRAME_TYPE	type;		//	����֡����
	uint32			time_stamp;	//	ʱ���
	uint32			len;		//	����֡����
	uint8*			buf;		//	֡����
	bool			hold;		//	����֡����ӵ�е����ݿ�
} RAW_FRAME, *P_RAW_FRAME;

typedef struct _LOCAL_RECORD_PARAM
{
	char 			file_name[260];		//	¼��·�����ļ���
	uint32			ver;				//	¼�����汾��
	uint32			subver;				//	¼��ΰ汾��
	uint64			time_cost;			//	¼��ʱ��
	VIDEO_ENCODE	video_fmt;
	uint32 			video_fps;
	uint32 			video_width;		//	��Ƶ��
	uint32			video_height;		//	��Ƶ��
	AUDIO_ENCODE	audio_fmt;
	uint32			audio_channel;
	uint32			audio_sample;
	char			device_sn[68];		//	�豸sn
	char			device_name[68];	//	�豸��
	VIDEO_RECORD	record_type;
} LOCAL_RECORD_PARAM, *P_LOCAL_RECORD_PARAM;

typedef struct _LAN_DEVICE_SEARCH_RES
{
	uint16	port;
	char 	ip_addr[32];
	uint32	channel_count;
	int32	ip_status;
	uint32	update_status;
	char	device_name[64];
	char	device_type[64];
	char	device_sn[64];
	char	mac_addr[20];
	char	wifi_mac_addr[20];
	char	lot[40];
	char	version[40];
	char	murl_addr[40];
	char 	upnp_status[40];
	char	channel_name[260];
	char	device_key[64];
	char 	ip_real_addr[32];
} LAN_DEVICE_SEARCH_RES, *P_LAN_DEVICE_SEARCH_RES;

typedef struct _LAN_DEVICE_RESET_IP
{
	cpchar	device_sn;
	cpchar	conflict_ip;
	cpchar	expect_ip;
	cpchar	expect_mask;
	cpchar	expect_gateway;
} LAN_DEVICE_RESET_IP, *P_LAN_DEVICE_RESET_IP;

typedef void (hm_call * cb_util_lan_device_search) (user_data data, LAN_DEVICE_SEARCH_RES ldsr, hm_result result);
typedef struct _LAN_DEVICE_SEARCH_PARAM_INL
{
	LAN_SEARCH_MODE  search_mode;
	cpchar	host_ip;
	cpchar	host_mask;
	cpchar	host_gateway;
	uint32	auto_search_interval; 
	cb_util_lan_device_search  cb_search;
	user_data data;
} LAN_DEVICE_SEARCH_PARAM, *P_LAN_DEVICE_SEARCH_PARAM;

typedef struct _LAN_CONFIG_SN_INFO
{
	cpchar	device_ip;
	cpchar	device_mac;
	cpchar	device_wifimac;
	cpchar	device_sn;
} LAN_CONFIG_SN_INFO, *P_LAN_CONFIG_SN_INFO;

typedef struct _LAN_CONFIG_LOT_INFO
{
	cpchar	device_ip;
	cpchar	device_mac;
	cpchar	device_wifimac;
	cpchar	lot;
} LAN_CONFIG_LOT_INFO, *P_LAN_CONFIG_LOT_INFO;

typedef struct _LAN_CONFIG_UPDATE_INFO
{
	cpchar	device_ip;
	cpchar	device_mac;
	cpchar	device_wifimac;
	UPDATE_TYPE	update_type;
	cpchar	update_url;
	cpchar	update_md5;
} LAN_CONFIG_UPDATE_INFO, *P_LAN_CONFIG_UPDATE_INFO;

typedef struct _TOKEN_INFO
{
	cpchar	push_addr;
	uint16	port;
	cpchar	usrname;
	int32	device_type;
	cpchar	device_token;
	int32	for_all;
	int32	status;
	cpchar	time_stamp;
	cpchar	start_time;
	cpchar	end_time;
	cpchar	sn;
	cpchar	key;
	cpchar	sound;
} TOKEN_INFO, *P_TOKEN_INFO;

//	������Ϣ
typedef struct _PUSH_MSG
{
	char	alert[211];
	char	sn[14];
	uint32	channel;
	pchar	rsv;
} PUSH_MSG, *P_PUSH_MSG;

//	������ʷ��Ϣ
typedef struct _ALARM_HISTORY_INFO
{
	char	m_id[50];
	char	m_image_url[512];
	char	m_content[1024];
	char	m_sn[14];
	char	m_devname[128];
	int32	m_state;
	char	m_date[20];
} ALARM_HISTORY_INFO, *P_ALARM_HISTORY_INFO;

//	ϵͳ֪ͨ��Ϣ
typedef struct _SYS_NOTI_INFO
{
	char	m_id[50];
	char	m_content[1024];
	char	m_title[512];
	char	m_date[20];
} SYS_NOTI_INFO, *P_SYS_NOTI_INFO;

//	�ط�����
typedef struct _PLAYBACK_FRAME
{
	int32	ftype;	//	֡����
	int32	flen;	//	֡����
	uint64	fstamp;	//	ʱ���
	pchar	buf;	//	֡���ݣ�����Ȩ��ʹ����
	bool	disp;	//	�Ƿ���ʾ
} PLAYBACK_FRAME, *P_PLAYBACK_FRAME;

//	��ѯ������Ϣ
typedef struct _QUERY_UPDATE_INFO
{
	int32	code;			//	��Ȩ��֤�����0-��������, 1-��Ҫ����, 2-����ʧ��
	int32	force_update;	//	ǿ�������̼���0-��, 1-��
	char	desc[128];
	char	time_stamp[25];
	char	hash[128];
	struct FIRMWARE
	{
		char	name[256];
		char	version[128];
		char	devclass[128];
		char	hash[128];
		char	url[128];
		char	release_time[25];
		char	release_note[1024];
	} firmware;
} QUERY_UPDATE_INFO, *P_QUERY_UPDATE_INFO;

//	��ѯ��������
typedef struct _QUERY_UPDATE_PROG
{
	int32	status;
	int32	prog;
	int32	err;
} QUERY_UPDATE_PROG, *P_QUERY_UPDATE_PROG;

//	�豸��Ϣ����������Ϣ��
typedef struct _DEVICE_INFO_NEW
{
	cpchar	id;
	cpchar	sn;
	cpchar	dev_name;
	cpchar	uri;
	cpchar	e_uri;
	cpchar	last_update;
	int32	media_type;
	cpchar	channel;
	bool	is_online;
	int32	share;
	int32	upgrade;
	cpchar	model;
	cpchar	hardware;
	cpchar	software;
	cpchar	login_key;
	cpchar	image_url;
	cpchar	desc;
	struct _TAGS
	{
		cpchar tag;
	}* p_tags[1024];
	int32	tag_count;
} DEVICE_INFO_NEW, *P_DEVICE_INFO_NEW;

typedef struct _DEVICE_SHARE
{
	char	id[128];
	char	tag[1024];
	char	desc[1024];
} DEVICE_SHARE, *P_DEVICE_SHARE;

typedef struct _PUSH_ALARM_INFO
{
	char	id[128];
	char	image_url[512];
	char	cont[1024];
	char	sn[14];
	char	dev_name[128];
	int32	state;
	char	data_time[64];
} PUSH_ALARM_INFO, *P_PUSH_ALARM_INFO;

typedef struct _CONNECT_INFO
{
	CLIENT_TYPE ct;		//	�ͻ�������
	CONNECT_PRI cp;		//	�������ȼ�
	int32 cm;			//	����ģʽ��CONNECT_MODE��
} CONNECT_INFO, *P_CONNECT_INFO;


// ��ת��͸��Ϣ
typedef struct _TRANSFER_INFO
{
	cpchar				nat_server_1;
	int32				nat_server_port1;
	cpchar				nat_server_2;
	int32				nat_server_port2;
	cpchar				relay_server;
	int32				relay_port;
} TRANSFER_INFO,*P_TRANSFER_INFO;

#pragma pack(pop)

typedef void (hm_call * cb_pu_dev_connect)		(user_data data, user_id* uid, cpchar sn);
typedef void (hm_call * cb_audio_capture)		(user_data data, hm_result result, pointer buf, int32 len);
typedef void (hm_call * cb_util_playback)		(user_data data, P_PLAYBACK_FRAME frame);
typedef void (hm_call * cb_util_push_service)	(user_data data, hm_result result, P_PUSH_MSG msg);

#define HMCAPI
#ifdef __cplusplus
extern "C" {
#endif

/************************************************************************************************/
/*										��ʼ��SDK												*/
/************************************************************************************************/
HMCAPI hm_result hm_sdk_init();
HMCAPI hm_result hm_sdk_uninit();

/************************************************************************************************/
/*										�豸��ؽӿ�												*/
/************************************************************************************************/
//	��¼/�ǳ��豸
HMCAPI hm_result hm_pu_login(cpchar ip, uint16 port, cpchar sn, cpchar user, cpchar pwd, CLIENT_TYPE ct, user_id* id);
HMCAPI hm_result hm_pu_login_ex(node_handle handle, P_CONNECT_INFO ci, user_id* id);

//����hm_pu_login_ex_new�ӿ�
//device_info�õ�4���ֶ�:uri,e_uri,sn,login_key;
//transfer_info�õ������ֶ�
HMCAPI hm_result hm_pu_login_ex_new(P_DEVICE_INFO_NEW device_info,P_TRANSFER_INFO transfer_info, P_CONNECT_INFO ci, user_id* id);
HMCAPI hm_result hm_pu_login_flow_stat(node_handle handle, cpchar url, cpchar user, CLIENT_TYPE ct, user_id* id);
HMCAPI hm_result hm_pu_set_net_cb(user_id id, cb_pu_net cb, user_data data);
HMCAPI hm_result hm_pu_logout(user_id id);
HMCAPI hm_result hm_pu_get_device_info(user_id id, P_DEVICE_INFO device);

//	��������
HMCAPI hm_result hm_pu_listen_init(listen_handle* lh);
HMCAPI hm_result hm_pu_listen_set_user_info(listen_handle lh, cpchar* usr, cpchar* pwd, int32 count);
HMCAPI hm_result hm_pu_listen_set_callback(listen_handle lh, cb_pu_dev_connect cb, user_data data);
HMCAPI hm_result hm_pu_listen_open(listen_handle lh, cpchar ip, uint16 port);
HMCAPI hm_result hm_pu_listen_close(listen_handle lh);
HMCAPI hm_result hm_pu_listen_uninit(listen_handle lh);

//	��Ƶ
HMCAPI hm_result hm_pu_open_video(user_id id, P_OPEN_VIDEO_PARAM param, video_handle* handle);
HMCAPI hm_result hm_pu_start_video(video_handle handle, P_OPEN_VIDEO_RES res);
HMCAPI hm_result hm_pu_force_iframe(video_handle handle);
HMCAPI hm_result hm_pu_stop_video(video_handle handle);
HMCAPI hm_result hm_pu_close_video(video_handle handle);

//	��Ƶ
HMCAPI hm_result hm_pu_open_audio(user_id id, P_OPEN_AUDIO_PARAM param, P_OPEN_AUDIO_RES res, audio_handle* handle);
HMCAPI hm_result hm_pu_start_audio(audio_handle handle);
HMCAPI hm_result hm_pu_stop_audio(audio_handle handle);
HMCAPI hm_result hm_pu_close_audio(audio_handle handle);

//	�Խ�
HMCAPI hm_result hm_pu_open_talk(user_id id, P_OPEN_TALK_PARAM param, talk_handle* handle);
HMCAPI hm_result hm_pu_open_talk2(user_id id, P_OPEN_TALK_PARAM param, P_OPEN_TALK_RESP resp, talk_handle* handle);
HMCAPI hm_result hm_pu_send_talk_data(talk_handle handle, P_FRAME_DATA frame);
HMCAPI hm_result hm_pu_start_talk(talk_handle handle);
HMCAPI hm_result hm_pu_stop_talk(talk_handle handle);
HMCAPI hm_result hm_pu_close_talk(talk_handle handle);

//	��̨
HMCAPI hm_result hm_pu_ptz_control(user_id id, uint32 channel, PTZ_COMMAND ptz_cmd, int32 speed);
HMCAPI hm_result hm_pu_ptz_focus_up(user_id id, uint32 channel, int32 speed);
HMCAPI hm_result hm_pu_ptz_focus_down(user_id id, uint32 channel, int32 speed);
HMCAPI hm_result hm_pu_ptz_set_preset(user_id id, uint32 channel, uint8 index, cpchar preset_name);
HMCAPI hm_result hm_pu_ptz_clr_preset(user_id id, uint32 channel, uint8 index);
HMCAPI hm_result hm_pu_ptz_goto_preset(user_id id, uint32 channel, uint8 index);
HMCAPI hm_result hm_pu_ptz_cruise(user_id id, PTZ_INTERVAL type, uint32 channel, int32 speed);

//	����
HMCAPI hm_result hm_pu_open_alarm(user_id id, P_OPEN_ALARM_PARAM param, alarm_handle* handle);
HMCAPI hm_result hm_pu_start_alarm(alarm_handle handle);
HMCAPI hm_result hm_pu_stop_alarm(alarm_handle handle);
HMCAPI hm_result hm_pu_close_alarm(alarm_handle handle);

//	������������
HMCAPI hm_result hm_pu_enable_alarm_sound(user_id id);
HMCAPI hm_result hm_pu_disable_alarm_sound(user_id id);
HMCAPI hm_result hm_pu_get_alarm_sound_status(user_id id, int32* status);

//	��ȡ����״̬
HMCAPI hm_result hm_pu_get_arming_state(user_id id, bool* state);

//  �����ͳ���
HMCAPI hm_result hm_pu_arming_area(user_id id, int32 area_id, cpchar expand);
HMCAPI hm_result hm_pu_disarming_area(user_id id, int32 area_id, cpchar expand);

//	��������
HMCAPI hm_result hm_pu_add_area(user_id id, P_AREA_INFO_PARAM param);
HMCAPI hm_result hm_pu_change_area(user_id id, P_AREA_INFO_PARAM param);
HMCAPI hm_result hm_pu_delete_area(user_id id, P_AREA_INFO_PARAM param);

//	����������
HMCAPI hm_result hm_pu_add_sensor(user_id id, P_SENSOR_INFO_PARAM param);
HMCAPI hm_result hm_pu_change_sensor(user_id id, P_SENSOR_INFO_PARAM param);
HMCAPI hm_result hm_pu_delete_sensor(user_id id, P_SENSOR_INFO_PARAM param);

//	��������ѧϰ
HMCAPI hm_result hm_pu_open_alarm_host(user_id id, cb_pu_alarm cb_alarm, alarm_host_handle* handle);
HMCAPI hm_result hm_pu_start_learn(alarm_host_handle handle);
HMCAPI hm_result hm_pu_stop_learn(alarm_host_handle handle);
HMCAPI hm_result hm_pu_close_alarm_host(alarm_host_handle handle);

//	�����������
HMCAPI hm_result hm_pu_get_match_sensor(user_id user, P_MATCH_SENSOR_RES res);

//	¼����ط�
HMCAPI hm_result hm_pu_open_record(user_id id, int32 chn, record_handle* handle);
HMCAPI hm_result hm_pu_start_record(record_handle handle, uint32 channel);
HMCAPI hm_result hm_pu_stop_record(record_handle handle, uint32 channel);
HMCAPI hm_result hm_pu_close_record(record_handle handle);
HMCAPI hm_result hm_pu_find_file(user_id id, P_FIND_FILE_PARAM param, find_file_handle* handle);
HMCAPI hm_result hm_pu_find_next_file(find_file_handle handle, P_FIND_FILE_DATA data);
HMCAPI hm_result hm_pu_close_find_file(find_file_handle handle);
HMCAPI hm_result hm_pu_delete_record_file(user_id id, P_DELETE_RECORD_FILE_PARAM param);
HMCAPI hm_result hm_pu_open_playback(user_id id, P_PLAYBACK_PARAM param, P_PLAYBACK_RES res, playback_handle* handle);
HMCAPI hm_result hm_pu_start_playback(playback_handle handle);
HMCAPI hm_result hm_pu_stop_playback(playback_handle handle);
HMCAPI hm_result hm_pu_pause_playback(playback_handle handle);
HMCAPI hm_result hm_pu_resume_playback(playback_handle handle);
HMCAPI hm_result hm_pu_step_playback(playback_handle handle);
HMCAPI hm_result hm_pu_close_playback(playback_handle handle);

//	��Ƶ��ͼƬ����
HMCAPI hm_result hm_pu_open_get_file(user_id id, P_GET_FILE_PARAM param, P_GET_FILE_RES res, get_file_handle* handle);
HMCAPI hm_result hm_pu_start_get_file(get_file_handle handle);
HMCAPI hm_result hm_pu_cancel_get_file(get_file_handle handle);
HMCAPI hm_result hm_pu_close_get_file(get_file_handle handle);
HMCAPI hm_result hm_pu_find_picture(user_id id, P_FIND_PICTURE_PARAM param, find_picture_handle* handle);
HMCAPI hm_result hm_pu_find_next_picture(find_picture_handle handle, P_FIND_PICTURE_DATA data);
HMCAPI hm_result hm_pu_close_find_picture(find_picture_handle handle);
HMCAPI hm_result hm_pu_delete_picture(user_id id, P_DELETE_PICTURE_PARAM param);
HMCAPI hm_result hm_pu_open_get_picture(user_id id, P_GET_PICTURE_PARAM param, P_GET_PICTURE_RES res, get_picture_handle* handle);
HMCAPI hm_result hm_pu_start_get_picture(get_picture_handle handle);
HMCAPI hm_result hm_pu_cancel_get_picture(get_picture_handle handle);
HMCAPI hm_result hm_pu_close_get_picture(get_picture_handle handle);

//	ץͼ
HMCAPI hm_result hm_pu_remote_capture_pic(user_id id, P_REMOTE_CAPTURE_PIC_PARAM param);

//  ����
HMCAPI hm_result hm_pu_open_upgrade(user_id id, P_HARD_UPDATE_PARAM param, upgrade_handle* handle);
HMCAPI hm_result hm_pu_start_upgrade(upgrade_handle handle);
HMCAPI hm_result hm_pu_send_upgrade_data(upgrade_handle handle, uint32 len, cpointer buf);
HMCAPI hm_result hm_pu_cancel_upgrade(upgrade_handle handle);
HMCAPI hm_result hm_pu_close_upgrade(upgrade_handle handle);
HMCAPI hm_result hm_pu_get_online_user(user_id id, get_online_user_handle* handle);
HMCAPI hm_result hm_pu_get_next_online_user(get_online_user_handle handle, P_ONLINE_USER_DATA data);
HMCAPI hm_result hm_pu_close_get_online_user(get_online_user_handle handle);
HMCAPI hm_result hm_pu_set_wifi_config(user_id user, P_CONFIG_WIFI config);
HMCAPI hm_result hm_pu_get_wifi_config(user_id user, P_CONFIG_WIFI config);
HMCAPI hm_result hm_pu_lock_device(user_id user, uint32 lock);
HMCAPI hm_result hm_pu_protect_privacy(user_id user, DEV_PRIVACY prot);

//  ����
HMCAPI hm_result hm_pu_reboot(user_id id);
HMCAPI hm_result hm_pu_open_search_wifi(user_id id, P_QUERY_WIFI_PARAM param, search_wifi_handle* handle);
HMCAPI hm_result hm_pu_set_wifi_callback(search_wifi_handle handle, cb_pu_wifi cb, user_data data);
HMCAPI hm_result hm_pu_start_search_wifi(search_wifi_handle handle);
HMCAPI hm_result hm_pu_close_search_wifi(search_wifi_handle handle);
HMCAPI hm_result hm_pu_detect_upnp(user_id id, P_DETECT_UPNP upnp);
HMCAPI hm_result hm_pu_format_sd(user_id id, uint8* format_result);
HMCAPI hm_result hm_pu_restore_default_config(user_id id, uint8* restore_result);
HMCAPI hm_result hm_pu_get_system_info(user_id id, P_PT_SYSTEM_INFO system_info);
HMCAPI hm_result hm_pu_get_system_info_opt(user_id id, P_PT_SYSTEM_INFO system_info);
HMCAPI hm_result hm_pu_time_sync(user_id id, uint32 time);
HMCAPI hm_result hm_pu_set_normal_config(user_id user, cpchar cfg);
HMCAPI hm_result hm_pu_get_normal_config(user_id user, cpchar cfg, pchar* msg);

//	��ȡ������Ϣ
HMCAPI hm_result hm_pu_get_connect_type(user_id id, int32* ct);

//	PUͨ��Э��
HMCAPI hm_result hm_pu_common_command(user_id id, int32 cmdid, cpchar cmdbody, pchar recv_buf, int32 buf_len);

//	�豸�Զ�����
HMCAPI hm_result hm_pu_query_update_info(user_id id, P_QUERY_UPDATE_INFO ui);
HMCAPI hm_result hm_pu_update_start(user_id id);
HMCAPI hm_result hm_pu_update_stop(user_id id);
HMCAPI hm_result hm_pu_query_update_progress(user_id id, P_QUERY_UPDATE_PROG up);

/************************************************************************************************/
/*										ƽ̨��ؽӿ�												*/
/************************************************************************************************/
//	����ƽ̨
HMCAPI hm_result hm_server_connect(P_LOGIN_SERVER_INFO lsi, server_id* hserver, pchar err, int32 err_len);
// ʹ��ssl�������ӣ���Ҫƽ̨֧��https
HMCAPI hm_result hm_server_ssl_connect(P_LOGIN_SERVER_INFO lsi, server_id* hserver, pchar err, int32 err_len);
HMCAPI hm_result hm_server_disconnect(server_id server);

//	��ȡ���顢�豸�б��û���Ϣ����ת��͸��Ϣ
HMCAPI hm_result hm_server_get_device_list(server_id server);
HMCAPI hm_result hm_server_get_user_info(server_id server, P_USER_INFO* uinfo);
HMCAPI hm_result hm_server_get_transfer_info(server_id server);
HMCAPI hm_result hm_server_get_time(server_id server, uint64* time);
HMCAPI hm_result hm_server_get_channel_info(node_handle channel, P_CHANNEL_INFO* cinfo);
HMCAPI hm_result hm_server_get_node_type(node_handle node, NODE_TYPE_INFO* tinfo);
HMCAPI hm_result hm_server_get_node_id(node_handle device, int32* id);
HMCAPI hm_result hm_server_get_node_guid(node_handle device, cpchar* guid);
HMCAPI hm_result hm_server_get_parent_id(node_handle device, int32* id);
HMCAPI hm_result hm_server_get_device_sn(node_handle device, cpchar* sn);
HMCAPI hm_result hm_server_get_device_url(node_handle device, cpchar* url);
HMCAPI hm_result hm_server_get_device_power(node_handle device, int64* power);
HMCAPI hm_result hm_server_get_device_image_url(node_handle device, cpchar* url);
HMCAPI hm_result hm_server_get_firmware_version(node_handle device, cpchar* ver);
HMCAPI hm_result hm_server_get_device_upgrade(node_handle device, int32* ug);
HMCAPI hm_result hm_server_get_device_description(node_handle device, cpchar* desc);
HMCAPI hm_result hm_server_get_device_policy(node_handle device, int32* policy);
HMCAPI hm_result hm_server_get_node_name(node_handle node, cpchar* name);
HMCAPI hm_result hm_server_get_last_update(node_handle device, uint64* update);
HMCAPI hm_result hm_server_update_device(server_id server, node_handle device);
HMCAPI hm_result hm_server_bind_device(server_id server, cpchar sn, cpchar pwd, int32* device_id);
HMCAPI hm_result hm_server_unbind_device(server_id server, int32 device_id);
HMCAPI hm_result hm_server_modify_device_name(server_id server, int32 device_id, cpchar new_name);
HMCAPI hm_result hm_server_add_group(server_id server, cpchar usrname, cpchar comment, int32 parent_id);
HMCAPI hm_result hm_server_change_device_group(server_id server, int32 device_id, int32 group_id);
HMCAPI hm_result hm_server_is_online(node_handle device, bool* is_online);
HMCAPI hm_result hm_server_get_share_status(node_handle device, int32* share);
HMCAPI hm_result hm_server_get_online_count(node_handle device, int32* online_cnt, int32* total_cnt);
HMCAPI hm_result hm_server_save_token(server_id server, P_TOKEN_INFO pti);
HMCAPI hm_result hm_server_user_exist(cpchar ip, uint16 port, cpchar usrname, bool* exist);
HMCAPI hm_result hm_server_register_user_with_mobile(cpchar ip, uint16 port, cpchar usrname, cpchar password, cpchar mobile, cpchar captcha);
HMCAPI hm_result hm_server_register_user_by_email(cpchar ip, uint16 port, cpchar usrname, cpchar password, cpchar email);
HMCAPI hm_result hm_server_request_mobile_captcha(cpchar ip, uint16 port, cpchar usrname, cpchar mobile);
HMCAPI hm_result hm_server_request_mobile_auth_captcha(cpchar ip, uint16 port, cpchar usrname, cpchar mobile);
HMCAPI hm_result hm_server_reset_password_by_email(cpchar ip, uint16 port, cpchar usrname, cpchar email);
HMCAPI hm_result hm_server_reset_password_by_mobile(cpchar ip, uint16 port, cpchar usrname, cpchar new_password, cpchar mobile, cpchar captcha);
HMCAPI hm_result hm_server_set_privacy(server_id server, cpchar sn, DEV_PRIVACY dp);
HMCAPI hm_result hm_server_get_privacy(server_id, cpchar sn, DEV_PRIVACY* dp);
HMCAPI hm_result hm_server_get_device_privacy_status(node_handle device, DEV_PRIVACY* dp);
HMCAPI hm_result hm_server_get_session_time_left(server_id server, int32* time);
HMCAPI hm_result hm_server_get_version(server_id server, cpchar* ver);
HMCAPI hm_result hm_server_get_update_info(cpchar ip, uint16 port, int32 ctype, cpchar ver, cpchar os, P_UPDATE_INFO pui);
HMCAPI hm_result hm_server_release_update_info(P_UPDATE_INFO pui);
HMCAPI hm_result hm_server_get_alarm_history(server_id server, cpchar start_time, cpchar end_time, int32 index);
HMCAPI hm_result hm_server_get_alarm_history_unread_count(server_id server, int32* count);
HMCAPI hm_result hm_server_mark_all_history_read(server_id server);
HMCAPI hm_result hm_server_mark_history_read(server_id server, cpchar id);
HMCAPI hm_result hm_server_get_alarm_history_count(server_id server, int32* count);
HMCAPI hm_result hm_server_get_alarm_history_at(server_id server, int32 index, P_ALARM_HISTORY_INFO ahi);
HMCAPI hm_result hm_server_get_system_notification_info(server_id server, cpchar start_time, cpchar end_time);
HMCAPI hm_result hm_server_get_system_notification_count(server_id server, int32* count);
HMCAPI hm_result hm_server_get_system_notification_at(server_id server, int32 index, P_SYS_NOTI_INFO sni);
HMCAPI hm_result hm_server_register_user_by_mobile(cpchar ip, uint16 port, cpchar mobile, cpchar nick_name, cpchar password, cpchar captcha);
HMCAPI hm_result hm_server_nick_name_exists(cpchar ip, uint16 port, cpchar nick_name, bool* exist);
HMCAPI hm_result hm_server_upgrade_user_name(server_id server, cpchar user_name, cpchar captcha);
HMCAPI hm_result hm_server_get_live_device_list(cpchar ip, uint16 port, int32 idx, cpchar tags, bool isOnline, get_handle* handle);
HMCAPI hm_result hm_server_get_live_device_count(get_handle handle, int32* count);
HMCAPI hm_result hm_server_get_live_device_at(get_handle handle, int32 idx, P_DEVICE_INFO_NEW din);
HMCAPI hm_result hm_server_get_live_device_share_status(server_id server, cpchar id, int32* share);
HMCAPI hm_result hm_server_release_get_handle(get_handle handle);
HMCAPI hm_result hm_server_cancel_live_device_share(server_id server, cpchar ids);
HMCAPI hm_result hm_server_update_live_device_share(server_id server, P_DEVICE_SHARE ds, int32 len);
HMCAPI hm_result hm_server_set_live_device(server_id server, P_DEVICE_SHARE ds, int32 len);
HMCAPI hm_result hm_server_feedback(server_id server, cpchar cont, cpchar phone_num, cpchar qq_num);
HMCAPI hm_result hm_server_get_alarm_info(server_id server, cpchar aid, P_PUSH_ALARM_INFO pai);
HMCAPI hm_result hm_server_delete_alarm_history(server_id server, cpchar aid);
HMCAPI hm_result hm_server_get_last_error_describe(server_id server, cpchar* err);

//	�û�ע�ᡢ�����޸�
HMCAPI hm_result hm_server_register_user(cpchar ip, uint16 port, cpchar usrname, cpchar pwd);
HMCAPI hm_result hm_server_modify_password(server_id server, cpchar old_pwd, cpchar new_pwd);

//	�豸������
HMCAPI hm_result hm_server_get_tree(server_id server, tree_handle* htree);
HMCAPI hm_result hm_server_get_root(tree_handle tree, node_handle* node);
HMCAPI hm_result hm_server_find_group_by_id(tree_handle tree, int32 id, node_handle* node);
HMCAPI hm_result hm_server_find_device_by_id(tree_handle tree, int32 id, node_handle* node);
HMCAPI hm_result hm_server_find_device_by_sn(tree_handle tree, cpchar sn, node_handle* node);
HMCAPI hm_result hm_server_release_tree(tree_handle tree);
HMCAPI hm_result hm_server_sort_in_node(tree_handle tree, node_handle node, int32 sm);
HMCAPI hm_result hm_server_filter_in_node(tree_handle tree, node_handle node, cpchar keywords);
HMCAPI hm_result hm_server_get_all_device_count(tree_handle tree, int32* count);
HMCAPI hm_result hm_server_get_all_device_at(tree_handle tree, int32 index, node_handle* node);
HMCAPI hm_result hm_server_get_children_count(node_handle device, int32* count);
HMCAPI hm_result hm_server_get_child_at(node_handle device, int32 index, node_handle* node);
HMCAPI hm_result hm_server_get_parent(node_handle device, node_handle* node);

//	ͨ�ýӿڣ�respָ��ʹ����Ϻ������ hm_mem_free �ͷţ�
HMCAPI hm_result hm_server_common_command(server_id server, cpchar method, cpchar cmd, pchar* resp, int32* len);

/************************************************************************************************/
/*									�������ؽӿ�												*/
/************************************************************************************************/
//	��Ƶ��/����
HMCAPI hm_result hm_audio_init(AUDIO_ENCODE type, audio_codec_handle* haudio);
HMCAPI hm_result hm_audio_decode(audio_codec_handle handle,
								 pointer des, int32* des_len,
								 pointer src, int32 src_len, int32 sample);
HMCAPI hm_result hm_audio_encode(audio_codec_handle handle,
								 pointer des, int32* des_len,
								 pointer src, int32 src_len, int32 sample);
HMCAPI hm_result hm_audio_uninit(audio_codec_handle handle);

//	��Ƶ�ɼ��ӿڽ�֧��Windowsƽ̨
HMCAPI hm_result hm_audio_capture_init(audio_capture_handle* handle);
HMCAPI hm_result hm_audio_capture_set_callback(audio_capture_handle handle, cb_audio_capture cb, user_data data);
HMCAPI hm_result hm_audio_capture_start(audio_capture_handle handle);
HMCAPI hm_result hm_audio_capture_stop(audio_capture_handle handle);
HMCAPI hm_result hm_audio_capture_uninit(audio_capture_handle handle);

//	��Ƶ���Žӿڽ�֧��Windowsƽ̨
HMCAPI hm_result hm_audio_player_init(audio_player_handle* handle,
												  window_handle wnd,
												  AUDIO_ENCODE audio_type, int32 sample /*= 8000*/, int32 chn_num /*= 1*/, int32 bitwidth /*= 16*/);
HMCAPI hm_result hm_audio_player_start(audio_player_handle handle);
HMCAPI hm_result hm_audio_player_stop(audio_player_handle handle);
HMCAPI hm_result hm_audio_player_insert_frame(audio_player_handle handle, cpchar buf, int32 len);
HMCAPI hm_result hm_audio_player_uninit(audio_player_handle handle);

//	��Ƶ����
HMCAPI hm_result hm_video_init(int32 type, video_codec_handle* hvideo);
HMCAPI hm_result hm_video_decode_yuv(video_codec_handle handle, pointer video_data, int32 video_len, yuv_handle* yuv);
HMCAPI hm_result hm_video_decode_bitmap(video_codec_handle handle, pointer video_data, int32 video_len, BITMAP_FORMAT bf, bitmap_handle* bmp);
HMCAPI hm_result hm_video_encode_yuv420(video_codec_handle handle, cpointer dst, int32* dst_len, pointer src, int32 src_len, int32 width, int32 height, int32 bit_rate);
HMCAPI hm_result hm_video_release_yuv(yuv_handle handle);
HMCAPI hm_result hm_video_release_bitmap(bitmap_handle handle);
HMCAPI hm_result hm_video_yuv_2_rgb(yuv_handle handle, BITMAP_FORMAT bf, bitmap_handle* bmp);
HMCAPI hm_result hm_video_get_yuv_data(yuv_handle handle, P_YUV_PICTURE yuv_pic);
HMCAPI hm_result hm_video_get_bitmap_data(bitmap_handle handle, uint32* len, cpchar* data);
HMCAPI hm_result hm_video_get_bitmap_file_data(bitmap_handle handle, uint32* len, cpchar* data);
HMCAPI hm_result hm_video_get_bitmap_info(bitmap_handle handle, P_BITMAP_INFO_HEADER* hinfo);
HMCAPI hm_result hm_video_uninit(video_codec_handle handle);

/************************************************************************************************/
/*									��Ƶ��ʾ��ؽӿ�												*/
/************************************************************************************************/
//	��Ƶ��ʾ���ӿڲ�����������Դ��ֻ������ʾ��
HMCAPI hm_result hm_video_display_open_port(window_handle hwnd, P_DISPLAY_OPTION disp_option, port_handle* port);
HMCAPI hm_result hm_video_display_start(port_handle port, int32 vw /*= 0*/, int32 vh /*= 0*/, int32 fps /*= 25*/);
HMCAPI hm_result hm_video_display_input_data(port_handle port, cpointer video_data, int32 len, bool bDisp /*= true*/);
HMCAPI hm_result hm_video_display_stop(port_handle port);
HMCAPI hm_result hm_video_display_get_buffer_size(port_handle port, int32* size);
HMCAPI hm_result hm_video_display_capture(port_handle port, cpchar path, BITMAP_FORMAT bf);
HMCAPI hm_result hm_video_display_close_port(port_handle port);

/************************************************************************************************/
/*									�ڴ��ͷ���ؽӿ�												*/
/************************************************************************************************/
//	�ڴ��ͷ�
HMCAPI hm_result hm_mem_free(pointer p);

/************************************************************************************************/
/*							������Ƶ¼��/�ط�/ץͼ��ؽӿ�										*/
/************************************************************************************************/
//	����¼��
HMCAPI hm_result hm_util_local_record_init(P_LOCAL_RECORD_PARAM param, local_record_handle* hrecord);
HMCAPI hm_result hm_util_local_record_write(local_record_handle handle, P_FRAME_DATA frame, uint32* time_cost);
HMCAPI hm_result hm_util_local_record_uninit(local_record_handle hrecord);

//	���ػطţ���������ģʽ��
HMCAPI hm_result hm_util_local_playback_init(P_LOCAL_RECORD_PARAM param, local_playback_handle* hplayback, PB_MODE pbm);
HMCAPI hm_result hm_util_local_playback_get_one_frame(local_playback_handle hplayback, P_PLAYBACK_FRAME frame);
HMCAPI hm_result hm_util_local_playback_set_callback(local_playback_handle hplayback, cb_util_playback cb, user_data data);
HMCAPI hm_result hm_util_local_playback_start(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_stop(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_pause(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_resume(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_get_rate(local_playback_handle hplayback, PLAYBACK_RATE* rate);
HMCAPI hm_result hm_util_local_playback_set_rate(local_playback_handle hplayback, PLAYBACK_RATE rate);
HMCAPI hm_result hm_util_local_playback_get_position(local_playback_handle hplayback, real64* pos);
HMCAPI hm_result hm_util_local_playback_set_position(local_playback_handle hplayback, real64 pos);
HMCAPI hm_result hm_util_local_playback_step_forward(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_step_backward(local_playback_handle hplayback);
HMCAPI hm_result hm_util_local_playback_uninit(local_playback_handle hplayback);

//	����ץͼ
HMCAPI hm_result hm_util_local_capture(cpchar path, yuv_handle handle, BITMAP_FORMAT bf);

/************************************************************************************************/
/*							�������豸������ؽӿ�												*/
/************************************************************************************************/
HMCAPI hm_result hm_util_lan_device_search_init(P_LAN_DEVICE_SEARCH_PARAM param, lan_device_search_handle* handle);
HMCAPI hm_result hm_util_lan_device_search_query(lan_device_search_handle handle);
HMCAPI hm_result hm_util_lan_device_search_reset_ip(lan_device_search_handle handle, P_LAN_DEVICE_RESET_IP param);
HMCAPI hm_result hm_util_lan_device_search_config_sn(lan_device_search_handle handle, P_LAN_CONFIG_SN_INFO sn);
HMCAPI hm_result hm_util_lan_device_search_config_update(lan_device_search_handle handle, P_LAN_CONFIG_UPDATE_INFO info);
HMCAPI hm_result hm_util_lan_device_search_config_lot(lan_device_search_handle handle, P_LAN_CONFIG_LOT_INFO lot);
HMCAPI hm_result hm_util_lan_device_search_uninit(lan_device_search_handle handle);

/************************************************************************************************/
/*							������ؽӿڣ�����׿ƽ̨��											*/
/************************************************************************************************/
HMCAPI hm_result hm_util_push_service_init(cpchar addr, uint16 port, cpchar token, push_service_handle* handle);
HMCAPI hm_result hm_util_push_service_start(push_service_handle handle);
HMCAPI hm_result hm_util_push_service_set_callback(push_service_handle handle, cb_util_push_service cb, user_data data);
HMCAPI hm_result hm_util_push_service_stop(push_service_handle handle);
HMCAPI hm_result hm_util_push_service_uninit(push_service_handle handle);
    
// FOR iOS API.
HMCAPI hm_result hm_gl_init();
HMCAPI hm_result hm_gl_uninit();
HMCAPI hm_result hm_gl_render();
HMCAPI hm_result hm_gl_resize(int width, int height);
HMCAPI hm_result hm_gl_set_frame_buffer(char* ydata, char* udata, char* vdata, int ystripe, int ustripe, int vstripe, int width, int height);
    
#ifdef __cplusplus
}
#endif

#endif	//	__HM_SDK_H__
