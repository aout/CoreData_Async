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

@property (nonatomic, strong) THObserver* observer;
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
    [self.observer stopObserving];
}

- (void) configureWithBook:(Book*)aBook
{
    if (self.book) {
        [self.observer stopObserving];
    }
    self.book = aBook;
    [self.textLabel setText:self.book.title];
    self.observer = [THObserver observerForObject:self.book keyPath:@"title" block:^{
        [self.textLabel setText:self.book.title];
    }];
}

@end
