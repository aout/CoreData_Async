//
//  BookCell.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "BookCell.h"
#import "THObserversAndBinders.h"
#import "Book.h"

@interface BookCell ()

@property (nonatomic, strong) THObserver* titleObserver;
@property (nonatomic, strong) THObserver* pagesObserver;
@property (nonatomic, strong) Book* book;

@end

@implementation BookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc
{
    [self.titleObserver stopObserving];
    [self.pagesObserver stopObserving];
}

- (void) configureWithBook:(Book*)aBook
{
    if (self.book) {
        [self.titleObserver stopObserving];
        [self.pagesObserver stopObserving];
    }
    self.book = aBook;
    [self.textLabel setText:self.book.title];
    [self.detailTextLabel setText:[NSString stringWithFormat:@"%ld pages", (unsigned long)[self.book.pages count]]];
    
    self.titleObserver = [THObserver observerForObject:self.book keyPath:@"title" block:^{
        [self.textLabel setText:self.book.title];
    }];
    self.pagesObserver = [THObserver observerForObject:self.book keyPath:@"title" block:^{
        [self.detailTextLabel setText:[NSString stringWithFormat:@"%ld pages", (unsigned long)[self.book.pages count]]];
    }];
}

@end
