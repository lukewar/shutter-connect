//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FiltersManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong, readonly) NSArray *selectedFilters;

@end
