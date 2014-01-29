//
//  BookshelfCell.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 29/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "BookshelfCell.h"
#import "THObserversAndBinders.h"

@interface BookshelfCell ()

@property (nonatomic, strong) THObserver* domainObserver;
@property (nonatomic, strong) THObserver* booksObserver;
@property (nonatomic, strong) Bookshelf* bookshelf;

@end

@implementation BookshelfCell

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
    [self.domainObserver stopObserving];
    [self.booksObserver stopObserving];
}

- (void) configureWithBookshelf:(Bookshelf*)aBookshelf
{
    if (self.bookshelf) {
        [self.domainObserver stopObserving];
        [self.booksObserver stopObserving];
    }
    self.bookshelf = aBookshelf;
    [self.textLabel setText:self.bookshelf.domain];
    [self.detailTextLabel setText:[NSString stringWithFormat:@"%ld books", (unsigned long)[self.bookshelf.books count]]];
    
    self.domainObserver = [THObserver observerForObject:self.bookshelf keyPath:@"domain" block:^{
        [self.textLabel setText:self.bookshelf.domain];
    }];
    self.booksObserver = [THObserver observerForObject:self.bookshelf keyPath:@"books" block:^{
        [self.detailTextLabel setText:[NSString stringWithFormat:@"%ld books", (unsigned long)[self.bookshelf.books count]]];
    }];
}

@end