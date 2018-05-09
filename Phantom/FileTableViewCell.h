//
//  FileTableViewCell.h
//  PangeaIO
//
//  Created by Joseph Shenton on 16/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileType;
@property (weak, nonatomic) IBOutlet UIButton *fileControl;

@end
