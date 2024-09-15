import 'package:hive/hive.dart';
part 'person.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  late String name;

  int age = 10;

  Person({
    required this.name,
  });
}
