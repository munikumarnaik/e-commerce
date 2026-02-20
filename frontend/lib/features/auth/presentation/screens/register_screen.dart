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
import '../widgets/password_strength_indicator.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _password = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          passwordConfirm: _confirmPasswordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        context.go(RouteNames.home);
      } else if (next is AuthError) {
        context.showSnackBar(next.message, isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: AppStrings.createAccount,
                  subtitle: 'Join ShopVerse today',
                ),

                const SizedBox(height: AppDimensions.xl),

                // First & Last Name row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: AppStrings.enterFirstName,
                        controller: _firstNameController,
                        prefixIcon: Icons.person_outlined,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            Validators.validateRequired(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: CustomTextField(
                        label: AppStrings.enterLastName,
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            Validators.validateRequired(v, 'Last name'),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.md),

                // Username
                CustomTextField(
                  label: AppStrings.enterUsername,
                  controller: _usernameController,
                  prefixIcon: Icons.alternate_email_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      Validators.validateRequired(v, 'Username'),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.md),

                // Email
                CustomTextField(
                  label: 'Email',
                  hint: AppStrings.enterEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateEmail,
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.md),

                // Phone
                CustomTextField(
                  label: AppStrings.enterPhone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validatePhone,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.md),

                // Password
                CustomTextField(
                  label: 'Password',
                  hint: AppStrings.enterPassword,
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validatePassword,
                  onChanged: (value) => setState(() => _password = value),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),

                // Password strength
                PasswordStrengthIndicator(password: _password),

                const SizedBox(height: AppDimensions.md),

                // Confirm password
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.validateConfirmPassword(
                    v,
                    _passwordController.text,
                  ),
                  onFieldSubmitted: (_) => _onRegister(),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.lg),

                // Register button
                CustomButton(
                  label: AppStrings.register,
                  onPressed: _onRegister,
                  isLoading: isLoading,
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppDimensions.lg),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        AppStrings.login,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
