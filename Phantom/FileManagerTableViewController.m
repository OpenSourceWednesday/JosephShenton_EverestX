//
//  FileManagerTableViewController.m
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "FileManagerTableViewController.h"
#import "FileTableViewCell.h"
#import "FileManagerTableViewCell.h"
#import "BFRImageViewController.h"

@interface FileManagerTableViewController ()

@end

@implementation FileManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createFile:) name:@"createNewFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createFolder:) name:@"createNewFolder" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFile:) name:@"importFile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFramework7:) name:@"importFramework7" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importjQuery:) name:@"importjQuery" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importBootstrap:) name:@"importBootstrap" object:nil];
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    currentFolder = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"currentFolder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    paths = [self listFileAtPath:documentsDirectory];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.tableView addGestureRecognizer:swipeDown];
    // [documentsDirectory stringByAppendingPathComponent:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
        
//        stringByDeletingLastPathComponent
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
        [self loadPreviousDirectory:[currentFolder stringByDeletingLastPathComponent]];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swipe Down");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [paths count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = [paths objectAtIndex:indexPath.row];
    
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSString *searchFile = [documentsDirectory stringByAppendingPathComponent:name];
    
    NSLog(@"%@", searchFile);
    
    BOOL isDir = NO;
    if([[NSFileManager defaultManager]
        fileExistsAtPath:searchFile isDirectory:&isDir] && isDir){
        NSLog(@"Is directory LIST");
        FileManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"folderCell" forIndexPath:indexPath];
        
        cell.folderName.text = name;
        
        [cell.folderControl addTarget:self action:@selector(showFolderOptions:) forControlEvents:UIControlEventTouchUpInside];
    
        [cell.folderControl.layer setValue:name forKey:@"folderName"];//you can set as many of these as you'd like too!
        
        return cell;
    } else {
        FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell" forIndexPath:indexPath];
        cell.fileType.text = [NSString stringWithFormat:@"%@ File", [[name pathExtension] uppercaseString]];
        cell.fileName.text = name;
        [cell.fileControl addTarget:self action:@selector(showFileOptions:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fileControl.layer setValue:name forKey:@"fileName"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = [paths objectAtIndex:indexPath.row];
    
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSString *searchFile = [documentsDirectory stringByAppendingPathComponent:name];
    
    NSLog(@"%@", searchFile);
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isDir = NO;
    if([[NSFileManager defaultManager]
        fileExistsAtPath:searchFile isDirectory:&isDir] && isDir){
        NSLog(@"Is directory");
        [self loadNewDirectory:name];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:searchFile forKey:@"currentFile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:searchFile forKey:@"1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"1Name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"currentFileName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([name.pathExtension.lowercaseString isEqual: @"png"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
            
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"jpg"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
                                               
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"gif"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
            
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"ico"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
            
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"jpeg"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
            
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"pdf"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:searchFile];
            
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
            
            [self presentViewController:imageVC animated:YES completion:nil];
        } else if ([name.pathExtension.lowercaseString isEqual: @"zip"]) {
            NSString *zipPath = searchFile;
            [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
            [self.tableView reloadData];
        } else if ([name.pathExtension.lowercaseString isEqual: @"rar"]) {
            NSError *archiveError = nil;
            URKArchive *archive = [[URKArchive alloc] initWithPath:searchFile error:&archiveError];
            NSError *error = nil;
            BOOL extractFilesSuccessful = [archive extractFilesTo:currentFolder overwrite:FALSE progress:^(URKFileInfo *currentFile, CGFloat percentArchiveDecompressed) {
                NSLog(@"Extracting %@: %f%% complete", currentFile.filename, percentArchiveDecompressed);
            } error:&error];
            [self.tableView reloadData];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCodeEditor" object:nil];
        }
    
        NSLog(@"Name: %@", name);
        NSLog(@"Search File: %@", searchFile);
    }
    
}

- (void)loadNewDirectory:(NSString *)folderName {
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if (![currentFolder isEqual: @""]) {
        currentFolder = [NSString stringWithFormat:@"%@/%@", currentFolder, folderName];
        
        NSLog(@"%@", currentFolder);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSLog(@"%@", [documentsDirectory stringByAppendingPathComponent:currentFolder]);
        
        paths = [self listFileAtPath:[documentsDirectory stringByAppendingPathComponent:currentFolder]];
        [[NSUserDefaults standardUserDefaults] setObject:[documentsDirectory stringByAppendingPathComponent:currentFolder] forKey:@"currentFolder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    } else {
        currentFolder = [NSString stringWithFormat:@"/%@", folderName];
        
        NSLog(@"%@", currentFolder);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSLog(@"%@", [documentsDirectory stringByAppendingPathComponent:folderName]);
        
        paths = [self listFileAtPath:[documentsDirectory stringByAppendingPathComponent:folderName]];
        [[NSUserDefaults standardUserDefaults] setObject:[documentsDirectory stringByAppendingPathComponent:folderName] forKey:@"currentFolder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
}

- (void)loadPreviousDirectory:(NSString *)folderName {
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    currentFolder = [NSString stringWithFormat:@"%@", folderName];
    
    NSLog(@"%@", currentFolder);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"%@", [documentsDirectory stringByAppendingPathComponent:folderName]);
    
    paths = [self listFileAtPath:[documentsDirectory stringByAppendingPathComponent:folderName]];
    [[NSUserDefaults standardUserDefaults] setObject:[documentsDirectory stringByAppendingPathComponent:folderName] forKey:@"currentFolder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

- (void)createFile:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString *filename = userInfo[@"filename"];
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"%@", documentsDirectory);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    NSString *documentsDirectory2 = [documentsDirectory stringByAppendingString:filename];
    NSString *content = @"";
    NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:documentsDirectory2 contents:fileContents attributes:nil];
    NSLog(@"Text value: %@", filename);
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
//    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)importFramework7:(NSNotification*)notification {
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"%@", documentsDirectory);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"framework7" ofType:@"zip"];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
    //    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)importjQuery:(NSNotification*)notification {
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"%@", documentsDirectory);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"zip"];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
    //    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)importBootstrap:(NSNotification*)notification {
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"%@", documentsDirectory);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"bootstrap" ofType:@"zip"];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:documentsDirectory];
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
    //    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)importFile:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString *filename = userInfo[@"filename"];
    NSString *filedata = userInfo[@"filedata"];
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"%@", documentsDirectory);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    NSString *documentsDirectory2 = [documentsDirectory stringByAppendingString:filename];
    
    NSData *fileContents = filedata;
    [[NSFileManager defaultManager] createFileAtPath:documentsDirectory2 contents:fileContents attributes:nil];
    NSLog(@"Text value: %@", filename);
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
    //    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)createFolder:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString *foldername = userInfo[@"foldername"];
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docs objectAtIndex:0];
    
    if (![currentFolder isEqual: @""]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
    }
    
    NSLog(@"FolderName: %@", foldername);
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    NSString *documentsDirectory2 = [documentsDirectory stringByAppendingString:foldername];
    
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory2 isDirectory:&isDir])
        if(![fileManager createDirectoryAtPath:documentsDirectory2 withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: Create folder failed %@", documentsDirectory2);
    NSLog(@"Text value: %@", foldername);
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", currentFolder);
    
//    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    paths = [self listFileAtPath:documentsDirectory];
    [self.tableView reloadData];
}

- (void)showFolderOptions:(UIButton*)sender {
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
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [docs objectAtIndex:0];
            
            if (![currentFolder isEqual: @""]) {
                documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
            }
            
            NSString *folderName = (NSString *)[sender.layer valueForKey:@"folderName"];
            NSLog(@"FolderName: %@", folderName);
            
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            documentsDirectory = [documentsDirectory stringByAppendingString:folderName];
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            documentsDirectory = [documentsDirectory stringByAppendingString:textField.text];
            NSString *content = @"";
            NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:documentsDirectory contents:fileContents attributes:nil];
            NSLog(@"Text value: %@", textField.text);
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSLog(@"%@", currentFolder);
            
            NSString *documentsDirectory2 = [paths objectAtIndex:0];
            
            paths = [self listFileAtPath:documentsDirectory2];
            [self.tableView reloadData];
            
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
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [docs objectAtIndex:0];
            
            if (![currentFolder isEqual: @""]) {
                documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
            }
            
            NSString *folderName = (NSString *)[sender.layer valueForKey:@"folderName"];
            NSLog(@"FolderName: %@", folderName);
            
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            documentsDirectory = [documentsDirectory stringByAppendingString:folderName];
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            documentsDirectory = [documentsDirectory stringByAppendingString:textField.text];
            
            BOOL isDir;
            NSFileManager *fileManager= [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir])
                if(![fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL])
                    NSLog(@"Error: Create folder failed %@", documentsDirectory);
            NSLog(@"Text value: %@", textField.text);
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            //            currentFolder = [NSString stringWithFormat:@"%@", folderName];
            
            NSLog(@"%@", currentFolder);
            
            NSString *documentsDirectory2 = [paths objectAtIndex:0];
            
            //            NSLog(@"%@", [documentsDirectory2 stringByAppendingPathComponent:folderName]);
            
            paths = [self listFileAtPath:documentsDirectory2];
            [self.tableView reloadData];
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
    
    SCLButton *button4 = [alert addButton:@"Delete Folder" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        SCLButton *button = [alert addButton:@"Yes, hurry up!" actionBlock:^(void) {
            NSFileManager *manager = [NSFileManager defaultManager];
            
            NSError *error = nil;
            
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [docs objectAtIndex:0];
            
            if (![currentFolder isEqual: @""]) {
                documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
            }
            
            NSString *folderName = (NSString *)[sender.layer valueForKey:@"folderName"];
            NSLog(@"FolderName: %@", folderName);
            
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            NSString *documentsDirectory2 = [documentsDirectory stringByAppendingString:folderName];
            
            [manager removeItemAtPath:documentsDirectory2 error:&error];
            
            paths = [self listFileAtPath:documentsDirectory];
            [self.tableView reloadData];

        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, keep it!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showWarning:self title:@"Delete Folder" subTitle:@"Are you sure?" closeButtonTitle:nil duration:0.0f];
    }];
    
    button4.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
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
    
    [alert showNotice:self title:@"Folder Options" subTitle:@"Manage this folder" closeButtonTitle:nil duration:0.0f];
}

- (void)showFileOptions:(UIButton*)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    __block SCLAlertView *blockAlert = alert;
    
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    
    SCLButton *button4 = [alert addButton:@"Delete File" actionBlock:^(void) {
        [blockAlert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        
        SCLButton *button = [alert addButton:@"Yes, hurry up!" actionBlock:^(void) {
            NSFileManager *manager = [NSFileManager defaultManager];
            
            NSError *error = nil;
            
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [docs objectAtIndex:0];
            
            if (![currentFolder isEqual: @""]) {
                documentsDirectory = [documentsDirectory stringByAppendingString:currentFolder];
            }
            
            NSString *fileName = (NSString *)[sender.layer valueForKey:@"fileName"];
            NSLog(@"File Name: %@", fileName);
            
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            NSString *documentsDirectory2 = [documentsDirectory stringByAppendingString:fileName];
            
            [manager removeItemAtPath:documentsDirectory2 error:&error];
            
//            NSString *documentsDirectory2 = [paths objectAtIndex:0];
            
            paths = [self listFileAtPath:documentsDirectory];
            [self.tableView reloadData];
        }];
        
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        SCLButton *button2 = [alert addButton:@"Actually, keep it!" actionBlock:^(void) {
            
        }];
        
        button2.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.38 green:1.00 blue:0.72 alpha:1.0];
            buttonConfig[@"textColor"] = [UIColor whiteColor];
            
            return buttonConfig;
        };
        
        alert.customViewColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.0];
        
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert showWarning:self title:@"Delete File" subTitle:@"Are you sure?" closeButtonTitle:nil duration:0.0f];
    }];
    
    button4.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:1.00 green:0.41 blue:0.38 alpha:1.0];
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
    
    [alert showNotice:self title:@"File Options" subTitle:@"Manage this file" closeButtonTitle:nil duration:0.0f];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(NSArray *)listFileAtPath:(NSString *)path
{
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
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
