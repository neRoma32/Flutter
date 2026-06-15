import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _logoVisible = false;
  bool _formVisible = false;
  double _buttonScale = 1.0;
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;

  //Staggered Animations
  bool _emailVisible = false;
  bool _passVisible = false;
  bool _btnVisible = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = Tween<double>(begin: -10, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _logoVisible = true);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _formVisible = true);
    });

    //Staggered Animations
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _emailVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _passVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _btnVisible = true);
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _shake() {
    _shakeController.reset();
    _shakeController.forward();
  }

  Future<void> _login() async {
    setState(() {
      _isError = false;
      _isSuccess = false;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _isError = true);
      _shake();
      _showError('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return; 
    setState(() => _isLoading = false);

    if (_emailController.text == 'test@test.com' && _passwordController.text == '123456') {
      setState(() => _isSuccess = true);
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        //Hero Animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, _, _) => const HomeScreen(),
          ),
        );
      }
    } else {
      setState(() => _isError = true);
      _shake();
      _showError('Invalid credentials');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _onButtonTapDown(TapDownDetails details) => setState(() => _buttonScale = 0.95);
  void _onButtonTapUp(TapUpDetails details) => setState(() => _buttonScale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.6),
            child: AnimatedOpacity(
              opacity: _logoVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: const Icon(Icons.lock, size: 100, color: Colors.blueGrey),
            ),
          ),
          AnimatedPositioned(
            bottom: _formVisible ? 0 : -400,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Container(
              height: 400,
              padding: const EdgeInsets.all(24),
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSuccess) ...[
                      //Hero Animation Lottie Animation
                      Hero(
                        tag: 'success_hero', 
                        child: Lottie.asset(
                            'assets/success.json',
                            width: 150,
                            height: 150,
                            repeat: false,
                        ),
                      )
                    ] else ...[
                      //C Email
                      AnimatedOpacity(
                        opacity: _emailVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      //C
                      AnimatedOpacity(
                        opacity: _passVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 24),

                      //C
                      AnimatedOpacity(
                        opacity: _btnVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : GestureDetector(
                                  onTapDown: _onButtonTapDown,
                                  onTapUp: _onButtonTapUp,
                                  onTapCancel: () => setState(() => _buttonScale = 1.0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    transform: Matrix4.diagonal3Values(_buttonScale, _buttonScale, 1.0),
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 50),
                                      ),
                                      child: const Text('Login', style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Hero Animation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Вийти',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (_, _, _) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'success_hero',
              child: Lottie.asset(
                'assets/success.json',
                width: 250,
                height: 250,
                repeat: false,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ласкаво просимо!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}