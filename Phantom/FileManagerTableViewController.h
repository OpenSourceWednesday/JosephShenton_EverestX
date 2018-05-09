//
//  FileManagerTableViewController.h
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import "SSZipArchive.h"
#import "UnrarKit.h"

@interface FileManagerTableViewController : UITableViewController

@end

static NSArray *currentPath;
static NSArray *paths;
static NSString *currentFolder;
