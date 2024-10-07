import 'package:flutter/material.dart';
import 'page1.dart'; // Mengimpor halaman utama

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(), // Halaman Login dan Sign Up
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Login'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginScreen(), // Halaman Login
          SignUpScreen(), // Halaman Sign Up
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar logo di atas input email
          Image.asset(
            'images/cat.png', // Pastikan path gambar benar
            width: 250, // Ukuran gambar
            height: 250,
          ),

          SizedBox(height: 20.0), // Jarak antara gambar dan input email

          // Input untuk email
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.email, color: Colors.pink),
            ),
          ),

          SizedBox(height: 16.0), // Jarak antar input

          // Input untuk password
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.pink),
            ),
          ),

          SizedBox(height: 20.0), // Jarak antar input dan tombol login

          // Tombol login
          ElevatedButton(
            onPressed: () {
              // Arahkan ke halaman utama setelah login
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Page1(), // Halaman utama
                ),
              );
            },
            child: Text('Login'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Input untuk username
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.person, color: Colors.pink),
            ),
          ),

          SizedBox(height: 16.0),

          // Input untuk email
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.email, color: Colors.pink),
            ),
          ),

          SizedBox(height: 16.0),

          // Input untuk password
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.pink),
            ),
          ),

          SizedBox(height: 16.0),

          // Input untuk re-enter password
          TextField(
            controller: _rePasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Re-enter Password',
              hintText: 'Re-enter your password',
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.pink),
            ),
          ),

          SizedBox(height: 20.0), // Jarak antar input dan tombol sign up

          // Tombol Sign Up
          ElevatedButton(
            onPressed: () {
              // Arahkan ke halaman login setelah sign up berhasil
              Navigator.pop(context); // Kembali ke halaman login
            },
            child: Text('Sign Up'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
          ),

          SizedBox(height: 10.0),

          // Tombol Sign Up dengan Google hanya berupa logo
          OutlinedButton(
            onPressed: () {},
            child: Image.asset(
              'images/logo_google.png',
              width: 24,
              height: 24,
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              side: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
        ],
      ),
    );
  }
}