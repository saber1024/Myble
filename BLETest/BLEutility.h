//
//  BLEutility.h
//  BLETest
//
//  Created by shiki on 2016/10/14.
//  Copyright © 2016年 两仪式. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol SaberBleProtocol
@optional
-(void)didDeviceDisConeect;
-(void)diddiscoveredDevice;
@end

@interface BLEutility : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
+(BLEutility *)SharedBLE;
-(void)SenData:(NSData *)Data;
-(void)disConnecttoManager:(CBCentralManager *)Manager;
-(void)Connect:(CBPeripheral *)targetPeriphral;
-(void)ToDiscoverServiceForperiphral;
-(void)ScanDevice:(int)timeout;
-(void)stopScanfBluetooth:(NSTimer *)timer;
-(void)ReadData;


@property(nonatomic,strong) CBPeripheral *peri;
@property(nonatomic,strong) CBCentralManager *Manager;
@property(nonatomic,strong) id<SaberBleProtocol>delegate;
@property(nonatomic,strong) NSMutableArray *DeviceList;

@end
