CoreData_Async
==============

A simple example of threaded Core Data application.

Basically we launch 3 concurrent background threads that will create objects.
- Bookshelves (1 per sec)
- Books (10 per sec)
- Pages (100 per sec)

Pages are ALWAYS attached to an already existing Book (randomly chosen).
Booksheves are created slowly and there can only be 2^3 Bookshelves.
When Books are created, they try to fetch the Bookshelf corresponding to their domain.
If no Bookshelf covering their domain is available they create one on their own thread.

In the end:
- all objects are correctly updated
- we have 2^3 Bookshelves which means that no duplicates are created / merge is awesome.
