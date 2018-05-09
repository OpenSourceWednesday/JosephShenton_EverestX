//
//  IQMediaPickerController.m
//  https://github.com/hackiftekhar/IQMediaPickerController
//  Copyright (c) 2013-17 Iftekhar Qurashi.
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


#import "IQMediaPickerController.h"
#import "IQMediaCaptureController.h"
#import "IQAssetsPickerController.h"
#import "IQAudioPickerController.h"
#import "IQMediaPickerControllerConstants.h"
#import "IQCaptureSession.h"

@interface IQMediaPickerController ()<IQMediaCaptureControllerDelegate,IQAssetsPickerControllerDelegate,IQAudioPickerControllerDelegate,UITabBarControllerDelegate>

@property BOOL isFirstTimeAppearing;

@end

@implementation IQMediaPickerController

@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirstTimeAppearing = YES;
}

-(void)setMediaTypes:(NSArray<NSNumber *> *)mediaTypes
{
    _mediaTypes = [[NSMutableOrderedSet orderedSetWithArray:mediaTypes] array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isFirstTimeAppearing)
    {
        self.isFirstTimeAppearing = NO;

        if (self.mediaTypes.count == 0)
        {
            self.mediaTypes = @[@(IQMediaPickerControllerMediaTypePhoto)];
        }
        
        switch (self.sourceType)
        {
            case IQMediaPickerControllerSourceTypeLibrary:
            {
                if ([self.mediaTypes containsObject:@(IQMediaPickerControllerMediaTypePhoto)] ||
                    [self.mediaTypes containsObject:@(IQMediaPickerControllerMediaTypeVideo)])
                {
                    IQAssetsPickerController *controller = [[IQAssetsPickerController alloc] init];
                    controller.allowsPickingMultipleItems = self.allowsPickingMultipleItems;
                    controller.maximumItemCount = self.maximumItemCount;
                    controller.delegate = self;
                    controller.mediaTypes = self.mediaTypes;
                    self.viewControllers = @[controller];
                }
                else if ([self.mediaTypes containsObject:@(IQMediaPickerControllerMediaTypeAudio)])
                {
                    IQAudioPickerController *controller = [[IQAudioPickerController alloc] init];
                    controller.allowsPickingMultipleItems = self.allowsPickingMultipleItems;
                    controller.maximumItemCount = self.maximumItemCount;
                    controller.delegate = self;
                    self.viewControllers = @[controller];
                }
            }
                break;
            case IQMediaPickerControllerSourceTypeCameraMicrophone:
            {
                IQMediaCaptureController *controller = [[IQMediaCaptureController alloc] init];
                controller.allowsCapturingMultipleItems = self.allowsPickingMultipleItems;
                controller.maximumItemCount = self.maximumItemCount;
                controller.delegate = self;
                controller.mediaTypes = self.mediaTypes;
                controller.captureDevice = self.captureDevice;
//                controller.flashMode = self.flashMode;
                controller.videoMaximumDuration = self.videoMaximumDuration;
                controller.audioMaximumDuration = self.audioMaximumDuration;
                controller.allowedVideoQualities = self.allowedVideoQualities;
                self.viewControllers = @[controller];
            }
                break;
        }
    }
}

- (void)takePicture
{
    IQMediaCaptureController *controller = [self.viewControllers firstObject];
    
    if ([controller isKindOfClass:[IQMediaCaptureController class]])
    {
        [controller takePicture];
    }
}

- (BOOL)startVideoCapture
{
    IQMediaCaptureController *controller = [self.viewControllers firstObject];
    
    if ([controller isKindOfClass:[IQMediaCaptureController class]])
    {
        return [controller startVideoCapture];
    }
    else
    {
        return NO;
    }
}

- (void)stopVideoCapture
{
    IQMediaCaptureController *controller = [self.viewControllers firstObject];
    
    if ([controller isKindOfClass:[IQMediaCaptureController class]])
    {
        [controller stopVideoCapture];
    }
}

- (BOOL)startAudioCapture
{
    IQMediaCaptureController *controller = [self.viewControllers firstObject];
    
    if ([controller isKindOfClass:[IQMediaCaptureController class]])
    {
        return [controller startAudioCapture];
    }
    else
    {
        return NO;
    }
}

- (void)stopAudioCapture
{
    IQMediaCaptureController *controller = [self.viewControllers firstObject];
    
    if ([controller isKindOfClass:[IQMediaCaptureController class]])
    {
        [controller stopAudioCapture];
    }
}

#pragma mark - Class methods

+ (BOOL)isSourceTypeAvailable:(IQMediaPickerControllerSourceType)sourceType
{
    switch (sourceType) {
        case IQMediaPickerControllerSourceTypeLibrary:
        {
            return YES;
        }
            break;
        case IQMediaPickerControllerSourceTypeCameraMicrophone:
        {
            return [IQCaptureSession supportedVideoCaptureDevices] > 0;
        }
            break;
            
        default:
            return NO;
            break;
    }
}

+ (NSArray <NSNumber*> *)availableMediaTypesForSourceType:(IQMediaPickerControllerSourceType)sourceType
{
    if ([self isSourceTypeAvailable:sourceType])
    {
        switch (sourceType) {
            case IQMediaPickerControllerSourceTypeLibrary:
            {
                return @[@(IQMediaPickerControllerMediaTypeAudio),@(IQMediaPickerControllerMediaTypePhoto),@(IQMediaPickerControllerMediaTypeVideo)];
            }
                break;
            case IQMediaPickerControllerSourceTypeCameraMicrophone:
            {
                return @[@(IQMediaPickerControllerMediaTypeAudio),@(IQMediaPickerControllerMediaTypePhoto),@(IQMediaPickerControllerMediaTypeVideo)];
            }
                break;
        }
    }
    
    return @[];
}

+ (BOOL)isCameraDeviceAvailable:(IQMediaPickerControllerCameraDevice)cameraDevice
{
    BOOL isCameraDeviceAvailable = NO;
    
    for (AVCaptureDevice *device in [IQCaptureSession supportedVideoCaptureDevices])
    {
        if (cameraDevice == IQMediaPickerControllerCameraDeviceRear && device.position == AVCaptureDevicePositionBack)
        {
            isCameraDeviceAvailable = YES;
            break;
        }
        else if (cameraDevice == IQMediaPickerControllerCameraDeviceFront && device.position == AVCaptureDevicePositionFront)
        {
            isCameraDeviceAvailable = YES;
            break;
        }
    }
    
    return isCameraDeviceAvailable;
}

+ (BOOL)isFlashAvailableForCameraDevice:(IQMediaPickerControllerCameraDevice)cameraDevice
{
    BOOL hasFlash = NO;
    
    for (AVCaptureDevice *device in [IQCaptureSession supportedVideoCaptureDevices])
    {
        if (cameraDevice == IQMediaPickerControllerCameraDeviceRear && device.position == AVCaptureDevicePositionBack)
        {
            hasFlash = device.hasFlash;
            break;
        }
        else if (cameraDevice == IQMediaPickerControllerCameraDeviceFront && device.position == AVCaptureDevicePositionFront)
        {
            hasFlash = device.hasFlash;
            break;
        }
    }
    
    return hasFlash;
}


#pragma mark - Orientation

-(BOOL)shouldAutorotate
{
    UIViewController *topController = [self topViewController];
    
    if (topController)
    {
        return [topController shouldAutorotate];
    }
    else
    {
        return NO;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController *topController = [self topViewController];
    
    if (topController)
    {
        return [topController supportedInterfaceOrientations];
    }
    else
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

#pragma mark - IQMediaCaptureControllerDelegate
- (void)mediaCaptureController:(IQMediaCaptureController*)controller didFinishMediaWithInfo:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerController:didFinishMediaWithInfo:)])
    {
        [self.delegate mediaPickerController:self didFinishMediaWithInfo:info];
    }
}

- (void)mediaCaptureControllerDidCancel:(IQMediaCaptureController *)controller
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerControllerDidCancel:)])
    {
        [self.delegate mediaPickerControllerDidCancel:self];
    }
}

#pragma mark - IQAssetsPickerControllerDelegate
- (void)assetsPickerController:(IQAssetsPickerController*)controller didFinishMediaWithInfo:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerController:didFinishMediaWithInfo:)])
    {
        [self.delegate mediaPickerController:self didFinishMediaWithInfo:info];
    }
}

- (void)assetsPickerControllerDidCancel:(IQAssetsPickerController *)controller
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerControllerDidCancel:)])
    {
        [self.delegate mediaPickerControllerDidCancel:self];
    }
}

#pragma mark - IQAudioPickerControllerDelegate
- (void)audioPickerController:(IQAudioPickerController *)mediaPicker didPickMediaItems:(NSArray*)mediaItems
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerController:didFinishMediaWithInfo:)])
    {
        NSDictionary *info = [NSDictionary dictionaryWithObject:mediaItems forKey:IQMediaTypeAudio];
        
        [self.delegate mediaPickerController:self didFinishMediaWithInfo:info];
    }
}

- (void)audioPickerControllerDidCancel:(IQAudioPickerController *)mediaPicker
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerControllerDidCancel:)])
    {
        [self.delegate mediaPickerControllerDidCancel:self];
    }
}

@end

