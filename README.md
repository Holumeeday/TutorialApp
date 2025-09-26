# Week 2 — OOP in Dart & Custom Widgets

*Audience:* Students who already know basic Dart (variables, functions, control flow) and are learning how to apply OOP and custom widgets in Flutter.

*Goal:* By the end of this lesson you and your student will understand OOP fundamentals in Dart, feel confident about constructors and properties, deeply understand inheritance and alternatives (composition, mixins), be able to build custom Flutter widgets, apply consistent theming with ThemeData, use layout widgets (Stack, Expanded, Padding, Card) effectively, and manage simple async flows with Future and FutureBuilder.

---

## Table of contents

1. Foundations of OOP (why OOP, classes, objects)
2. Properties, getters/setters, and common patterns
3. Constructors in-depth (default, named, factory, const, initializer lists)
4. Deep dive: Inheritance, polymorphism, abstract classes, mixins, and when not to inherit
5. Composition vs inheritance — practical refactor example
6. Flutter custom widgets (stateless vs stateful, composition of widgets, performance notes)
7. Theming with ThemeData and Theme.of(context)
8. Layout deep dive: Stack, Expanded (Flexible), Padding, Card
9. Async basics: Future, async/await, error handling, FutureBuilder states
10. Mini-project (Todo app) — full code + teaching walkthrough
11. Teaching tips, common mistakes, debugging hints
12. Tasks / Project checklist

---

# 1. Foundations of OOP in Dart

### What is OOP and why it matters in Flutter

* *OOP* (Object-Oriented Programming) is a way to structure code around objects which bundle data (state) and behavior (methods).
* Flutter itself is class-based. Widgets, animations, controllers — almost everything you use is a class and often an instance of a class.
* OOP helps you model your app domain (e.g., Todo, User, Product) and encourages separation of concerns and reuse.

### Class vs Object (simple analogy)

* Class: blueprint (like a blueprint for a house)
* Object: a built house using that blueprint

### Basic class example (review)

dart
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old.');
  }
}

void main() {
  final p = Person('Aisha', 28);
  p.introduce();
}


*Teaching note:* emphasize that classes are types — they appear in function signatures, lists, maps, etc: List<Person> or Person?.

---

# 2. Properties, getters/setters, and common patterns

### Public vs private fields

* In Dart, identifiers that start with _ are *library-private* (not visible outside the file).

dart
class Todo {
  String _title; // private to the file
  bool isDone;

  Todo(this._title, {this.isDone = false});

  String get title => _title; // public getter
  set title(String newTitle) => _title = newTitle; // public setter
}


### Computed properties (getters)

dart
class Rectangle {
  final double width, height;
  Rectangle(this.width, this.height);

  double get area => width * height; // computed property
}


### Immutable model pattern (recommended for simple models)

* Prefer final fields and copyWith when you need new instances.

dart
class Todo {
  final String title;
  final bool isDone;

  const Todo({required this.title, this.isDone = false});

  Todo copyWith({String? title, bool? isDone}) {
    return Todo(title: title ?? this.title, isDone: isDone ?? this.isDone);
  }
}


*Why immutable?* Easier reasoning, safer in concurrent setups, plays nicely with state-management approaches.

---

# 3. Constructors — complete guide

Constructors are how you create instances. Dart offers several constructor patterns.

### Default (unnamed) constructor

dart
class Point {
  final double x, y;
  Point(this.x, this.y);
}


### Named constructors

Useful for creating instances in different ways.

dart
class User {
  final String id;
  final String name;

  User(this.id, this.name);

  User.guest() : id = 'guest', name = 'Guest';
}


### Factory constructors

* Use when you need to return an existing instance, a subtype, or perform extra logic (caching, parsing).

dart
class ColorParser {
  final int value;
  ColorParser._(this.value);

  factory ColorParser(String hex) {
    // simple parse
    final v = int.parse(hex.replaceAll('#', ''), radix: 16);
    return ColorParser._(v);
  }
}


### Const constructors

* Allow compile-time constants; every field must be final.

dart
class Config {
  final String flavor;
  const Config(this.flavor);
}

const prod = Config('production');


### Initializer lists and assert

* Use the initializer list to initialize final fields that need computation or to call super.

dart
class Person {
  final int birthYear;
  final int age;

  Person(this.birthYear) : age = DateTime.now().year - birthYear {
    assert(age >= 0);
  }
}


### Parameter modifiers

* required, optional [] positional, and {} named.

dart
class Example {
  final int a;
  final int b;
  Example({required this.a, this.b = 0});
}


*Teaching tip:* show how using required prevents runtime null errors and makes intent explicit.

---

# 4. Deep dive: Inheritance, Polymorphism, Abstract classes, Mixins

 We’ll explain concepts, show examples, and highlight pitfalls.

### What is inheritance?

* Inheritance models an *is-a* relationship. class Dog extends Animal — Dog is an Animal.
* Child classes inherit fields and methods from the parent and can override methods to customize behavior.

dart
class Animal {
  void speak() => print('Some sound');
}

class Dog extends Animal {
  @override
  void speak() => print('Bark');
}


### Polymorphism

* We can treat different subclasses as the same base type.

dart
void makeSpeak(Animal a) => a.speak();

final List<Animal> animals = [Dog(), Cat(), Bird()];
for (final a in animals) makeSpeak(a);


### Abstract classes

* When you want to define a contract or partially implement behavior, use abstract.

dart
abstract class Repository<T> {
  Future<List<T>> fetchAll();
}

class TodoRepository implements Repository<Todo> {
  @override
  Future<List<Todo>> fetchAll() async => [];
}


### implements vs extends

* extends inherits implementation.
* implements promises to implement the full API; you must reimplement all members.

dart
class Logger {
  void log(String msg) => print(msg);
}

class FancyLogger implements Logger {
  @override
  void log(String msg) => print('*** $msg ***');
}


### Mixins (mixin / with)

* Mixins let you reuse behavior without the tight coupling of inheritance.

dart
mixin LoggerMixin {
  void log(String message) => print('[LOG] $message');
}

class Service with LoggerMixin {
  void doWork() {
    log('Working...');
  }
}


Mixins are great for orthogonal concerns (logging, caching, validation).

### super and super constructors

* Use super to call base class constructors or base class methods.

dart
class Vehicle {
  final String name;
  Vehicle(this.name);
}

class Bus extends Vehicle {
  final int seats;
  Bus(String name, this.seats) : super(name);
}


### Common pitfalls with inheritance

1. *Forced hierarchy* — using inheritance for code reuse when the relationship isn't truly "is-a".
2. *Fragile base class problem* — changes in the parent can break many children.
3. *Overuse* — deep inheritance trees make code hard to reason about.

*Rule of thumb:* Prefer composition when you have has-a relationships and favor small, focused base classes when you do use inheritance.

---

# 5. Composition vs Inheritance — practical refactor

### Problem example (misused inheritance)

dart
class DatabaseConnection {
  void connect() {}
}

class UserManager extends DatabaseConnection {
  void createUser() {
    connect(); // misuse: UserManager IS NOT A DatabaseConnection
  }
}


This is wrong because UserManager is not a DatabaseConnection. It's using a DatabaseConnection.

### Refactor using composition

dart
class DatabaseConnection {
  void connect() {}
}

class UserManager {
  final DatabaseConnection db;
  UserManager(this.db);

  void createUser() {
    db.connect();
  }
}


*Explanation:* composition reduces coupling and makes testing easier (you can inject mocks).

---

# 6. Flutter custom widgets — patterns and best-practices

### Stateless vs Stateful — refresher

* StatelessWidget: no internal mutable state. Rebuilds when parent asks.
* StatefulWidget: holds state in a State<T> object, useful when widget needs to change over time.

*When to use which:* If the widget's UI depends only on constructor arguments and InheritedWidgets/providers, use StatelessWidget. If it holds local UI state (like a TextField controller, animation controller, or toggled checkbox), use StatefulWidget.

### Building a clean custom widget (TodoTile example — composition)

* Make your widget rely on data + callbacks, not on fetching data itself — separation of concerns.

dart
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final bool isDone;
  const Todo({required this.title, this.isDone = false});
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?>? onChanged;

  const TodoTile({super.key, required this.todo, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(value: todo.isDone, onChanged: onChanged),
        title: Text(todo.title, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}


*Key points:*

* Widget is const-constructible — good for performance.
* Accepts onChanged callback so parent controls state — avoids tight coupling.

### Stateful version use-case

If your tile itself manages an ephemeral animation or local focus, convert to StatefulWidget but *keep state minimal*. Prefer lifting state up to parent when possible.

### Performance tips

* Use const where possible.
* Keep build methods small — extract subtrees into separate widgets if complex.
* Avoid creating heavy objects inside build() (e.g., don’t create controllers there).

---

# 7. Theming with ThemeData — design once, use everywhere

### Why themes?

* Centralize style decisions (colors, typography).
* Make app-wide changes quickly and consistently.

### Basic setup (MaterialApp)

dart
MaterialApp(
  title: 'Todo App',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardTheme(elevation: 3, margin: EdgeInsets.all(8)),
  ),
  home: const TodoScreen(),
)


### Using theme values inside widgets

dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleLarge,
)

Container(
  color: Theme.of(context).colorScheme.primary,
)


### Theming tips

* Use ColorScheme rather than deprecated primaryColor when possible.
* Create a separate file app_theme.dart for theme definitions if your project grows.
* Use Theme.of(context).copyWith(...) only when you need to adjust theme locally.

---

# 8. Layout deep dive (Stack, Expanded, Padding, Card)

This section explains practical layout behavior and typical uses.

## Stack

* Stack places children on top of each other.
* Use Positioned, Align, or Center to control placement.
* Beware: Stack takes the size of the largest child unless constrained.

dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Positioned(
      bottom: 10,
      right: 10,
      child: Icon(Icons.edit),
    ),
  ],
)


*Common pitfall:* Placing Stack inside an unconstrained Column without size — wrap with SizedBox or give explicit heights.

## Expanded vs Flexible

* Both are used *only* inside Row, Column, or Flex.
* Expanded forces its child to fill available space. Flexible lets the child be smaller but still flexible.

dart
Row(
  children: [
    Expanded(child: Container(color: Colors.red)),
    Expanded(flex: 2, child: Container(color: Colors.green)),
  ],
)


*Layout algorithm:* Flutter divides extra space based on flex factors.

## Padding

* Use Padding or SizedBox for spacing.
* Prefer Padding for content spacing and SizedBox for fixed gaps.

dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Text('Hello'),
)


## Card

* Card gives a material surface with elevation and rounded corners. Great for list items.

dart
Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 4,
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: [Text('Title'), Text('Subtitle')]),
  ),
)


*When to use Card vs Container:* Use Card when you want the material look and elevation. Container is more generic.

---

# 9. Async basics in Flutter

### Future and async/await

* Future<T> is a placeholder for a value that will be available later.
* async marks a function that returns a Future and allows await inside.

dart
Future<String> fetchGreeting() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Hello!';
}

void demo() async {
  final greeting = await fetchGreeting();
  print(greeting);
}


### Error handling

dart
try {
  final data = await fetchData();
} catch (e) {
  print('Error: $e');
}


### FutureBuilder — managing UI states

FutureBuilder rebuilds when the future completes. Use it to show loading / error / success UI.

dart
FutureBuilder<List<Todo>>(
  future: fetchTodos(),
  builder: (context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Text('No request started');
      case ConnectionState.waiting:
      case ConnectionState.active:
        return const Center(child: CircularProgressIndicator());
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: \${snapshot.error}');
        final todos = snapshot.data ?? [];
        if (todos.isEmpty) return const Text('No todos');
        return ListView(...);
    }
  },
)


*Important:* Recreating the future on every build() causes refetch. If you want the future to run once, store it in state: late final Future<List<Todo>> _todosFuture; in initState.

---

# 10. Mini-project — Todo App (full code + walk-through)

*Goal:* Build a small Todo list that:

* Uses a Todo model class
* Renders todos with a custom TodoTile
* Applies a global theme
* Simulates fetching with Future.delayed and shows a spinner using FutureBuilder
* Allows toggling isDone

> We'll provide a single-file example main.dart that is easy to copy-paste for teaching. In production you would split models/widgets into separate files.

dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      home: const TodoScreen(),
    );
  }
}

// ------------------ Model ------------------
class Todo {
  final String id;
  final String title;
  final bool isDone;

  const Todo({required this.id, required this.title, this.isDone = false});

  Todo copyWith({String? id, String? title, bool? isDone}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

// ------------------ Widget: TodoTile ------------------
class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textStyle = todo.isDone
        ? Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.lineThrough)
        : Theme.of(context).textTheme.bodyMedium;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(value: todo.isDone, onChanged: onChanged),
        title: Text(todo.title, style: textStyle),
      ),
    );
  }
}

// ------------------ Screen ------------------
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late List<Todo> _todos;
  late Future<List<Todo>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todos = [];
    _todosFuture = _fetchTodos(); // run once
  }

  Future<List<Todo>> _fetchTodos() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network
    return [
      const Todo(id: '1', title: 'Learn OOP in Dart'),
      const Todo(id: '2', title: 'Build custom TodoTile widget'),
      const Todo(id: '3', title: 'Practice FutureBuilder'),
    ];
  }

  void _toggleTodo(Todo todo, bool? checked) {
    setState(() {
      _todos = _todos.map((t) => t.id == todo.id ? t.copyWith(isDone: checked ?? false) : t).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: FutureBuilder<List<Todo>>(
        future: _todosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          // once done, initialize local _todos list if empty
          if (snapshot.hasData && _todos.isEmpty) {
            _todos = snapshot.data!;
          }

          if (_todos.isEmpty) {
            return const Center(child: Text('No todos'));
          }

          return ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo = _todos[index];
              return TodoTile(todo: todo, onChanged: (val) => _toggleTodo(todo, val));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Todo title')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title);
                  _todos = [newTodo, ..._todos];
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}


### Walk-through (teaching points)

* We store _todosFuture in initState() to ensure the fetch runs only once. If we called _fetchTodos() directly inside build() the request would re-run each rebuild.
* Todo is immutable and has copyWith to produce modified copies.
* TodoTile is stateless and receives data + callback; it does not own the state — the parent does. This is a clean separation.
* We show a spinner while loading. Error handling is demonstrated.
* Adding a todo immediately updates local list using setState.

---

# 11. Teaching tips, common mistakes & debugging hints

### Teaching tips 

1. *Start with examples*: use animals (Animal, Dog, Bird) for polymorphism demos. Show a List<Animal> calling speak().
2. *Draw relationships: draw or sketch *is-a vs has-a on a whiteboard.
3. *Refactor live*: show code that erroneously uses extends and then refactor to composition.
4. *Show alternatives*: implement the same capability with mixin and explain the difference.
5. *Emphasize testing*: composition enables mocking dependencies easily.

### Common mistakes

* Creating long inheritance chains instead of composing small reusable components.
* Using mutable fields unnecessarily (prefer final when possible).
* Recreating futures in build() leading to flicker and repeated network calls.

### Debugging tips

* Use print() or devtools to inspect values.
* For layout issues, use Flutter's widget inspector and the Inspector panel.
* For async problems, log connection states inside FutureBuilder to understand what's happening.