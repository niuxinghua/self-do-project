//
//  BlueToothManager.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BlueToothManager.h"
#import "BabyBluetooth.h"
#import "LockStoreManager.h"
#include "stdio.h"
#include "string.h"
#import "TeaEncryption.h"
#import "Tea.h"
#import "UIView+Toast.h"
#import "Const.h"
#import "PPNetworkHelper.h"
#include<stdlib.h>
@interface BlueToothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    
    unsigned int bluemac[6];
    unsigned int devicemac[6];
}

@property (nonatomic,strong)CBCentralManager *blueTooth;

@property (nonatomic,assign)BOOL isConnected;

@property (nonatomic,strong)NSMutableArray *peripherals;

@property (nonatomic,strong)NSMutableArray *advs;

@property (nonatomic,strong)CBPeripheral *peripheral;



@property (nonatomic,strong)CBCharacteristic *readCBCharacteristic;


@property (nonatomic,strong)CBCharacteristic *writeCBCharacteristic;


@property (nonatomic,strong)NSArray *services;

@property (nonatomic,assign)BOOL needToUnlock;//开锁标识

@property (nonatomic,assign)BOOL needToAddPermit;//获取权限标识

@property (nonatomic,assign)BOOL needBindAdmin;//绑定管理员标识

@property (nonatomic,assign)BOOL needGetLockInfo;//获取锁电量


@property (nonatomic,assign)BOOL needDeleteLockInfo;//删除电量

@property (nonatomic,assign)BOOL needAddKey;//添加钥匙

@property (nonatomic,assign)BOOL needgetLogs;//读取开锁记录

@property (nonatomic,assign)BOOL needgetSync;//同步蓝牙命令

@property (nonatomic,assign)BOOL needaddorDelete;//同步蓝牙命令


@property (nonatomic,assign)BOOL hasFoundLock;

@property (nonatomic,assign)BOOL hasResponse;

@property (nonatomic,assign)BOOL hasinit;

@property (nonatomic,strong) NSMutableData *responseData;

@property (nonatomic,strong)NSString *admin_mac;

@property (nonatomic,strong)NSString *addkey;

@property (nonatomic,assign)int type;

@property (nonatomic,assign)int sn;

@property (nonatomic,assign)BOOL isadd;


@end


@implementation BlueToothManager

+ (void)load
{
    [BlueToothManager sharedManager];
}

+ (instancetype)sharedManager
{
    static BlueToothManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[BlueToothManager alloc]init];
            sharedManager.peripherals = [[NSMutableArray alloc]init];
            sharedManager.advs = [[NSMutableArray alloc]init];
            [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(selectedLockChanged) name:@"lockchanged" object:nil];
             [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(cancelCheck) name:@"closeleft" object:nil];
            
        }
    });
    
    return sharedManager;
}

#pragma mark -methods
- (void)selectedLockChanged
{
    [self destroy];
    _hasinit = NO;
    _needToUnlock = NO;
    _hasFoundLock = NO;
    _needToAddPermit = NO;
    
}
- (void)destroy
{
    if (!self.blueTooth) {
        self.blueTooth = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
        [self.blueTooth stopScan];
    }
    _hasinit = YES;
    
    if (self.peripheral) {
        
        [self.blueTooth cancelPeripheralConnection:self.peripheral];
        
    }
    self.peripheral = nil;
    
    [self.peripherals removeAllObjects];
    [self.advs removeAllObjects];
    
    self.readCBCharacteristic = nil;
    
    self.writeCBCharacteristic = nil;
    
    _hasFoundLock = NO;
}
- (void)checkHasFoundLock
{
    [kWINDOW hideToastActivity];
    if (_hasFoundLock) {
        
      //  _hasFoundLock = YES;
     [self.blueTooth stopScan];
    
        
    }else
    {
        kWINDOW.userInteractionEnabled = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"suosoushibai"]];
        [self.loader animationStop];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkHasResponse) object:nil];
        kWINDOW.userInteractionEnabled = YES;
    
    }
    
    
}
- (void)checkHasResponse
{
   
    [kWINDOW hideToastActivity];
     kWINDOW.userInteractionEnabled = YES;
    if (_hasResponse) {
        _hasResponse = NO;
        [self.blueTooth stopScan];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.loader setCurrentState:CircleLockStateLocked];
        [self.loader animationStop];
    }else
    {
       
        [self.blueTooth stopScan];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"suoweixiangying"]];
        [self.loader setCurrentState:CircleLockStateLocked];
        [self.loader animationStop];
        
    }
    
    
}

- (void)cancelCheck
{
     kWINDOW.userInteractionEnabled = YES;
    _hasFoundLock = NO;
    _hasResponse = NO;
    [self.loader animationStop];
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkHasResponse) object:nil];
    
}
-(void)openLock{
    _needToUnlock = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        kWINDOW.userInteractionEnabled = NO;
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        [self.loader animationStart];
        if (self.peripheral) {
         [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [self.loader animationStop];
        [kWINDOW hideToastActivity];
        kWINDOW.userInteractionEnabled = YES;
       UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];

        
    }
    
}
//添加或者删除
- (void)addorDeleteUser:(int)sn isAdd:(BOOL)isadd type:(int)type
{
    _type = type;
    _sn =sn;
    _isadd = isadd;
//    kWINDOW.userInteractionEnabled = NO;
    [kWINDOW makeToastActivity:CSToastPositionCenter];
//    kWINDOW.userInteractionEnabled = NO;
    _needaddorDelete = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
         [kWINDOW makeToastActivity:CSToastPositionCenter];
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
    
}
//同步蓝牙命令
- (void)syncBlueTooth
{
//    kWINDOW.userInteractionEnabled = NO;
    _needgetSync = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
    
}
//获取锁电量
- (void)getLockInfo
{
//    kWINDOW.userInteractionEnabled = NO;
    _needGetLockInfo = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
         [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
}
//获取开锁记录
- (void)getLockLogs
{
//    kWINDOW.userInteractionEnabled = NO;
    _needgetLogs = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
    
    
    
}
//添加钥匙

- (void)addKey:(NSString *)account
{
//    kWINDOW.userInteractionEnabled = NO;
    _needAddKey = YES;
    _addkey = account;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        kWINDOW.userInteractionEnabled = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
    }
    
    
    
}



//删除锁
- (void)deleteLockInfo
{
//    kWINDOW.userInteractionEnabled = NO;
    _needDeleteLockInfo = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
    
    
}
//绑定管理员
- (void)BindAdmin:(NSString *)mac_blue
{
//    kWINDOW.userInteractionEnabled = NO;
    _admin_mac = mac_blue;
    _needBindAdmin = NO;
    [self bindAdminSucessdoVeryfy];
    
    
}
- (void)dosendBind
{
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
         [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
       // [self.loader animationStart];
        [kWINDOW makeToastActivity:CSToastPositionCenter];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [self.loader animationStop];
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
         [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
}

- (void)addPermit
{
//    kWINDOW.userInteractionEnabled = NO;
    _needToAddPermit = YES;
    if (self.blueTooth.state == CBManagerStatePoweredOn)
    {
        [self destroy];
        [self performSelector:@selector(checkHasFoundLock) withObject:nil afterDelay:14];
        [self.loader animationStart];
        if (self.peripheral) {
            [self.blueTooth cancelPeripheralConnection:self.peripheral];
        }
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }else
    {
        [self.loader animationStop];
        [kWINDOW hideToastActivity];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
         [window makeToast:[kMultiTool getMultiLanByKey:@"lanyaweidakai"]];
        kWINDOW.userInteractionEnabled = YES;
    }
    
    
    
    
}
- (void)deletePermit
{
    
    
    
}








-(void)writedata:(NSData *)commandData{
    
    if (self.peripheral && self.writeCBCharacteristic) {

        _responseData = nil; // 重要！！！！
        NSData *data = commandData;
       // [self commandLock:YES];
      //  NSData *data = [self commandLockPermission:YES];
        if(data == nil){
            kWINDOW.userInteractionEnabled = YES;
             return;
        }
        
        
        [self.peripheral setNotifyValue:YES forCharacteristic:self.readCBCharacteristic];
        NSInteger len = data.length;
        if(len > 20) {
            
            NSInteger count = len / 20 + 1;
            for(int i=0; i<count; i++) {
                
                NSInteger dataLen = (len-i*20) > 20 ? 20 : (len-i*20);
                NSData *subData = [data subdataWithRange:NSMakeRange(i*20, dataLen)];
                NSLog(@"subdata:%@", subData);
                [self.peripheral writeValue:subData forCharacteristic:self.writeCBCharacteristic type:CBCharacteristicWriteWithoutResponse];
            }
            
        } else {
             [self.peripheral writeValue:data forCharacteristic:self.writeCBCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
        
        //检测是否有response===时间是20s
        
        // [self performSelector:@selector(checkHasResponse) withObject:nil afterDelay:20];
        
        
        //NSData *data1 = [NSData dataWithBytes:unlockCommandbyte length:20];
        //NSData *data2 = [NSData dataWithBytes:unlockCommandbyte+20 length:9];
    }else{
          kWINDOW.userInteractionEnabled = YES;
    }
    
}

#pragma mark delegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
        [self.advs addObject:advertisementData];
    }
    for (NSDictionary *advertisementData in self.advs) {
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:[self.advs indexOfObject:advertisementData]];
        
        NSData *perialName = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        
        NSString *str1 = perialName.description;
        str1 = [str1 stringByReplacingOccurrencesOfString: @"<" withString:@""];
        str1 = [str1 stringByReplacingOccurrencesOfString: @" " withString:@""];
        NSString *selectPerialName = [[LockStoreManager sharedManager].selectedLock objectForKey:@"code"];
        if (_needBindAdmin) {
            selectPerialName = _admin_mac;
        }
        selectPerialName = [selectPerialName stringByReplacingOccurrencesOfString: @":" withString:@""];
        selectPerialName = [selectPerialName lowercaseStringWithLocale:[NSLocale currentLocale]];
        
       // NSLog(@"扫描到的蓝牙-----%@",str1);
      //  NSLog(@"需要绑定的蓝牙------%@",_admin_mac);
        if (str1 && selectPerialName && [str1 containsString:selectPerialName]) {
            peripheral.delegate = self;
           // [self.blueTooth stopScan];
            [self.blueTooth connectPeripheral:peripheral options:nil];
             _hasFoundLock = YES;
            //[self.blueTooth connectPeripheral:peripheral options:nil];
             [self.blueTooth stopScan];
            NSLog(@"蓝牙name ---%@",peripheral.name);
        }
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBManagerStatePoweredOn && _hasinit) {
        [self.blueTooth scanForPeripheralsWithServices:@[] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接到蓝牙 ---%@",peripheral.name);
    if (self.hasinit) {
    [self.loader setCurrentState:CircleLockStateConnected];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkHasFoundLock) object:nil];
    [self performSelector:@selector(checkHasResponse) withObject:nil afterDelay:20];
    // self.blueTooth
    CBUUID *service = [CBUUID UUIDWithString:@"0000ff12-0000-1000-8000-00805F9B34FB"];
    [peripheral discoverServices:@[service]];
    
}

#pragma mark perial delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    CBService *service  = peripheral.services.firstObject;
    [peripheral discoverCharacteristics:nil forService:service];
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered  perialname %@ characteristic %@",peripheral.name, characteristic.UUID.UUIDString);
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"FF02"]) {
            
            //读蓝牙特征
            //  [peripheral readValueForCharacteristic:characteristic];
            self.peripheral = peripheral;
            self.readCBCharacteristic = characteristic;
        }
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"FF01"]) {
            //写蓝牙特征
            self.peripheral = peripheral;
            self.writeCBCharacteristic = characteristic;
            //同步
            if (_needgetSync) {
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandSync]];
                        _needgetSync = NO;
                    });
                }else{
                    [self writedata:[self commandSync]];
                    _needgetSync = NO;
                }
            }else if (_needaddorDelete) {//添加或者删除
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandAddorDelete:_sn isAdd:_isadd userType:_type]];
                        _needaddorDelete = NO;
                    });
                }else{
                    [self writedata:[self commandAddorDelete:_sn isAdd:_isadd userType:_type]];
                    _needaddorDelete = NO;
                }
            }else if (_needToUnlock) {//开锁
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandLock:YES]];
                        _needToUnlock = NO;
                    });
                }else{
                    [self writedata:[self commandLock:YES]];
                    _needToUnlock = NO;
                }
            }else if (_needgetLogs) {//获取开锁记录
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandUnLockLogs]];
                        _needgetLogs = NO;
                    });
                }else{
                    [self writedata:[self commandUnLockLogs]];
                    _needgetLogs = NO;
                }
            }else if (_needGetLockInfo) {//获取锁电量
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandLockInfo]];
                        _needGetLockInfo = NO;
                    });
                }else{
                    [self writedata:[self commandLockInfo]];
                    _needGetLockInfo = NO;
                }
            }else if (_needAddKey) {//添加钥匙
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandKey:_addkey]];
                        _needAddKey = NO;
                    });
                }else{
                [self writedata:[self commandKey:_addkey]];
                    _needAddKey = NO;
                }
            }else if (_needDeleteLockInfo) {//删除锁
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandLockPermission:NO MacBlue:@""]];
                        _needDeleteLockInfo = NO;
                    });
                }else{
               [self writedata:[self commandLockPermission:NO MacBlue:@""]];
                    _needDeleteLockInfo = NO;
                }
            }else if (_needBindAdmin) { //绑定管理员
                if (!self.readCBCharacteristic) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self writedata:[self commandLockPermission:YES MacBlue:_admin_mac]];
                        _needBindAdmin = NO;
                    });
                }else{
                    [self writedata:[self commandLockPermission:YES MacBlue:_admin_mac]];
                    _needBindAdmin = NO;
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    //NSData *data = characteristic.value;
    // parse the data as needed
    //NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"read---%@",data);
    if(_responseData == nil) {
//        kWINDOW.userInteractionEnabled = NO;
        _responseData = [NSMutableData dataWithData:characteristic.value];
        if(_responseData.length == 20) {
            Byte byteArray[20];
            [_responseData getBytes:&byteArray length:20];
            if(byteArray[19] == 0x16) {
                [self performSelector:@selector(processData:) withObject:_responseData afterDelay:0.01];
            }
        } else if(_responseData.length < 20) {
            [self performSelector:@selector(processData:) withObject:_responseData afterDelay:0.01];
        }
    } else {
        NSData *data = characteristic.value;
        [_responseData appendData:data];
        if(data.length == 20) {
            Byte byteArray[20];
            [data getBytes:&byteArray length:20];
            if(byteArray[19] == 0x16) {
                [self performSelector:@selector(processData:) withObject:_responseData afterDelay:0.01];
            }
        } else if(data.length < 20) {
            [self performSelector:@selector(processData:) withObject:_responseData afterDelay:0.01];
        }

    }
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
   // [peripheral readValueForCharacteristic:self.readCBCharacteristic];
    
}

- (void)processData:(NSData *)data {
    [self cancelCheck];
    _hasResponse = YES;
    [kWINDOW hideToastActivity];
    kWINDOW.userInteractionEnabled = YES;
    if(data == nil || data.length < 5)
        return;
    
    NSInteger rxCount = data.length;
    Byte byteArray[rxCount];
    [data getBytes:&byteArray length:rxCount];
    for(int i=0; i<rxCount; i++) {
        NSLog(@"-%d:%d", i, byteArray[i]);
    }
    
    NSInteger dataLen = rxCount-5;
    Byte dataByte[dataLen];
    int sum = byteArray[1];
    sum += byteArray[2];
    for(int i=3, j=0; i<(rxCount-2); i++, j++) {
        dataByte[j] = byteArray[i];
        sum += byteArray[i];
        //NSLog(@"#%ld:%d", j, byteArray[i]);
    }
    
    BOOL check = NO;
    if((sum & 0x000000FF) == byteArray[rxCount-2]) {
        check = YES;
    }
    
    NSLog(@"data check result:%@", check?@"success":@"fail");
    if(!check) {// data error format
        return;
    }
    
    decrypt(dataByte, dataLen);
    if(dataByte[0] == 0x01) { // 开锁
        [self unlockResult:dataByte dataLen:dataLen];
    } else if(dataByte[0] == 0x02) { // 反锁
        [self lockResult:dataByte dataLen:dataLen];
    } else if(dataByte[0] == 0x21) { // 添加管理员
        [self addLockPermissionResult:dataByte dataLen:dataLen];
    } else if(dataByte[0] == 0x22) { // 添加永久开锁权限
        [self addKeyResult:dataByte dataLen:dataLen];
    } else if(dataByte[0] == 0x23) { // 删除永久开锁权限，删除管理员
        [self removeLockPermissionResult:dataByte dataLen:dataLen];
    }else if(dataByte[0] == 0x31) { // 读取开锁纪录
        [self readUnlockLogResult:dataByte dataLen:dataLen];
    }else if(dataByte[0] == 0x36) { // 获取锁内信息
        [self readLockInfoResult:dataByte dataLen:dataLen];
    }else if(dataByte[0] == 0x42) { // 同步蓝牙
        [self readSyncResult:dataByte dataLen:dataLen];
    }else if(dataByte[0] == 0x40) { // 添加或者删除用户
        [self addordeleteuser:dataByte dataLen:dataLen];
    }
    
    
    _responseData = nil;
}
//添加或者删除用户
- (NSData *)commandAddorDelete:(int)sn isAdd:(BOOL)isadd userType:(int)type{
    
    _sn = sn;
    _isadd = isadd;
    _type = type;
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:[kdicSelected objectForKey:@"mac"]];
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    //数据域的字节
    Byte databyte[24] = {};
    databyte[0] = 0x40;
    databyte[1] = devicemac[0];//bluemac
    databyte[2] = devicemac[1];//bluemac
    databyte[3] = devicemac[2];//bluemac
    databyte[4] = devicemac[3];//bluemac
    databyte[5] = devicemac[4];//bluemac
    databyte[6] = devicemac[5];//bluemac
    
    
    
    databyte[7] = 0x05;//四字节厂商代码05120001
    databyte[8] = 0x12;//四字节厂商代码
    databyte[9] = 0x00;//四字节厂商代码
    databyte[10] = 0x01;//四字节厂商代码
    
        NSDate *date =[NSDate date];//简书 FlyElephant
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:date] integerValue]-2000;
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"HH"];
        NSInteger currentHour=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"mm"];
        NSInteger currentMinute=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"ss"];
        NSInteger currentSecond=[[formatter stringFromDate:date] integerValue];
    
        databyte[11] = currentYear;//年月日时分秒6位
        databyte[12] = currentMonth;//年月日时分秒6位
        databyte[13] = currentDay;//年月日时分秒6位
        databyte[14] =currentHour;//年月日时分秒6位
        databyte[15] = currentMinute;//年月日时分秒6位
        databyte[16] = currentSecond;//年月日时分秒6位
        databyte[17] = isadd ? 0x01:0x02;
        databyte[18] = type;
        databyte[19] = sn;
    //    databyte[22] = 0x01;//主机联网状态
    //    databyte[23] = 0x03;//一位随机位
    //
    databyte[20] = 0x03;//随机数一位
    databyte[21] = 0x03;//随机数四位
    databyte[22] = 0x03;//随机数四位
    databyte[23] = 0x03;//随机数四位
    
   
    encrypt(databyte, 24);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte commandByte[29];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x18;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<24; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<27; i++) {
        sum += commandByte[i];
    }
    
    commandByte[27] = sum & 0x000000FF;//数据域校验和
    commandByte[28] = 0x16;//结束校验符
    
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}

//同步蓝牙命令
- (NSData *)commandSync {
    
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:[kdicSelected objectForKey:@"mac"]];
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    //数据域的字节
    Byte databyte[16] = {};
    databyte[0] = 0x42;
    databyte[1] = devicemac[0];//bluemac
    databyte[2] = devicemac[1];//bluemac
    databyte[3] = devicemac[2];//bluemac
    databyte[4] = devicemac[3];//bluemac
    databyte[5] = devicemac[4];//bluemac
    databyte[6] = devicemac[5];//bluemac
    
   
    
    databyte[7] = 0x05;//四字节厂商代码05120001
    databyte[8] = 0x12;//四字节厂商代码
    databyte[9] = 0x00;//四字节厂商代码
    databyte[10] = 0x01;//四字节厂商代码
    databyte[11] = 0x03;//随机数一位
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
//    NSDate *date =[NSDate date];//简书 FlyElephant
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//
//    [formatter setDateFormat:@"yyyy"];
//    NSInteger currentYear=[[formatter stringFromDate:date] integerValue]-2000;
//    [formatter setDateFormat:@"MM"];
//    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
//    [formatter setDateFormat:@"dd"];
//    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
//    [formatter setDateFormat:@"HH"];
//    NSInteger currentHour=[[formatter stringFromDate:date] integerValue];
//    [formatter setDateFormat:@"mm"];
//    NSInteger currentMinute=[[formatter stringFromDate:date] integerValue];
//    [formatter setDateFormat:@"ss"];
//    NSInteger currentSecond=[[formatter stringFromDate:date] integerValue];
//
//    databyte[16] = [self integerTohex:currentYear];//年月日时分秒6位
//    databyte[17] = [self integerTohex:currentMonth];//年月日时分秒6位
//    databyte[18] = [self integerTohex:currentDay];//年月日时分秒6位
//    databyte[19] = [self integerTohex:currentHour];//年月日时分秒6位
//    databyte[20] = [self integerTohex:currentMinute];//年月日时分秒6位
//    databyte[21] = [self integerTohex:currentSecond];//年月日时分秒6位
//
//    databyte[22] = 0x01;//主机联网状态
//    databyte[23] = 0x03;//一位随机位
//
    encrypt(databyte, 16);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte commandByte[21];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x10;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<16; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<19; i++) {
        sum += commandByte[i];
    }
    
    commandByte[19] = sum & 0x000000FF;//数据域校验和
    commandByte[20] = 0x16;//结束校验符
    
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}



//开锁
- (NSData *)commandLock:(BOOL)unlock {
    
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:[kdicSelected objectForKey:@"mac"]];
    
    //数据域的字节
    Byte databyte[24] = {};
    databyte[0] = unlock?0x01:0x02;
    databyte[1] = bluemac[0];//bluemac
    databyte[2] = bluemac[1];//bluemac
    databyte[3] = bluemac[2];//bluemac
    databyte[4] = bluemac[3];//bluemac
    databyte[5] = bluemac[4];//bluemac
    databyte[6] = bluemac[5];//bluemac
    
    databyte[7] = 0x03;//随机数一位
    
    databyte[8] = 0x05;//四字节厂商代码05120001
    databyte[9] = 0x12;//四字节厂商代码
    databyte[10] = 0x00;//四字节厂商代码
    databyte[11] = 0x01;//四字节厂商代码
    
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue]-2000;
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"HH"];
    NSInteger currentHour=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"mm"];
    NSInteger currentMinute=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"ss"];
    NSInteger currentSecond=[[formatter stringFromDate:date] integerValue];
    
    databyte[16] = currentYear;//年月日时分秒6位
    databyte[17] = currentMonth;//年月日时分秒6位
    databyte[18] = currentDay;//年月日时分秒6位
    databyte[19] = currentHour;//年月日时分秒6位
    databyte[20] = currentMinute;//年月日时分秒6位
    databyte[21] = currentSecond;//年月日时分秒6位
    
    databyte[22] = 0x01;//主机联网状态
    databyte[23] = 0x03;//一位随机位
    
    encrypt(databyte, 24);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte unlockCommandbyte[29];
    unlockCommandbyte[0] = 0x68;
    unlockCommandbyte[1] = 0x01;
    unlockCommandbyte[2] = 0x18;//数据域长度

    //把数据域的赋值
    for (int i=0; i<24; i++) {
        unlockCommandbyte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<27; i++) {
        sum += unlockCommandbyte[i];
    }
    
    unlockCommandbyte[27] = sum & 0x000000FF;//数据域校验和
    unlockCommandbyte[28] = 0x16;//结束校验符
    
    int byteLen = sizeof(unlockCommandbyte) / sizeof(unlockCommandbyte[0]);
    NSData *data = [NSData dataWithBytes:unlockCommandbyte length:byteLen];
    return data;
}
//绑定====添加／删除管理员，删除钥匙方法与删除管理员相同
- (NSData *)commandLockPermission:(BOOL)isAdd MacBlue:(NSString *)mac_blue{
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:loginModel.retval.bluemac]; // 手机mac
    
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    
    //数据域的字节
    Byte databyte[32] = {};
    databyte[0] = isAdd ? 0x21 : 0x23;
    databyte[1] = bluemac[0];//bluemac
    databyte[2] = bluemac[1];//bluemac
    databyte[3] = bluemac[2];//bluemac
    databyte[4] = bluemac[3];//bluemac
    databyte[5] = bluemac[4];//bluemac
    databyte[6] = bluemac[5];//bluemac
    
    databyte[7] = 0x03;//随机数一位
    
    databyte[8] = 0x05;//四字节厂商代码05120001
    databyte[9] = 0x12;//四字节厂商代码
    databyte[10] = 0x00;//四字节厂商代码
    databyte[11] = 0x01;//四字节厂商代码
    
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
    databyte[16] = devicemac[0];
    databyte[17] = devicemac[1];
    databyte[18] = devicemac[2];
    databyte[19] = devicemac[3];
    databyte[20] = devicemac[4];
    databyte[21] = devicemac[5];
    
    databyte[22] = 0x03;//随机数
    databyte[23] = 0x03;//随机数
    
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue]-2000;
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"HH"];
    NSInteger currentHour=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"mm"];
    NSInteger currentMinute=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"ss"];
    NSInteger currentSecond=[[formatter stringFromDate:date] integerValue];
    
    databyte[24] = currentYear;//年月日时分秒6位
    databyte[25] = currentMonth;//年月日时分秒6位
    databyte[26] = currentDay;//年月日时分秒6位
    databyte[27] = currentHour;//年月日时分秒6位
    databyte[28] = currentMinute;//年月日时分秒6位
    databyte[29] = currentSecond;//年月日时分秒6位
    
    databyte[30] = 0x03;//随机位
    databyte[31] = 0x03;//随机位
    
    encrypt(databyte, 32);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte commandByte[37];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x20;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<32; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<35; i++) {
        sum += commandByte[i];
    }
    
    commandByte[35] = sum & 0x000000FF;//数据域校验和
    commandByte[36] = 0x16;//结束校验符
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}
//添加钥匙
- (NSData *)commandKey:(NSString *)account{
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:account]; // 手机mac
    
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    
    //数据域的字节
    Byte databyte[32] = {};
    databyte[0] = 0x22 ;
    databyte[1] = bluemac[0];//bluemac
    databyte[2] = bluemac[1];//bluemac
    databyte[3] = bluemac[2];//bluemac
    databyte[4] = bluemac[3];//bluemac
    databyte[5] = bluemac[4];//bluemac
    databyte[6] = bluemac[5];//bluemac
    
    databyte[7] = 0x03;//随机数一位
    
    databyte[8] = 0x05;//四字节厂商代码05120001
    databyte[9] = 0x12;//四字节厂商代码
    databyte[10] = 0x00;//四字节厂商代码
    databyte[11] = 0x01;//四字节厂商代码
    
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
    databyte[16] = devicemac[0];
    databyte[17] = devicemac[1];
    databyte[18] = devicemac[2];
    databyte[19] = devicemac[3];
    databyte[20] = devicemac[4];
    databyte[21] = devicemac[5];
    
    databyte[22] = 0x03;//随机数
    databyte[23] = 0x03;//随机数
    
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue]-2000;
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"HH"];
    NSInteger currentHour=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"mm"];
    NSInteger currentMinute=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"ss"];
    NSInteger currentSecond=[[formatter stringFromDate:date] integerValue];
    
    databyte[24] = currentYear;//年月日时分秒6位
    databyte[25] = currentMonth;//年月日时分秒6位
    databyte[26] = currentDay;//年月日时分秒6位
    databyte[27] = currentHour;//年月日时分秒6位
    databyte[28] = currentMinute;//年月日时分秒6位
    databyte[29] = currentSecond;//年月日时分秒6位
    
    databyte[30] = 0x03;//随机位
    databyte[31] = 0x03;//随机位
    
    encrypt(databyte, 32);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte commandByte[37];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x20;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<32; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<35; i++) {
        sum += commandByte[i];
    }
    
    commandByte[35] = sum & 0x000000FF;//数据域校验和
    commandByte[36] = 0x16;//结束校验符
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}
//读取开锁纪录
- (NSData *)commandUnLockLogs {
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:loginModel.retval.bluemac]; // 手机mac
    
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    
    //数据域的字节
    Byte databyte[16] = {};
    databyte[0] = 0x31 ;
    databyte[1] = devicemac[0];//bluemac
    databyte[2] = devicemac[1];//bluemac
    databyte[3] = devicemac[2];//bluemac
    databyte[4] = devicemac[3];//bluemac
    databyte[5] = devicemac[4];//bluemac
    databyte[6] = devicemac[5];//bluemac
    
    databyte[7] = 0x03;//随机数一位
    
    databyte[8] = 0x05;//四字节厂商代码05120001
    databyte[9] = 0x12;//四字节厂商代码
    databyte[10] = 0x00;//四字节厂商代码
    databyte[11] = 0x01;//四字节厂商代码
    
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
    encrypt(databyte, 16);
    
    //命令
    //注意 开锁命令数据域需要加密，现在不知道怎么加密。。。先不加密试试
    Byte commandByte[21];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x10;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<16; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<19; i++) {
        sum += commandByte[i];
    }
    
    commandByte[19] = sum & 0x000000FF;//数据域校验和
    commandByte[20] = 0x16;//结束校验符
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}

//获取锁信息
- (NSData *)commandLockInfo {
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    [self macToByte:loginModel.retval.bluemac]; // 手机mac
    
    if(![self devicemacToByte]) // 蓝牙mac
        return nil;
    
    //数据域的字节
    Byte databyte[16] = {};
    databyte[0] = 0x36;
    databyte[1] = devicemac[0];//bluemac
    databyte[2] = devicemac[1];//bluemac
    databyte[3] = devicemac[2];//bluemac
    databyte[4] = devicemac[3];//bluemac
    databyte[5] = devicemac[4];//bluemac
    databyte[6] = devicemac[5];//bluemac
    
    databyte[7] = 0x03;//随机数一位
    
    databyte[8] = 0x05;//四字节厂商代码05120001
    databyte[9] = 0x12;//四字节厂商代码
    databyte[10] = 0x00;//四字节厂商代码
    databyte[11] = 0x01;//四字节厂商代码
    
    databyte[12] = 0x03;//随机数四位
    databyte[13] = 0x03;//随机数四位
    databyte[14] = 0x03;//随机数四位
    databyte[15] = 0x03;//随机数四位
    
    encrypt(databyte, 16);
    
    //命令
    Byte commandByte[21];
    commandByte[0] = 0x68;
    commandByte[1] = 0x01;
    commandByte[2] = 0x10;//数据域长度
    
    //把数据域的赋值
    for (int i=0; i<16; i++) {
        commandByte[i+3] = databyte[i];
    }
    
    int sum = 0;
    for (int i=1; i<19; i++) {
        sum += commandByte[i];
    }
    
    commandByte[19] = sum & 0x000000FF;//数据域校验和
    commandByte[20] = 0x16;//结束校验符
    
    int byteLen = sizeof(commandByte) / sizeof(commandByte[0]);
    NSData *data = [NSData dataWithBytes:commandByte length:byteLen];
    return data;
}


- (void)unlockResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
     [self destroy];
    [self.loader animationStop];
    _hasResponse = YES;
    if(dataByte == nil || dataLen != 8)
        return;

    int result = dataByte[1];
    NSLog(@"unlockResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    int second = (int)dataByte[2];
    int th = (int)dataByte[3];
    NSLog(@"%d",second * 256 + th);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockinfo1" object:@(second * 256 + th)];
    switch (result) {
        case 0x00: // success
        {
            int vol = dataByte[2];
            NSLog(@"voltage is:%d", vol);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocksuccess" object:nil];
            [window makeToast:[kMultiTool getMultiLanByKey:@"mensuoyikaiqi"]];
        }
            break;
        case 0x01:
            [window makeToast:[kMultiTool getMultiLanByKey:@"mensuoyikaiqi"]];
            break;
        case 0x02:
            [window makeToast:[kMultiTool getMultiLanByKey:@"dianliangdi"]];
            break;
        case 0x03:
            [window makeToast:[kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
            break;
        case 0x04:
            [window makeToast:[kMultiTool getMultiLanByKey:@"zhuangtaisuowu"]];
            break;
        case 0x05:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];
            break;
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
    }
    [self.loader animationStop];
    [self.loader setCurrentState:CircleLockStateUnlocked];
}

- (void)lockResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
     [self destroy];
    
    [self.loader animationStop];
    _hasResponse = YES;
    if(dataByte == nil || dataLen != 8)
        return;
    int result = dataByte[1];
    NSLog(@"lockResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    switch (result) {
            
        case 0x00: // success
        {
            int vol = dataByte[2];
            [self.loader animationStop];
            [self.loader setCurrentState:CircleLockStateUnlocked];
            NSLog(@"voltage is:%d", vol);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocksuccess" object:nil];
            [window makeToast:[kMultiTool getMultiLanByKey:@"mensuoyikaiqi"]];
        }
            break;
        case 0x01:
            [window makeToast:[kMultiTool getMultiLanByKey:@"mensuoyikaiqi"]];
            break;
        case 0x02:
            [window makeToast:[kMultiTool getMultiLanByKey:@"dianliangdi"]];
            break;
        case 0x03:
            [window makeToast:[kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
            break;
        case 0x04:
            [window makeToast:[kMultiTool getMultiLanByKey:@"zhuangtaisuowu"]];
            break;
        case 0x05:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];
            break;
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
    }
}

- (void)addLockPermissionResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
    [self destroy];
    [self.loader animationStop];
    _hasResponse = YES;
    if(dataByte == nil || dataLen != 16)
        return;
    
    int result = dataByte[14];
    
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"addLockPermissionResult:%d", result);
    switch (result) {
        case 0x00: // success
        {
            //绑定成功调用后端接口
           
            [self bindAdmin];
            
        }
            break;
        case 0x01:
             [window makeToast:[kMultiTool getMultiLanByKey:@"meiyoulianjiedaozhengquesuo"]];
            break;
        case 0x02:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weijinrulanyamoshi"]];

            break;
        case 0x03:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];

            break;
        case 0x04:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];

            break;
            
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];

            break;
    }
    [kWINDOW hideToastActivity];
}

- (void)addKeyResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
//    [self cancelCheck];
     [self destroy];
    if(dataByte == nil || dataLen != 16)
        return;
    
    int result = dataByte[14];
    _hasResponse = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"addLockPermissionResult:%d", result);
    switch (result) {
        case 0x00: // success
        {
            //绑定成功调用后端接口
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addkeysuccess" object:nil];
            
        }
            break;
        case 0x01:
             [window makeToast:[kMultiTool getMultiLanByKey:@"tianjiashibai"]];
            break;
        case 0x02:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addkeysuccess" object:nil];
            break;
        case 0x03:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weijinrulanyamoshi"]];

            break;
        case 0x04:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];            break;
            
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];

            break;
    }
     [kWINDOW hideToastActivity];
}




- (void)removeLockPermissionResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
    [self destroy];
     [kWINDOW hideToastActivity];
//    [self cancelCheck];
    if(dataByte == nil || dataLen != 16)
        return;
    
    int result = dataByte[14];
    NSLog(@"removeLockPermissionResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
   
    switch (result) {
        case 0x00: // success
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteLockInfo" object:nil];
        }
            break;
        case 0x01:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteLockInfo" object:nil];
//             [window makeToast:[kMultiTool getMultiLanByKey:@"shanchushibai"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteLockInfofail" object:nil];
            break;
        case 0x02:
              [window makeToast:[kMultiTool getMultiLanByKey:@"weijinrulanyamoshi"]];
            break;
        case 0x03:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];
            break;
            
        default:
          [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
    }
}



- (void)readUnlockLogResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
     [self destroy];
    if(dataByte == nil)
        return;
    [self.loader animationStop];
    _hasResponse = YES;
    NSMutableArray *dateArray = [NSMutableArray new];
    int r1 = dataByte[1];
    int r2 = dataByte[2];
    int result = r1 * 256 + r2;
    for (int i = 0; i<dataLen; i++) {
        NSLog(@"%d ===",dataByte[i]);
    }
    if (dataLen <= 8) {
        //无记录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getlockrecord" object:nil];

        return;
    }else{
        //有记录
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i*8 + 3 <dataLen-5; i++) {
             NSString *dateStr = @"20";
            for (int j=0; j<8; j++) {
                //前六个字节是时间
                //第一个字节
               
                int num = i*8 + 3 + j;
                if (j==0) {
                   dateStr = [NSString stringWithFormat:@"%@%d",dateStr,dataByte[num]];
                }else if (j==1)
                {
                     dateStr = [NSString stringWithFormat:@"%@-%d",dateStr,dataByte[num]];
                }else if (j==2)
                {
                    dateStr = [NSString stringWithFormat:@"%@-%d",dateStr,dataByte[num]];
                   // [dateArray addObject:dateStr];
                }else if (j==3)
                {
                    dateStr = [NSString stringWithFormat:@"%@ %d",dateStr,dataByte[num]];
                   // [dateArray addObject:dateStr];
                }else if (j==4)
                {
                    dateStr = [NSString stringWithFormat:@"%@:%d",dateStr,dataByte[num]];
                   // [dateArray addObject:dateStr];
                }
                
                if (j==6) {
                    int type = dataByte[num];
                    [dic setObject:dateStr forKey:@"time"];
                    [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                    NSLog(@"datestr===%@",dateStr);
                }
                if (j==7) {
                    int uuid = dataByte[num];
                    [dic setObject:[NSString stringWithFormat:@"%d",uuid] forKey:@"uuid"];
                    NSLog(@"datestr===%@",dateStr);
                    [dateArray addObject:dic];
                }
                
            }
    
                //第七个字节是开锁方式
            
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getlockrecord" object:dateArray];
    }
    NSLog(@"removeLockPermissionResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (result) {
        case 0x00: // success
        {
            int unlockType = dataByte[10];
            NSLog(@"%d----",unlockType);
            
        }
            break;
        case 0x01:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];

            break;
            
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
    }
}



- (void)readLockInfoResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
    [self destroy];
//    [self cancelCheck];
    if(dataByte == nil)
        return;
    int result = dataByte[5];
    NSLog(@"removeLockPermissionResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (result) {
        case 0x00: // success
        {
            int second = (int)dataByte[2];
            int th = (int)dataByte[3];
            NSLog(@"%d",second * 256 + th);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"lockinfo" object:@(second * 256 + th)];
            
        }
            break;
        case 0x01:
            [window makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];
            break;
            
        default:
             [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
    
    }
}
- (void)addordeleteuser:(Byte *)dataByte dataLen:(NSInteger)dataLen {
   
//    [self cancelCheck];
    if(dataByte == nil)
        return;
    int result = dataByte[1];
    NSLog(@"removeLockPermissionResult:%d", result);
//    确认码：0x00 收到指令，进入设置状态
//    0x01 MAC地址或厂商代码不符，进入设置失败
//    0x02 操作完成
//    0x03 用户退出操作
//    0x04 用户操作失败
//    0x05 用户未操作，超时退出
//    0x06 删除用户时，无此用户
    switch (result) {
            
        case 0x00:
            if(_isadd)
            {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"enterset" object:nil];
            }
            break;
        case 0x01:
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@""]];
            [self destroy];
            break;
           case 0x02:
            [self destroy];
            [kWINDOW hideAllToasts];
            kWINDOW.userInteractionEnabled = YES;
          //  [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"tianjiachenggong"]];
            if (_isadd) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"addusersuccess" object:nil];
            }else
            {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"lockdeleteusersuccess" object:nil];
                
            }
            
            break;
        default:
            [self destroy];
            [kWINDOW hideAllToasts];
            kWINDOW.userInteractionEnabled = YES;
            if (_isadd) {
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"tianjiashibai"]];
            }else{
              [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shanchushibai"]];
            }
       
            break;
    }
    
}

- (void)readSyncResult:(Byte *)dataByte dataLen:(NSInteger)dataLen {
    [self destroy];
//    [self cancelCheck];
    if(dataByte == nil)
        return;
    int result = dataByte[3];
    int userType = dataByte[4];
    int userCode = dataByte[5];
    int number1 = dataByte[1] * 256 + dataByte[2];
    NSLog(@"removeLockPermissionResult:%d", result);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    操作码：0x00 表示MAC或厂商代码不符，无法同步
//    0x01 表示添加用户
//    0x02 表示删除用户
//    0x03 表示清空非管理用户
//    0x04 表示修改用户
//    0x05 表示恢复出厂设置
//    0x06 表示当前没有数据
//    用户类型：0x01密码/0x81管理员密码
//    0x02指纹/0x82管理员指纹
//    0x03 IC卡/0x83管理员IC卡
//    0x04遥控器/0x84管理员遥控器

    switch (result) {
        case 0x00: //
        {
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"changshangdaimacuowu"]];
            [kWINDOW hideAllToasts];
            kWINDOW.userInteractionEnabled = YES;
        }
        break;
        case 0x01:
        {
           // 0x01 表示添加用户
            NSDictionary *dic = @{@"userType":@(userType),@"userCode":@(userCode)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lockadduser" object:dic];
//            if (number1) {
//                [self syncBlueTooth];
//            }
//            if (number1 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
//            }
            
        }
            break;
        case 0x02:
        {
            // 删除用户
            NSDictionary *dic = @{@"userType":@(userType),@"userCode":@(userCode)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lockdeleteuser" object:dic];
//            if (number1) {
//                [self syncBlueTooth];
//            }
//
//            if (number1 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
//            }
            
        }
            break;
        case 0x03:
        {
            // 清空非管理用户
            NSDictionary *dic = @{@"userType":@(userType),@"userCode":@(userCode)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lockclearuser" object:dic];
//            if (number1) {
//                [self syncBlueTooth];
//            }
//            if (number1 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
//            }
            
        }
            break;
        case 0x04:
        {
            // 修改用户
            NSDictionary *dic = @{@"userType":@(userType),@"userCode":@(userCode)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lockmodifyuser" object:dic];
//            if (number1) {
//                [self syncBlueTooth];
//            }
//            if (number1 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
//            }
            
        }
            break;
        case 0x05:
        {
            // 恢复出厂设置
            NSDictionary *dic = @{@"userType":@(userType),@"userCode":@(userCode)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lockreset" object:dic];
//            if (number1) {
//                [self syncBlueTooth];
//            }
//            if (number1 == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
//            }
            
        }
            break;
        case 0x06:
        {
            //没有数据
              [[NSNotificationCenter defaultCenter] postNotificationName:@"locknodata" object:nil];
            
        }
            break;
        default:
            [window makeToast:[kMultiTool getMultiLanByKey:@"weizhicuowu"]];
            break;
            
    }
    
}


#pragma mark -hex
- (void)macToByte:(NSString *)macStr
{
    char  css[100];
    memcpy(css, [macStr cStringUsingEncoding:NSASCIIStringEncoding], 2*[macStr length]);
    sscanf(css,"%2x:%02x:%02x:%02x:%02x:%02x", &bluemac[0], &bluemac[1], &bluemac[2], &bluemac[3], &bluemac[4], &bluemac[5]);
    printf("Mac is %s,mac is %02x%02x%02x%02x%02x%02x\n",css, bluemac[0], bluemac[1], bluemac[2], bluemac[3], bluemac[4], bluemac[5]);
    
}

- (BOOL)devicemacToByte
{
    NSString *macstr;
    if (_needBindAdmin) {
        macstr = _admin_mac;
    }else{
        
     macstr = [[LockStoreManager sharedManager].selectedLock objectForKey:@"code"];
        
    }
   
    if(macstr == nil)
        return NO;
    
    char  css[100];
    memcpy(css, [macstr cStringUsingEncoding:NSASCIIStringEncoding], 2*[macstr length]);
    sscanf(css,"%2x:%02x:%02x:%02x:%02x:%02x", &devicemac[0], &devicemac[1], &devicemac[2], &devicemac[3], &devicemac[4], &devicemac[5]);
    //printf("Mac is %s,mac is %02x%02x%02x%02x%02x%02x\n",css, devicemac[0], devicemac[1], devicemac[2], devicemac[3], devicemac[4], devicemac[5]);
    
    return YES;
}

- (unsigned long)integerTohex:(NSInteger)intergerValue
{
    unsigned long red = strtoul([[NSString stringWithFormat:@"%li",intergerValue] UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    
    return red;
}
- (int)myhex:(int)res
{
    int result = res/16 * 10 + res % 16;
    
    return result;
}
- (NSString *)hexToInteger:(int)hex
{
    int result = 0;
    
    result = hex/10 * 16 + hex % 10;
  
    return  [NSString stringWithFormat:@"%d",result];
}

#pragma mark - interface methods

- (void)bindAdminSucessdoVeryfy
{
//    OkGo.get(activity.getResources().getString(R.string.APP_URL)).params("code", mac)

    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];

    NSDictionary *dic = @{@"code":_admin_mac,@"app":@"userloginapp",@"act":@"bind_lock_pre",@"token":loginModel.retval.token};
    
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
       // [kWINDOW hideToastActivity];
//        if ([[responseObject valueForKey:@"msg"] isEqualToString:[kMultiTool getMultiLanByKey:@"caozuochenggong"]]) {
        if ([[responseObject valueForKey:@"done"] boolValue]) {
            _needBindAdmin = YES;
            [self dosendBind];
        }else{
           [kWINDOW makeToast:[responseObject valueForKey:@"msg"]];
            _needBindAdmin = NO;
            [kWINDOW hideToastActivity];
            kWINDOW.userInteractionEnabled = YES;
        }
       
        
    } failure:^(NSError *error) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"caozuoshibai"]];
        _needBindAdmin = NO;
        kWINDOW.userInteractionEnabled = YES;
        [kWINDOW hideToastActivity];
    }];
    
    
}
- (void)bindAdmin
{
    //    OkGo.get(activity.getResources().getString(R.string.APP_URL)).params("code", mac_lock)
//        .params("app", "userloginapp").params("act", "bind_lock").params("pmac", mac_phone)
//        .params("token", userInfo == null ? "" : userInfo.token)
//        .cacheKey("bind_lock")

    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *logindic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    NSDictionary *dic = @{@"code":_admin_mac,@"app":@"userloginapp",@"act":@"bind_lock",@"token":loginModel.retval.token,@"pmac":loginModel.retval.bluemac};
    
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        kWINDOW.userInteractionEnabled = YES;
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"done"] boolValue]) {
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"bangdingcehnggong"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindsuccess" object:nil];
        }else{
            [kWINDOW makeToast:[responseObject valueForKey:@"msg"]];
           
        }

       
        
    } failure:^(NSError *error) {
        kWINDOW.userInteractionEnabled = YES;
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"bangdingshibai"]];
        [kWINDOW hideToastActivity];
    }];
    
    
}

@end
