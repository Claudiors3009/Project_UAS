import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'models/meal_model.dart';

void main() {
  // Menginisialisasi aplikasi dengan menggunakan ChangeNotifierProvider untuk menyediakan instance MealProvider ke seluruh widget dalam MyApp.
  runApp(
    ChangeNotifierProvider(
      create: (context) => MealProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengatur MaterialApp dengan tema dasar dan halaman utama yaitu MealScreen.
    return MaterialApp(
      title: 'Meal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MealScreen(),
    );
  }
}

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  // Controller untuk menangani input pada TextField pencarian
  final TextEditingController _controller = TextEditingController();
  bool _isGrid = true; // Default tampilan grid view

  @override
  void initState() {
    super.initState();
    // Memanggil fetchMeals pada MealProvider saat inisialisasi
    Provider.of<MealProvider>(context, listen: false).fetchMeals('');
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal App'),
        actions: [
          // Tombol untuk mengubah tampilan antara grid dan list
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TextField untuk pencarian makanan
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Meal',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Memanggil fetchMeals dengan query dari TextField
                    mealProvider.fetchMeals(_controller.text);
                  },
                ),
              ),
            ),
            Expanded(
              // Menampilkan loading indicator jika daftar makanan kosong, jika tidak, menampilkan MealGrid atau MealList
              child: mealProvider.meals.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : _isGrid ? MealGrid(mealProvider.meals) : MealList(mealProvider.meals),
            ),
          ],
        ),
      ),
    );
  }
}

class MealList extends StatelessWidget {
  final List<Meal> meals;

  MealList(this.meals);

  @override
  Widget build(BuildContext context) {
    // Menampilkan daftar makanan dalam bentuk ListView
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, i) => MealItem(meals[i], isGrid: false),
    );
  }
}

class MealGrid extends StatelessWidget {
  final List<Meal> meals;

  MealGrid(this.meals);

  @override
  Widget build(BuildContext context) {
    // Menampilkan daftar makanan dalam bentuk GridView
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4, // Menyesuaikan rasio aspek
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: meals.length,
      itemBuilder: (ctx, i) => MealItem(meals[i], isGrid: true),
    );
  }
}

class MealItem extends StatelessWidget {
  final Meal meal;
  final bool isGrid;

  MealItem(this.meal, {required this.isGrid});

  @override
  Widget build(BuildContext context) {
    // Menampilkan item makanan dalam bentuk Card
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: isGrid
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Menampilkan thumbnail makanan
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Image.network(
                      meal.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    meal.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Category: ${meal.category}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Area: ${meal.area}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  meal.thumbnail,
                  fit: BoxFit.cover,
                  width: 100,
                  height: double.infinity,
                ),
              ),
              title: Text(
                meal.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${meal.category}'),
                  Text('Area: ${meal.area}'),
                ],
              ),
              onTap: () {
                // Navigasi ke MealDetailScreen saat item diklik
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MealDetailScreen(meal),
                  ),
                );
              },
            ),
    );
  }
}

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  MealDetailScreen(this.meal);

  @override
  Widget build(BuildContext context) {
    // Menampilkan detail makanan
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.thumbnail),
            SizedBox(height: 10),
            Text(
              'Category: ${meal.category}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              'Area: ${meal.area}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              meal.instructions,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
