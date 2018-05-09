//
//  IQVideoSettingsContainerView.h
//  https://github.com/hackiftekhar/IQMediaPickerController
//  Copyright (c) 2017 Iftekhar Qurashi.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


@import UIKit;
@import AVFoundation;

#import "IQCaptureSession.h"

@class IQVideoSettingsContainerView;

@protocol IQVideoSettingsContainerViewDelegate <NSObject>

-(void)videoSettingsView:(IQVideoSettingsContainerView*)settingsView didChangeTorchMode:(AVCaptureTorchMode)torchMode;
-(void)videoSettingsViewFlippedCamera:(IQVideoSettingsContainerView*)settingsView;
-(void)videoSettingsView:(IQVideoSettingsContainerView*)settingsView didChangeVideoPreset:(IQCaptureSessionPreset)videoPreset;

@end

@interface IQVideoSettingsContainerView : UIView

@property(nonatomic, weak) id<IQVideoSettingsContainerViewDelegate> delegate;

@property(nonatomic) IQCaptureSessionPreset videoPreset;

@property(nonatomic) NSArray <NSNumber*>* preferredPreset;
@property(nonatomic, readonly) NSArray <NSNumber*>* supportedPreset;

@property(nonatomic) AVCaptureTorchMode torchMode;
@property(nonatomic) BOOL hasTorch;

@property(nonatomic) BOOL hasCamera;

@property(nonatomic) NSTimeInterval duration;
@property(nonatomic) long long fileSize;

@property(nonatomic) BOOL recording;

-(void)resetUI;

@end
