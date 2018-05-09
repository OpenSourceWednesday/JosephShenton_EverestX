//
//  StepsViewController.m
//  PangeaIO
//
//  Created by Felon on 10/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "StepsViewController.h"

@interface StepsViewController ()

@end

@implementation StepsViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //    (iOS 5)
    //    Only allow rotation to portrait
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    //    (iOS 6)
    //    No auto rotating
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    (iOS 6)
    //    Only allow rotation to portrait
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    (iOS 6)
    //    Force to portrait
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
