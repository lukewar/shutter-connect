//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FiltersApplier.h"

@interface FiltersApplier (PromiseKit)

- (PMKPromise *)promiseForApplyFilters:(NSArray *)filters toImage:(UIImage *)sourceImage;

@end
