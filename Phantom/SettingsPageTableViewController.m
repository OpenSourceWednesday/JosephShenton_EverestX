//
//  SettingsPageTableViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 3/3/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "SettingsPageTableViewController.h"

@interface SettingsPageTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *themeName;
@property (weak, nonatomic) IBOutlet UILabel *liveDeployStatus;

@end

@implementation SettingsPageTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getThemeName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)getThemeName {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"editorTheme"] != nil) {
        NSString *themeName = [defaults objectForKey:@"editorTheme"];
        themeName = [themeName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        themeName = themeName.capitalizedString;
        _themeName.text = themeName;
    } else {
        NSString *themeName = @"atom-one-dark";
        themeName = [themeName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        themeName = themeName.capitalizedString;
        _themeName.text = themeName;
        [defaults setObject:@"atom-one-dark" forKey:@"editorTheme"];
        [defaults synchronize];
    }
}

- (IBAction)themeOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showThemes" object:nil];
}

- (IBAction)liveDeployOptions:(id)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
