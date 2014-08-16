//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImagesStorage : NSObject

@property(nonatomic, strong, readonly) NSArray *storedImages;

- (void)addImage:(UIImage *)image;

@end
