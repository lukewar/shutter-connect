//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <UIImage-Resize/UIImage+Resize.h>
#import "UploadsViewController.h"
#import "UIImagePickerController+BlocksKit.h"
#import "UploadViewController.h"
#import "ImagesStorage.h"
#import "ImageCollectionViewCell.h"

@interface UploadsViewController () <UploadViewControllerDelegate>

@property(nonatomic, strong) ImagesStorage *_imagesStorage;
@end

@implementation UploadsViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self._imagesStorage = [ImagesStorage new];
    }

    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self._imagesStorage.storedImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCellIdentifier" forIndexPath:indexPath];
    cell.imageView.image = self._imagesStorage.storedImages[(NSUInteger) indexPath.item];
    return cell;
}

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
        uploadViewController.delegate = self;
        uploadViewController.originalImage = pickedImage;
        [weakSelf.navigationController pushViewController:uploadViewController animated:NO];

        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    imagePickerController.bk_didCancelBlock = ^(UIImagePickerController *controller) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UploadViewControllerDelegate

- (void)uploadViewController:(UploadViewController *)viewController didUploadImage:(UIImage *)image
{
    UIImage *thumbnailImage = [image resizedImageToFitInSize:CGSizeMake(image.size.width/10, image.size.height/10) scaleIfSmaller:YES];
    [self._imagesStorage addImage:thumbnailImage];
    [self.collectionView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadViewControllerDidCancel:(UploadViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
