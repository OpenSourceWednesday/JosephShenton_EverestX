//
//  IQSelectedMediaViewController.m
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


@import AVFoundation;
@import AVKit;

#import "IQSelectedMediaViewController.h"
#import "IQMediaCaptureController.h"
#import "IQSelectedMediaAudioCell.h"
#import "IQSelectedMediaVideoCell.h"
#import "IQSelectedMediaPhotoCell.h"
#import "IQImagePreviewViewController.h"

@interface IQSelectedMediaViewController ()

@end

@implementation IQSelectedMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    UICollectionViewFlowLayout *_flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    _flowLayout.minimumLineSpacing = _flowLayout.minimumInteritemSpacing = 1.0f;
    
    NSUInteger numberOfItemsPerRow = 3;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        numberOfItemsPerRow = 10;
    }
    
    CGFloat minWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    CGFloat size = (minWidth - (_flowLayout.minimumLineSpacing * (numberOfItemsPerRow+1)))/numberOfItemsPerRow;
    _flowLayout.itemSize =  CGSizeMake(size, size);

    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[IQSelectedMediaAudioCell class] forCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaAudioCell class])];
    [self.collectionView registerClass:[IQSelectedMediaVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaVideoCell class])];
    [self.collectionView registerClass:[IQSelectedMediaPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaPhotoCell class])];
    
    UIBarButtonItem *retakeItem = nil;
    
    if (self.mediaCaptureController.allowsCapturingMultipleItems)
    {
        retakeItem = [[UIBarButtonItem alloc] initWithTitle:@"Take more" style:UIBarButtonItemStyleDone target:self action:@selector(takeMoreAction:)];
    }
    else
    {
        retakeItem = [[UIBarButtonItem alloc] initWithTitle:@"Retake" style:UIBarButtonItemStyleDone target:self action:@selector(retakeAction:)];
    }
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
    
    self.toolbarItems = @[retakeItem,flexItem,selectItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];

    NSUInteger itemCount = self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count;
    self.navigationItem.title = [NSString stringWithFormat:@"%lu selected",(unsigned long)itemCount];

    NSInteger section = [self.collectionView numberOfSections] - 1;
    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
    
    if (section >= 0 && item >= 0)
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        
        [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Photo
    if (indexPath.item < self.arrayImagesAttribute.count)
    {
        NSUInteger index = indexPath.item;

        IQSelectedMediaPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaPhotoCell class]) forIndexPath:indexPath];
        cell.imageAttributes = self.arrayImagesAttribute[index];
        
        return cell;
    }
    //Video
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count;

        IQSelectedMediaVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaVideoCell class]) forIndexPath:indexPath];
        cell.fileURL = self.videoURLs[index];
        
        return cell;
    }
    //Audio
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count - self.videoURLs.count;
    
        IQSelectedMediaAudioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IQSelectedMediaAudioCell class]) forIndexPath:indexPath];
        cell.fileURL = self.audioURLs[index];
        
        return cell;
    }
    else
    {
        return [UICollectionViewCell new];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    BOOL shouldShow = (action == @selector(delete:));
    return shouldShow;
}

-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    //Photo
    if (indexPath.item < self.arrayImagesAttribute.count)
    {
        NSUInteger index = indexPath.item;
        [self.arrayImagesAttribute removeObjectAtIndex:index];
        NSUInteger itemCount = self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count;
        self.navigationItem.title = [NSString stringWithFormat:@"%lu selected",(unsigned long)itemCount];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    //Video
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count;
        [self.videoURLs removeObjectAtIndex:index];
        NSUInteger itemCount = self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count;
        self.navigationItem.title = [NSString stringWithFormat:@"%lu selected",(unsigned long)itemCount];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    //Audio
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count - self.videoURLs.count;
        [self.audioURLs removeObjectAtIndex:index];
        NSUInteger itemCount = self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count;
        self.navigationItem.title = [NSString stringWithFormat:@"%lu selected",(unsigned long)itemCount];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Photo
    if (indexPath.item < self.arrayImagesAttribute.count)
    {
        IQSelectedMediaPhotoCell *cell = (IQSelectedMediaPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];

        IQImagePreviewViewController *previewController = [[IQImagePreviewViewController alloc] init];
        previewController.liftedImageView = cell.imageViewPreview;
        [previewController showOverController:self.navigationController];
    }
    //Video
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count;
        
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:_videoURLs[index]];
        controller.player = player;
        [self presentViewController:controller animated:YES completion:^{
            [player play];
        }];
    }
    //Audio
    else if (indexPath.item < (self.arrayImagesAttribute.count + self.videoURLs.count + self.audioURLs.count))
    {
        NSUInteger index = indexPath.item - self.arrayImagesAttribute.count - self.videoURLs.count;

        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:_audioURLs[index]];
        controller.player = player;
        [self presentViewController:controller animated:YES completion:^{
            [player play];
        }];
    }
}



-(void)takeMoreAction:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)retakeAction:(UIBarButtonItem*)sender
{
    [_videoURLs removeAllObjects];
    [_audioURLs removeAllObjects];
    [_arrayImagesAttribute removeAllObjects];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneAction:(UIBarButtonItem*)sender
{
    if ([self.mediaCaptureController.delegate respondsToSelector:@selector(mediaCaptureController:didFinishMediaWithInfo:)])
    {
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        
        if ([self.arrayImagesAttribute count])
        {
            [info setObject:self.arrayImagesAttribute forKey:IQMediaTypeImage];
        }
        
        if ([self.videoURLs count])
        {
            NSMutableArray *videoMedias = [[NSMutableArray alloc] init];
            
            for (NSURL *videoURL in self.videoURLs)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:videoURL forKey:IQMediaURL];
                [videoMedias addObject:dict];
            }
            
            [info setObject:videoMedias forKey:IQMediaTypeVideo];
        }
        
        if ([self.audioURLs count])
        {
            NSMutableArray *audioMedias = [[NSMutableArray alloc] init];
            
            for (NSURL *audioURL in self.audioURLs)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:audioURL forKey:IQMediaURL];
                [audioMedias addObject:dict];
            }
            
            [info setObject:audioMedias forKey:IQMediaTypeAudio];
        }
        
        [self.mediaCaptureController.delegate mediaCaptureController:self.mediaCaptureController didFinishMediaWithInfo:info];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
