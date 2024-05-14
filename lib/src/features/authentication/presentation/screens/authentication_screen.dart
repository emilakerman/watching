import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1b29),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: !kIsWeb
              ? SingleChildScrollView(
                  child: LoginContainer(
                    tabController: _tabController,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: LoginContainer(
                      tabController: _tabController,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class LoginContainer extends StatelessWidget {
  const LoginContainer({
    required TabController tabController,
    required this.emailController,
    required this.passwordController,
    super.key,
  }) : _tabController = tabController;

  final TabController _tabController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 120),
          Image.asset(
            'assets/images/logo_3.png',
            height: 103,
          ),
          const SizedBox(height: 40),
          const Text(
            'Welcome, friend!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Please login or sign up.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: [
                Tab(
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.green[900],
                            onTap: () => _tabController.animateTo(1),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          BlocBuilder<AuthCubit, AuthCubitState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const LoadingAnimation();
                              }
                              return ElevatedButton(
                                onPressed: () =>
                                    context.read<AuthCubit>().signInUser(
                                          context,
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 68, 68, 84),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.green[900],
                            onTap: () => _tabController.animateTo(0),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          BlocBuilder<AuthCubit, AuthCubitState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () =>
                                    context.read<AuthCubit>().createUser(
                                          context,
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 68, 68, 84),
                                  ),
                                ),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
