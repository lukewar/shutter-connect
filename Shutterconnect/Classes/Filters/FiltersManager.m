//
// Copyright (c) 2014 Lukasz Warchol. All rights reserved.
//

#import "FiltersManager.h"

NSString *FilterCellIdentifier = @"FilterCellIdentifier";

@interface FiltersManager ()
@property(nonatomic, strong, readwrite) NSArray *selectedFilters;
@property(nonatomic, strong) NSArray *_allFilters;
@end

@implementation FiltersManager

- (id)init
{
    self = [super init];
    if (self) {
        _selectedFilters = @[];
        __allFilters = @[
            @{@"Chrome" : [CIFilter filterWithName:@"CIPhotoEffectChrome"]},
            @{@"Fade" : [CIFilter filterWithName:@"CIPhotoEffectFade"]},
            @{@"Insta" : [CIFilter filterWithName:@"CIPhotoEffectInstant"]},
            @{@"Noir" : [CIFilter filterWithName:@"CIPhotoEffectNoir"]},
            @{@"Process" : [CIFilter filterWithName:@"CIPhotoEffectProcess"]},
        ];
    }
    return self;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._allFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterCellIdentifier];

    NSString *filterName = [self _filterNameForIndexPath:indexPath];
    CIFilter *filter = [self _filterForIndexPath:indexPath];

    cell.textLabel.text = filterName;
    if ([self.selectedFilters containsObject:filter]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CIFilter *filter = [self _filterForIndexPath:indexPath];
    NSMutableArray *mutableSelectedFilters = [self.selectedFilters mutableCopy];
    if ([self.selectedFilters containsObject:filter]) {
        [mutableSelectedFilters removeObject:filter];
    } else {
        [mutableSelectedFilters addObject:filter];
    }
    self.selectedFilters = [mutableSelectedFilters copy];

    [tableView reloadData];
}

#pragma mark -

- (CIFilter *)_filterForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *filterDictionary = self._allFilters[(NSUInteger) indexPath.row];
    NSString *filterName = [self _filterNameForIndexPath:indexPath];
    return filterDictionary[filterName];
}

- (NSString *)_filterNameForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *filterDictionary = self._allFilters[(NSUInteger) indexPath.row];
    return filterDictionary.allKeys[0];;
}

@end
