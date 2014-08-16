//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "TwitterImageUploader.h"
#import "ACAccountStore+PromiseKit.h"
#import "Promise.h"
#import "SLRequest+PromiseKit.h"
#import <Accounts/Accounts.h>


@interface TwitterImageUploader ()
@property(nonatomic, strong) ACAccountStore *_accountStore;
@end

@implementation TwitterImageUploader

- (id)init
{
    self = [super init];
    if (self) {
        __accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)uploadImage:(UIImage *)image withCompletion:(void (^)(BOOL success))completion
{
    WEAK_SELF
    ACAccountType *twitterType = [self._accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    PMKPromise *promise = [self._accountStore promiseForAccountsWithType:twitterType options:nil];
    promise.then(^(BOOL granted) {
        typeof(self) strongSelf = weakSelf;

        ACAccount *account = [[strongSelf._accountStore accountsWithAccountType:twitterType] firstObject];
        if (account == nil) {
            @throw @"No Twitter accounts found.";
        }
        return [strongSelf _promiseForUploadImage:image forAccount:account];
    }).then(^(NSHTTPURLResponse *uploadResponse) {
        completion(YES);
    }).catch(^(NSError *error) {
        completion(NO);
    });
}

- (PMKPromise *)_promiseForUploadImage:(UIImage *)image forAccount:(ACAccount *)account
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
    NSDictionary *params = @{@"status" : @"Check this out!!!"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
    [request addMultipartData:imageData
                     withName:@"media[]"
                         type:@"image/jpeg"
                     filename:@"image.jpg"];
    [request setAccount:account];
    PMKPromise *pmkPromise = [request promise];
    return pmkPromise;
}

@end
