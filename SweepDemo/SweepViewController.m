//
//  SweepViewController.m
//  SweepDemo
//
//  Created by lynnjinglei on 15/8/25.
//  Copyright (c) 2015年 XiaoLei. All rights reserved.
//

#import "SweepViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    UIView *borderView;
    UIImageView *lineImageView;
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@end

@implementation SweepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 140, 250, 2)];
    lineImageView.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineImageView];
    
    upOrdown = NO;
    num =0;
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    
    [self setUpCamera];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}
//- (void)lineAnimation
//{
//    if (upOrdown == NO) {
//        num ++;
//        lineImageView.frame = CGRectMake((self.view.frame.size.width - 250)/2, 140+2*num, 250, 2);
//        if (2*num == 250) {
//            upOrdown = YES;
//        }
//    }
//    else {
//        num --;
//        lineImageView.frame = CGRectMake((self.view.frame.size.width - 250)/2, 140+2*num, 250, 2);
//        if (num == 0) {
//            upOrdown = NO;
//        }
//    }
//}
- (void)lineAnimation
{
    num ++;
    lineImageView.frame = CGRectMake((self.view.frame.size.width - 250)/2, 140+2*num, 250, 2);
    if (2*num >= 248) {
        num = 0;
    }
}
- (void)setUpCamera
{
    borderView = [[UIView alloc]init];
    borderView.frame = CGRectMake((self.view.frame.size.width - 250)/2, 140, 250, 250);
    borderView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:152/255.0f alpha:1].CGColor;
    borderView.layer.borderWidth = 2;
    [self.view addSubview:borderView];
    // 获取相机设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(borderView.frame.origin.y/self.view.frame.size.height, borderView.frame.origin.x/self.view.frame.size.width, borderView.frame.size.height/self.view.frame.size.height, borderView.frame.size.width/self.view.frame.size.width);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置代理 在主线程里刷新
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if([session canAddInput:input])
    {
        [session addInput:input];
    }
    if([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    // 设置扫码支持的编码格式
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];//???? addOutput后执行
    //设置相机显示区域
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;//???
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    // 开始捕获
    [session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSLog(@"%@",metadataObject.stringValue);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:metadataObject.stringValue]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
