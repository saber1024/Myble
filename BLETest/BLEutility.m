//
//  BLEutility.m
//  BLETest
//
//  Created by shiki on 2016/10/14.
//  Copyright © 2016年 两仪式. All rights reserved.
//

#import "BLEutility.h"
#define TCReadUUID  @""
#define TCWriteUUID @""
#define TCPeriUUID  @""
@interface BLEutility()
@property(nonatomic,strong)CBCharacteristic *writeChar;
@property(nonatomic,strong) CBCharacteristic *readChasra;
@property(nonatomic,strong) NSMutableData* readData;

@end
@implementation BLEutility
#pragma mark - 单例初始化对象
+(BLEutility *)SharedBLE{
    static BLEutility *ble = nil;
    if (ble==nil) {
        ble = [[BLEutility alloc]init];
    }
    return ble;
}
-(instancetype)init{
    self = [super init];
    if(self){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
             self.Manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
            _readData = [NSMutableData data];
            _DeviceList = [NSMutableArray array];
        });
    }
    return self;
}

#pragma mark - 工具类功能

//连接
-(void)Connect:(CBPeripheral *)targetPeriphral{
    [_Manager connectPeripheral:targetPeriphral options:nil];
    
}
//发送
-(void)SenData:(NSData *)Data{
   if(self.peri.state == CBPeripheralStateConnected)
        [self.peri writeValue:Data forCharacteristic:_writeChar type:CBCharacteristicWriteWithResponse];
}

//断开连接
-(void)disConnecttoManager:(CBCentralManager *)Manager{
  
    [Manager cancelPeripheralConnection:_peri];
}

-(void)ToDiscoverServiceForperiphral{
    [_peri discoverServices:nil];
    
}
//扫描
-(void)ScanDevice:(int)timeout{
    [_Manager scanForPeripheralsWithServices:nil options:nil];
    
     [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(stopScanfBluetooth:) userInfo:nil repeats:NO];
}
//停止扫描
-(void)stopScanfBluetooth:(NSTimer *)timer{
    [_Manager stopScan];
    timer = nil;
    
}
//读取数据
-(void)ReadData{
    [_peri readValueForCharacteristic:_readChasra];
    
}



#pragma mark - CoreBluetoothDelegate
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@ %@ %@",peripheral.name,RSSI,peripheral);
    if (![_DeviceList containsObject:peripheral]) {
        [_DeviceList addObject:peripheral];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"%@ %@ %ld",peripheral.name,peripheral.services,(long)peripheral.state);
    _peri = peripheral;
    _peri.delegate = self;
    [self ToDiscoverServiceForperiphral];
}
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    NSLog(@"%@",peripheral.services);
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TCPeriUUID]]) {
            [self.peri discoverCharacteristics:nil forService:service];
}}}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    NSLog(@"%@",error.localizedDescription);
   
    for (CBCharacteristic *chara in service.characteristics) {
        if ([chara.UUID isEqual:[CBUUID UUIDWithString:TCWriteUUID]]) {
            _writeChar = chara;
        }else if([chara.UUID isEqual:[CBUUID UUIDWithString:TCReadUUID]]){
            _readChasra = chara;
        }
    }
        
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error)
        NSLog(@"%@",error.localizedDescription);
    [_readData appendData:_readChasra.value];
    NSLog(@"%@",_readData);
}


-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch(central.state){
      case CBManagerStateUnknown:
            break;
        case CBManagerStatePoweredOn:{
            NSLog(@"蓝牙可以扫描");
            break;
        }
        case CBManagerStatePoweredOff:{
            NSLog(@"蓝牙已经关闭");
            break;
        }
        case CBManagerStateResetting:
            break;
        case CBManagerStateUnsupported:
            break;
        case CBManagerStateUnauthorized:
            break;
            
       default:
            break;
    }
}



@end
