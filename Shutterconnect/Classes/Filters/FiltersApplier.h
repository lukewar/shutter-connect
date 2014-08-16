//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FiltersApplier : NSObject

- (UIImage *)applyFilters:(NSArray *)filters toImage:(UIImage *)sourceImage;

@end
