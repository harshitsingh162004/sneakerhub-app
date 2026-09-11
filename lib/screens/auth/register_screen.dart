import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'BUYER';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _selectedRole,
    );
    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF050B18), Color(0xFF0A1628), Color(0xFF050B18)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Back button
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConstants.cardBlue,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusS),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppConstants.textWhite,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text('Create Account', style: AppConstants.heading1),
                  const SizedBox(height: 8),
                  const Text(
                    'Join the premium sneaker auction platform',
                    style: AppConstants.bodyText,
                  ),

                  const SizedBox(height: 40),

                  // Name
                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'John Doe',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  // Email
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'your@email.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppConstants.textWhite),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: const TextStyle(color: AppConstants.textGrey),
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppConstants.textGrey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppConstants.textGrey,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: AppConstants.cardBlue,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusM),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusM),
                        borderSide: const BorderSide(
                            color: AppConstants.electricBlue, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Role selector
                  _buildLabel('I want to'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildRoleCard(
                        title: 'Buy & Bid',
                        subtitle: 'Browse and bid\non auctions',
                        icon: Icons.shopping_bag_outlined,
                        role: 'BUYER',
                      ),
                      const SizedBox(width: 12),
                      _buildRoleCard(
                        title: 'Sell',
                        subtitle: 'List sneakers\nfor auction',
                        icon: Icons.sell_outlined,
                        role: 'SELLER',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Error
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      if (auth.error != null) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppConstants.danger.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusS),
                            border: Border.all(
                                color: AppConstants.danger.withOpacity(0.3)),
                          ),
                          child: Text(
                            auth.error!,
                            style: const TextStyle(
                                color: AppConstants.danger, fontSize: 13),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Register button
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return GestureDetector(
                        onTap: auth.isLoading ? null : _register,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppConstants.blueGradient,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusM),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppConstants.electricBlue.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: AppConstants.textGrey),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppConstants.electricBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppConstants.textWhite),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppConstants.textGrey),
        prefixIcon: Icon(icon, color: AppConstants.textGrey),
        filled: true,
        fillColor: AppConstants.cardBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide:
              const BorderSide(color: AppConstants.electricBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String role,
  }) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected ? AppConstants.cardGradient : null,
            color: isSelected ? null : AppConstants.cardBlue,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              color:
                  isSelected ? AppConstants.electricBlue : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppConstants.electricBlue.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppConstants.electricBlue
                    : AppConstants.textGrey,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? AppConstants.textWhite
                      : AppConstants.textGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppConstants.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppConstants.textLight,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
