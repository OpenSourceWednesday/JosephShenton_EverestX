//
//  DocumentActionViewController.m
//  ImportFilesUI
//
//  Created by Joseph Shenton on 18/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "DocumentActionViewController.h"

@interface DocumentActionViewController()
    @property (weak) IBOutlet UILabel *identifierLabel;
    @property (weak) IBOutlet UILabel *actionTypeLabel;
@end

@implementation DocumentActionViewController

- (void)prepareForActionWithIdentifier:(NSString *)actionIdentifier itemIdentifiers:(NSArray <NSFileProviderItemIdentifier> *)itemIdentifiers {
    self.identifierLabel.text = actionIdentifier;
    self.actionTypeLabel.text = @"Custom action";
}
    
- (void)prepareForError:(NSError *)error {
    self.identifierLabel.text = error.localizedDescription;
    self.actionTypeLabel.text = @"Error";
}

- (IBAction)doneButtonTapped:(id)sender {
    // Perform the action and call the completion block. If an unrecoverable error occurs you must still call the completion block with an error. Use the error code FPUIExtensionErrorCodeFailed to signal the failure.
    [self.extensionContext completeRequest];
}
    
- (IBAction)cancelButtonTapped:(id)sender {
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:FPUIErrorDomain code:FPUIExtensionErrorCodeUserCancelled userInfo:nil]];
}

@end

