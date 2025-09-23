import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Define a simple custom class to demonstrate complex Lists.
class Book {
  final String title;
  final String author;
  final int publicationYear;

  Book(this.title, this.author, this.publicationYear);
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final String title;
    final String appTitle = "Flutter Data Type";
    // 1. Basic List of Strings
    List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Mango'];

    // 2. Complex List of custom objects
    List<Book> books = [
      Book('The Lord of the Rings', 'J.R.R. Tolkien', 1954),
      Book('Pride and Prejudice', 'Jane Austen', 1813),
      Book('To Kill a Mockingbird', 'Harper Lee', 1960),
    ];

    // 3. Basic Map with String keys and String values
    Map<String, String> userProfile = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'Admin',
    };

    List<Map<String, String>> allUserProfiles = [
      {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'Admin',
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'role': 'User',
      },
      {
        'name': 'Peter Jones',
        'email': 'peter.jones@example.com',
        'role': 'Guest',
      },
    ];

    // 4. Complex Map with String keys and dynamic values (List of Strings)
    Map<String, List<String>> groceries = {
      'Vegetables': ['Carrots', 'Broccoli', 'Spinach'],
      'Fruits': ['Apples', 'Oranges', 'Grapes'],
      'Dairy': ['Milk', 'Cheese', 'Yogurt'],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Basic List display
                sectionTitile(title: '1. Basic List (FRUITS)'),
                listSection(fruits),

                //list with map
                sectionTitile(title: '2. Complex List (Books)'),
                ...books.map((books) => Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.teal),
                      title: Text(books.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                          Text('by ${books.author} (${books.publicationYear})'),
                    ))),

                //3. Map with key & Value
                sectionTitile(title: '3. Basic Map (User Profile)'),
                ...userProfile.entries.map((entry) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.teal),
                      title: Text(entry.key.toLowerCase()),
                      subtitle: Text(
                        entry.value,
                      ),
                    ))),
                //3.2
                sectionTitile(title: '3.2.  Map (All User Profile)'),
                ...allUserProfiles.map((user)=> Card(
                  elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.teal),
                            title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text('Email: ${user['email']}|| Role: ${user['role']}'),
                          ),
                )),
                //4.0
                sectionTitile(title: '4.  Complex Map (Groceries)'),
                ...groceries.entries.map((entry){
                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    leading: const Icon(Icons.shopping_cart, color: Colors.teal),
                    children: entry.value.map((item){
                      return ListTile(
                        title: Text(item),
                        leading: const Icon(Icons.arrow_right, color: Colors.grey),
                      );
                    }).toList()
                    );
                }).toList()

                
              ],
              
            )),
      ),
    );
  }
}

Widget listSection(List<String> items) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (Context, index) {
          return ListTile(
            leading: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            title: Text(items[index]),
          );
        }),
  );
}

class sectionTitile extends StatelessWidget {
  const sectionTitile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.teal[700],
        ),
      ),
    );
  }
}
