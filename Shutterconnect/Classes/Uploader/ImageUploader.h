//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageUploader <NSObject>

- (void)uploadImage:(UIImage *)image withCompletion:(void (^)(BOOL success))completion;

@end
