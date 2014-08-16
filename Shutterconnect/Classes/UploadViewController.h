//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const UploadViewControllerIdentifier;

@protocol UploadViewControllerDelegate;

@interface UploadViewController : UIViewController

@property(nonatomic, weak) id <UploadViewControllerDelegate> delegate;

@property(nonatomic, strong) UIImage *originalImage;

@end

@protocol UploadViewControllerDelegate <NSObject>

- (void)uploadViewController:(UploadViewController *)viewController didUploadImage:(UIImage *)image;

- (void)uploadViewControllerDidCancel:(UploadViewController *)viewController;

@end
