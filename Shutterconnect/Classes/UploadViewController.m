//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "UploadViewController.h"
#import "FiltersManager.h"
#import "UIImage+Resize.h"
#import "TwitterImageUploader.h"
#import "ProgressHUD.h"
#import "FiltersApplier.h"

NSString *const UploadViewControllerIdentifier = @"UploadViewControllerIdentifier";

@interface UploadViewController ()
@property(nonatomic, strong) UIImage *_previewOriginalImage;

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong) FiltersManager *_filtersManager;
@property(nonatomic, strong) FiltersApplier *_filtersApplier;

@property(nonatomic, strong) id <ImageUploader> _imageUploader;

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
        __filtersApplier = [FiltersApplier new];

        __imageUploader = [TwitterImageUploader new];
    }
    return self;
}

- (void)dealloc
{
    [__filtersManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedFilters))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedFilters))]) {
        [self _reloadPreviewImage];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self._filtersManager;
    self.tableView.dataSource = self._filtersManager;

    [self _generatePreviewImage];
    [self _reloadPreviewImage];
}

#pragma mark - Actions

- (IBAction)didTapSendButton:(id)didTapSendButton
{
    WEAK_SELF
    [ProgressHUD show:NSLocalizedString(@"Uploading...", @"Uploading...")];
    [__imageUploader uploadImage:self.imageView.image
                  withCompletion:^(BOOL success) {
        if (success) {
            [ProgressHUD showSuccess:NSLocalizedString(@"Completed", @"Completed") Interaction:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [ProgressHUD showError:NSLocalizedString(@"Failed", @"Failed")];
        }
    }];
}

#pragma mark - 

- (void)_generatePreviewImage
{
    CGSize previewSize = self.imageView.bounds.size;
    self._previewOriginalImage = [self.originalImage resizedImageToFitInSize:previewSize
                                                              scaleIfSmaller:YES];
}

- (void)_reloadPreviewImage
{
    UIImage *filteredImage = [self._filtersApplier applyFilters:self._filtersManager.selectedFilters
                                                        toImage:self._previewOriginalImage];
    self.imageView.image = filteredImage;
}

@end
