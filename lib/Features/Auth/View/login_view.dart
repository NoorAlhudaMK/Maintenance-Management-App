import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../MainPage/View/manager_main_home_page.dart';
import '../../MainPage/View/technician_main_home_page.dart';
import '../BLoC/auth_event.dart';
import '../BLoC/auth_bloc.dart';
import '../BLoC/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(
    text: "Maintenance Supervisor",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "123",
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.business_outlined,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.accent,
                              child: const Icon(
                                Icons.build_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    Text(
                      "صيانة المجمعات",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "نظام إدارة الصيانة",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 45),

                    _buildLabel("البريد الإلكتروني أو الرقم الوظيفي"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      textAlign: TextAlign.right,
                      decoration: _inputDecoration(
                        "أدخل بريدك الإلكتروني...",
                        Icons.email_outlined,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "الحقل مطلوب" : null,
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("كلمة المرور"),
                    const SizedBox(height: 8),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        bool isObscured = true;

                        if (state is AuthInitial) {
                          isObscured = state.isPasswordVisible;
                        }

                        return TextFormField(
                          controller: _passwordController,
                          obscureText: isObscured,
                          textAlign: TextAlign.right,
                          decoration: _inputDecoration(
                            "••••••••",
                            Icons.lock_outline,
                            prefixWidget: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                TogglePasswordVisibility(),
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "الحقل مطلوب" : null,
                        );
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          if (state.role == 'maintenance_supervisor') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManagerMainHomePage(),
                              ),
                            );
                          } else if (state.role == 'maintenance') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TechnicianMainHomePage(),
                              ),
                            );
                          }
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primary.withOpacity(0.4),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                LoginSubmitted(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "نظام إدارة صيانة المجمع السكني",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${DateTime.now().year} © All Rights Reserved AIVIO LTD",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? prefixWidget,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      suffixIcon: Icon(icon, color: Colors.grey, size: 22),
      prefixIcon: prefixWidget,
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
