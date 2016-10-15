//
//  ViewController.m
//  BLETest
//
//  Created by shiki on 2016/10/14.
//  Copyright © 2016年 两仪式. All rights reserved.
//

#import "ViewController.h"
#import "BLEutility.h"
@interface ViewController ()<SaberBleProtocol>
@property(nonatomic,strong)BLEutility *BleUt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.BleUt = [BLEutility SharedBLE];
    [_BleUt ScanDevice:100];
    self.BleUt.delegate = self;
}

-(void)didDeviceDisConeect{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"设备已经断开连接" message:@"设备已经断开请重新连接" preferredStyle:1];
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [aler addAction:ac];
    [self presentViewController:aler animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
