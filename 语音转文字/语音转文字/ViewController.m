//
//  ViewController.m
//  语音识别2
//
//  Created by 卢华 on 2018/12/22.
//  Copyright © 2018年 于天琦. All rights reserved.
//

#import "ViewController.h"
#import "PBSpeechRecognizer.h"
#import <Speech/Speech.h>

@interface ViewController ()<PBSpeechRecognizerProtocol>

@property (nonatomic, strong) PBSpeechRecognizer *speech;
@property (nonatomic, strong) UIButton *soundButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            NSLog(@"status %@", status == SFSpeechRecognizerAuthorizationStatusAuthorized ? @"授权成功" : @"授权失败");
        }];
    } else {
        
    }
    
    _speech = [[PBSpeechRecognizer alloc] init];
    _speech.delegate = self;
    /// 语音开始按钮
    _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _soundButton.frame = CGRectMake(100, 400, 100, 100);
    _soundButton.backgroundColor = [UIColor redColor];
    [_soundButton addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchDown];
    [_soundButton addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:_soundButton];
    
}

- (void)startRecording:(UIButton *)obj {
    [_speech startResultStr:^(NSString * _Nonnull str) {
        NSLog(@"%@", str);
    }];
}
- (void)stopRecording:(UIButton *)obj {
    [_speech stopR];
}
- (void)recognitionSuccess:(NSString *)result {
    NSLog(@"识别。。。");
}

@end
