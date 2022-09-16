class Author {
  String name;
  String? imageUrl;

  Author({required this.name, this.imageUrl});
}

final Author mark = Author(name: 'Mark Lewis', imageUrl: null);

final Author john = Author(name: 'John Sabestiam', imageUrl: null);

final Author mike = Author(name: 'Mike Ruther', imageUrl: null);

final Author adam = Author(name: 'Adam Zampal', imageUrl: null);
final Author justin = Author(name: 'Justin Neither', imageUrl: null);
final Author sam = Author(name: 'Samuel Tarly', imageUrl: null);
final Author luther = Author(name: 'Luther', imageUrl: null);

final List<Author> authors = [luther, sam, justin, adam, mike, john, mark];
