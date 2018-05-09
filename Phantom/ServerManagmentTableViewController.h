//
//  ServerManagmentTableViewController.h
//  PangeaIO
//
//  Created by Joseph Shenton on 17/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebUploader.h"
#import "BTBlurredStatusBar.h"
#import "GCDWebDAVServer.h"
#import "SCLAlertView.h"
#import "SSZipArchive.h"
#import <unistd.h>
#import "XMFTPServer.h"
#import "PangeaIO-Swift.h"

@class HTTPServer;

@import SafariServices;

@interface ServerManagmentTableViewController : UITableViewController <UIActionSheetDelegate, SFSafariViewControllerDelegate> {
    HTTPServer *httpServer;
    GCDWebServer* webServer;
    GCDWebUploader* webUploader;
    GCDWebDAVServer* _davServer;
}

@end
