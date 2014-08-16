//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <PromiseKit/fwd.h>
#import <PromiseKit/Promise.h>
#import "FiltersApplier+PromiseKit.h"


@implementation FiltersApplier (PromiseKit)

- (PMKPromise *)promiseForApplyFilters:(NSArray *)filters toImage:(UIImage *)sourceImage
{
    WEAK_SELF
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf applyFilters:filters toImage:sourceImage withCompletion:^(UIImage *image) {
            fulfill(image);
        }];
    }];
}

@end
