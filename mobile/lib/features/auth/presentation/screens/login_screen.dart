import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/models/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        final role = next.user.role;
        if (role == 'ADMIN' || role == 'VENDOR') {
          context.go(RouteNames.admin);
        } else {
          context.go(RouteNames.home);
        }
      } else if (next is AuthError) {
        context.showSnackBar(next.message, isError: true);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const AuthHeader(
                    title: AppStrings.welcomeBack,
                    subtitle: 'Sign in to continue shopping',
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // Email
                  CustomTextField(
                    label: 'Email',
                    hint: AppStrings.enterEmail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateEmail,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppDimensions.md),

                  // Password
                  CustomTextField(
                    label: 'Password',
                    hint: AppStrings.enterPassword,
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outlined,
                    textInputAction: TextInputAction.done,
                    validator: Validators.validatePassword,
                    onFieldSubmitted: (_) => _onLogin(),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppDimensions.sm),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(RouteNames.forgotPassword),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: AppDimensions.lg),

                  // Login button
                  CustomButton(
                    label: AppStrings.login,
                    onPressed: _onLogin,
                    isLoading: isLoading,
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppDimensions.lg),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.register),
                        child: Text(
                          AppStrings.register,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
