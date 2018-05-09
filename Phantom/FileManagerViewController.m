//
//  FileManagerViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "FileManagerViewController.h"

@interface FileManagerViewController ()

@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCodeEditor) name:@"showCodeEditor" object:nil];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCodeEditor {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"codeEditor"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)newFile_Folder:(id)sender {
    [self showAssetOptions];
}

- (void)showAssetOptions {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    __block SCLAlertView *blockAlert = alert;
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button2 = [alert addButton:@"Create File" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"example.html"];
        
        SCLButton *button = [alert addButton:@"Named!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            
            NSDictionary* userInfo = @{@"filename": [NSString stringWithFormat:@"%@", textField.text]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createNewFile" object:nil userInfo:userInfo];
            NSLog(@"Text value: %@", textField.text);
            
            
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Create File" subTitle:@"Give your new file a name & extension!" closeButtonTitle:nil duration:0.0f];
    }];
    
    button2.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *importButton = [alert addButton:@"Import File" actionBlock:^(void) {
        [blockAlert hideView];
//        UIDocumentMenuViewController *importMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:[self UTIs] inMode:UIDocumentPickerModeImport];
        
        NSArray *fileTypes = @[@"public.item"];
        
        UIDocumentMenuViewController *importMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:fileTypes inMode:UIDocumentPickerModeImport];
        
        importMenu.delegate = self;
        
        [self presentViewController:importMenu animated:YES completion:nil];

    }];
    
    importButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *importFrameworkButton = [alert addButton:@"Import Framework" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        SCLButton *f7 = [alert addButton:@"Framework7" actionBlock:^(void) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"importFramework7" object:nil userInfo:nil];
        }];
        
        f7.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *jquery = [alert addButton:@"jQuery" actionBlock:^(void) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"importjQuery" object:nil userInfo:nil];
        }];
        
        jquery.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *bootstrap = [alert addButton:@"Bootstrap" actionBlock:^(void) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"importBootstrap" object:nil userInfo:nil];
        }];
        
        bootstrap.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Import Framework" subTitle:@"Import a framework!" closeButtonTitle:nil duration:0.0f];
        
    }];
    
    importFrameworkButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *button1 = [alert addButton:@"Create Folder" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        UITextField *textField = [alert addTextField:@"Folder Name"];
        
        SCLButton *button = [alert addButton:@"Named!"  validationBlock:^BOOL{
            if (textField.text.length == 0)
            {
                
                return NO;
            }
            return YES;
        } actionBlock:^{
            NSLog(@"%@", textField.text);
            NSDictionary* userInfo = @{@"foldername": [NSString stringWithFormat:@"%@", textField.text]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createNewFolder" object:nil userInfo:userInfo];
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, nevermind!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showEdit:self title:@"Create Folder" subTitle:@"Give your new folder a name!" closeButtonTitle:nil duration:0.0f];
    }];
    
    button1.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.72 green:0.38 blue:1.00 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    SCLButton *button3 = [alert addButton:@"Nevermind!" actionBlock:^(void) {
        
    }];
    
    button3.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        return buttonConfig;
    };
    
    alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
    
    alert.iconTintColor = [UIColor whiteColor];
    
    [alert showNotice:self title:@"New Asset" subTitle:@"Create new asset" closeButtonTitle:nil duration:0.0f];
}

-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    
    documentPicker.delegate = self;
    
    [self presentViewController:documentPicker animated:YES completion:nil];
    
}

/**
 *  This delegate method is called when user will either upload or download the file.
 *
 *  @param controller UIDocumentPickerViewController object
 *  @param url        url of the file
 */

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        
        // Condition called when user download the file
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        // NSData of the content that was downloaded - Use this to upload on the server or save locally in directory
        NSDictionary* userInfo = @{@"filename": [NSString stringWithFormat:@"%@", [url lastPathComponent]], @"filedata": fileData};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"importFile" object:nil userInfo:userInfo];
        //Showing alert for success
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.backgroundType = SCLAlertViewBackgroundBlur;
            
            SCLButton *button3 = [alert addButton:@"Super!" actionBlock:^(void) {
                
            }];
            
            button3.buttonFormatBlock = ^NSDictionary* (void)
            {
                NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
                
                buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
                buttonConfig[@"textColor"] = [UIColor whiteColor];
                
                return buttonConfig;
            };
            
            alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
            
            alert.iconTintColor = [UIColor whiteColor];
            
            [alert showNotice:@"Success!" subTitle:[NSString stringWithFormat:@"Successfully imported\n\"%@\"", [url lastPathComponent]] closeButtonTitle:nil duration:0.0f];
            
//            NSString *alertMessage = [NSString stringWithFormat:@"Successfully downloaded file %@", [url lastPathComponent]];
//            UIAlertController *alertController = [UIAlertController
//                                                  alertControllerWithTitle:@"UIDocumentView"
//                                                  message:alertMessage
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }else  if (controller.documentPickerMode == UIDocumentPickerModeExportToService)
    {
        // Called when user uploaded the file - Display success alert
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertMessage = [NSString stringWithFormat:@"Successfully uploaded file %@", [url lastPathComponent]];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"UIDocumentView"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
    
}

/**
 *  Delegate called when user cancel the document picker
 *
 *  @param controller - document picker object
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    
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
