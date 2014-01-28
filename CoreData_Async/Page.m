//
//  Page.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "Page.h"
#import "Book.h"
#import <stdlib.h>


@implementation Page

@dynamic number;
@dynamic content;
@dynamic book;

- (void) configure
{
    usleep(50000); // 0.05s
    int len = 100;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    [self setContent:randomString];
    NSArray* books = [Book findAll];
    int nbrOfBooks = (int)[books count];
    Book* b = books[arc4random() % nbrOfBooks];
    Book* localBook = [b inContext:self.managedObjectContext];
    [self setBook:localBook];
}

@end
