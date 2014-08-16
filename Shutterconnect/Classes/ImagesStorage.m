//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "ImagesStorage.h"


@interface ImagesStorage ()
@property(nonatomic, strong, readwrite) NSArray *storedImages;
@end

@implementation ImagesStorage

- (id)init
{
    self = [super init];
    if (self) {
        _storedImages = [self loadSavedImages];
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    [self saveImageToDisc:image];
    _storedImages = [_storedImages arrayByAddingObject:image];
}

#pragma mark -

- (NSArray *)loadSavedImages
{
    NSString *dataPath = [self storageDirectoryPath];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dataPath])
        [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];

    NSMutableArray *loadedImages = [NSMutableArray new];
    NSArray *imagesFilenNames = [fileManager contentsOfDirectoryAtPath:dataPath error:nil];
    for (NSString *imageFileName in imagesFilenNames) {
        UIImage *image = [UIImage imageWithContentsOfFile:[dataPath stringByAppendingPathComponent:imageFileName]];
        if (image) {
            [loadedImages addObject:image];
        }
    }
    NSArray *array = [loadedImages copy];
    return array;
}

- (void)saveImageToDisc:(UIImage *)image
{
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageFileName = [NSString stringWithFormat:@"%.0f.jpg", [NSDate date].timeIntervalSinceReferenceDate];
    NSString *imagePath = [[self storageDirectoryPath] stringByAppendingPathComponent:imageFileName];
    [imageData writeToFile:imagePath atomically:YES];
}

- (NSString *)storageDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    return dataPath;
}

@end
