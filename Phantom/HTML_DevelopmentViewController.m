//
//  News_UpdatesViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "HTML_DevelopmentViewController.h"

@interface HTML_DevelopmentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation HTML_DevelopmentViewController

@synthesize webview;

- (void)viewDidLoad {

    [super viewDidLoad];
    // https://ecstatic-swirles-15c5b7.netlify.com
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"viewCourse"] isEqual: @"FrontEnd"]) {
        NSURL *targetURL = [NSURL URLWithString:@"https://ecstatic-swirles-15c5b7.netlify.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [webview loadRequest:request];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"viewCourse"] isEqual: @"PHP"]) {
        NSURL *targetURL = [NSURL URLWithString:@"https://gracious-murdock-b7582d.netlify.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [webview loadRequest:request];
    }

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
