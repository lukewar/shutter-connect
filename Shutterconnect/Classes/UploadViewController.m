//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "UploadViewController.h"
#import "FiltersManager.h"
#import "UIImage+Resize.h"

NSString *const UploadViewControllerIdentifier = @"UploadViewControllerIdentifier";

@interface UploadViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong) UIImage *_previewOriginalImage;
@property(nonatomic, strong) FiltersManager *_filtersManager;

@end

@implementation UploadViewController



#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        __filtersManager = [FiltersManager new];

        [__filtersManager addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedFilters))
                              options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [__filtersManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedFilters))];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _generatePreviewImage];
    [self _reloadImage];

    self.tableView.delegate = self._filtersManager;
    self.tableView.dataSource = self._filtersManager;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedFilters))]) {
        [self _reloadImage];
    }
}

#pragma mark - 

- (void)_generatePreviewImage
{
    CGSize previewSize = self.imageView.bounds.size;
    self._previewOriginalImage = [self.originalImage resizedImageToFitInSize:previewSize
                                                              scaleIfSmaller:YES];
}

- (void)_reloadImage
{
    if (self._filtersManager.selectedFilters.count == 0) {
        self.imageView.image = self._previewOriginalImage;
        return;
    }

    NSArray *filters = self._filtersManager.selectedFilters;
    UIImage *sourceImage = self._previewOriginalImage;
    UIImage *filteredImage = [self _applyFilters:filters toImageImage:sourceImage];
    self.imageView.image = filteredImage;
}

- (UIImage *)_applyFilters:(NSArray *)filters toImageImage:(UIImage *)sourceImage
{
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

@end
