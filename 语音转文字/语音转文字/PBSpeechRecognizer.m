//
//  PBSpeechRecognizer.m
//  语音识别2
//
//  Created by 卢华 on 2018/12/22.
//  Copyright © 2018年 于天琦. All rights reserved.
//

#import "PBSpeechRecognizer.h"
#import <Speech/Speech.h>

API_AVAILABLE(ios(10.0))
@interface PBSpeechRecognizer()
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@end
@implementation PBSpeechRecognizer

- (void)startResultStr:(void(^)(NSString *str))strBlock {
    if (!self.speechRecognizer) {
        // 设置语言
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        if (@available(iOS 10.0, *)) {
            self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
        } else {
            // Fallback on earlier versions
        }
    }
    if (!self.audioEngine) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (@available(iOS 10.0, *)) {
        [audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    } else {
        // Fallback on earlier versions
    }
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (self.recognitionRequest) {
        [self.recognitionRequest endAudio];
        self.recognitionRequest = nil;
    }
    if (@available(iOS 10.0, *)) {
        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    } else {
        // Fallback on earlier versions
    }
    self.recognitionRequest.shouldReportPartialResults = YES; // 实时翻译
    if (@available(iOS 10.0, *)) {
        [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (result.isFinal) {
                strBlock(result.bestTranscription.formattedString);
                
//                NSLog(@"is final: %d  result: %@", result.isFinal, result.bestTranscription.formattedString);
                
                if ([self.delegate respondsToSelector:@selector(recognitionSuccess:)]) {
                    [self.delegate recognitionSuccess:result.bestTranscription.formattedString];
                }
            }else {
                if ([self.delegate respondsToSelector:@selector(recognitionFail:)]) {
                    //                    [self.delegate recognitionFail:error.domain];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    AVAudioFormat *recordingFormat = [[self.audioEngine inputNode] outputFormatForBus:0];
    [[self.audioEngine inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
}
- (void)stopR {
    [[self.audioEngine inputNode] removeTapOnBus:0];
    [self.audioEngine stop];
    [self.recognitionRequest endAudio];
    self.recognitionRequest = nil;
}
@end
