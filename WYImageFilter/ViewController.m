//
//  ViewController.m
//  WYImageFilter
//
//  Created by 王启镰 on 16/5/23.
//  Copyright © 2016年 wanglijinrong. All rights reserved.
//

#import "GPUImage.h"
#import "ViewController.h"

#define VIDEO_RECT CGRectMake(40, 64, 240, 320)


@implementation ViewController
{
    GPUImageStillCamera *_stillCamera;  /// 照相机
    GPUImageView        *_frameView;    /// 图像框
    GPUImageBeautifyFilter *_beautifyFilter; /// 美颜滤镜
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self beautifyVideo];
    
}

- (void)beautifyVideo {
    _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _beautifyFilter = [GPUImageBeautifyFilter new];
    _frameView      = [[GPUImageView alloc] initWithFrame:VIDEO_RECT];
    
    [_beautifyFilter addTarget:_frameView];
    [_stillCamera addTarget:_beautifyFilter];
    
    [self.view addSubview:_frameView];
    [_stillCamera startCameraCapture];
}


- (IBAction)takePhotoBtnClick {
    [_stillCamera capturePhotoAsPNGProcessedUpToFilter:_beautifyFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        if (error) NSLog(@"error = %@", error);
        
        UIImage *image = [UIImage imageWithData:processedPNG];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIDEO_RECT];
        imageView.image = image;
        [self.view addSubview:imageView];
        
        NSLog(@"image = %@", image);
        NSLog(@"currentThread = %@", [NSThread currentThread]);
    }];
}

@end
