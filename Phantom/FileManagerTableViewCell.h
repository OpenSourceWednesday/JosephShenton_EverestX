//
//  FileManagerTableViewCell.h
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *folderName;
@property (weak, nonatomic) IBOutlet UIButton *folderControl;

@end
