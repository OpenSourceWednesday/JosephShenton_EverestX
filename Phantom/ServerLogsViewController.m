
//
//  ServerLogsViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "ServerLogsViewController.h"

@interface ServerLogsViewController ()

@end

@implementation ServerLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.navigationController.navigationBar.layer.shadowRadius = 12;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.12;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* content2 = [NSString stringWithContentsOfFile:[documentsPath stringByAppendingString:@"/logs.txt"] encoding:NSUTF8StringEncoding error:NULL];
    
    _logsTextView.text = content2;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeLogs:(id)sender {
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
