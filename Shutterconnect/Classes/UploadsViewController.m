//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "UploadsViewController.h"
#import "UIImagePickerController+BlocksKit.h"
#import "UploadViewController.h"

@interface UploadsViewController ()

@end

@implementation UploadsViewController

#pragma Actions

- (IBAction)uploadButtonTapped:(id)sender
{
    NSAssert([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary], @"This method should not be called on devices not supporting photo library.");

    WEAK_SELF
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *controller, NSDictionary *dictionary) {

        UIImage *pickedImage = dictionary[UIImagePickerControllerOriginalImage];

        UploadViewController *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:UploadViewControllerIdentifier];
        uploadViewController.originalImage = pickedImage;
        [weakSelf.navigationController pushViewController:uploadViewController animated:NO];

        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    imagePickerController.bk_didCancelBlock = ^(UIImagePickerController *controller) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

@end
