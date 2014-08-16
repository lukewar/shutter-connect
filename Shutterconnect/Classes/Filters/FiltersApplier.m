//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import "FiltersApplier.h"


@implementation FiltersApplier

- (UIImage *)applyFilters:(NSArray *)filters toImage:(UIImage *)sourceImage
{
    if (filters.count == 0 || sourceImage == nil) {
        return sourceImage;
    }

    CIImage *ciFilteredImage = [[CIImage alloc] initWithCGImage:sourceImage.CGImage options:nil];
    for (CIFilter *filter in filters) {
        [filter setValue:ciFilteredImage forKey:@"inputImage"];
        @try {
            ciFilteredImage = filter.outputImage;
        }
        @catch (NSException *e) {}
    }

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:ciFilteredImage fromRect:ciFilteredImage.extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:imgRef scale:1.0
                                                  orientation:sourceImage.imageOrientation];
    CGImageRelease(imgRef);
    return filteredImage;
}

- (void)applyFilters:(NSArray *)filters toImage:(UIImage *)sourceImage withCompletion:(void (^)(UIImage *))completion
{
    WEAK_SELF
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        typeof(self) strongSelf = weakSelf;
        UIImage *filteredImage = [strongSelf applyFilters:filters toImage:sourceImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(filteredImage);
            }
        });
    });
}

@end
