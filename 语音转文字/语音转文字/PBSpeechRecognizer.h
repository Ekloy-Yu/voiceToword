//
//  PBSpeechRecognizer.h
//  语音识别2
//
//  Created by 卢华 on 2018/12/22.
//  Copyright © 2018年 于天琦. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PBSpeechRecognizerProtocol <NSObject>

@optional

- (void)recognitionSuccess:(NSString *)result;
- (void)recognitionFail:(NSString *)result;

@end

@interface PBSpeechRecognizer : NSObject

@property(nonatomic,weak) id<PBSpeechRecognizerProtocol> delegate;

- (void)startResultStr:(void(^)(NSString *str))strBlock;
- (void)stopR;

@end

NS_ASSUME_NONNULL_END
