//
//  News_UpdatesViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "News_UpdatesViewController.h"

@interface News_UpdatesViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation News_UpdatesViewController

@synthesize webview;

- (void)viewDidLoad {

    [super viewDidLoad];
    // https://adoring-cray-2e4b04.netlify.com
    
    NSURL *targetURL = [NSURL URLWithString:@"https://adoring-cray-2e4b04.netlify.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webview loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeNews_Updates:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
