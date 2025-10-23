import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:particles_network/particles_network.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/components/text_field_component.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/utils/image_util.dart';
import 'package:sevyhub/src/view_models/authentication_view_model.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var viewModel = context.read<AuthenticationViewModel>();
    viewModel.addListener(() {
      if (viewModel.state == AuthenticationState.error) {
        String message = viewModel.errorMessage!;
        showSnackBar(true, message);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  void showSnackBar(bool isError, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 3500),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isError
                      ? PhosphorIcons.sealWarning()
                      : PhosphorIcons.sealCheck(),
                  size: 18,
                  color: isError
                      ? DarkTheme.errorColor
                      : DarkTheme.successColor,
                ),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: DarkTheme.gray100Color,
                  ),
                ),
              ],
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Icon(
                  PhosphorIcons.x(),
                  size: 16,
                  color: DarkTheme.gray100Color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInForm() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'E-mail address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            TextFieldComponent(
              controller: emailController,
              hintText: 'email@example.com',
              leadingIcon: PhosphorIcons.envelope(),
            ),
            SizedBox(height: 16),
            Text(
              'Your password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return TextFieldComponent(
                  controller: passwordController,
                  hintText: '******',
                  leadingIcon: PhosphorIcons.lock(),
                  trailingIcon: viewModel.isPasswordVisible
                      ? PhosphorIcons.eyeSlash()
                      : PhosphorIcons.eye(),
                  obscureText: !viewModel.isPasswordVisible,
                  onTapTrailingIcon: () {
                    viewModel.togglePasswordVisibility();
                  },
                );
              },
            ),
            SizedBox(height: 32),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return ButtonComponent(
                  // filled: true,
                  bordered: false,
                  boldText: true,
                  enabled:
                      viewModel.state != AuthenticationState.loadingSignIn ||
                      viewModel.state !=
                          AuthenticationState.loadingForgotPassword ||
                      viewModel.state != AuthenticationState.loadingGoogle,
                  isLoading:
                      viewModel.state == AuthenticationState.loadingSignIn,
                  width: double.maxFinite,
                  text: "Sign in",
                  onPressed: () async {
                    await viewModel.signIn(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Or continue with',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return ButtonComponent(
                  // filled: false,
                  bordered: true,
                  boldText: false,
                  width: double.maxFinite,
                  icon: ImagesUtil.logoGoogleImage,
                  text: "Sign in with Google",
                  enabled:
                      viewModel.state != AuthenticationState.loadingGoogle ||
                      viewModel.state != AuthenticationState.loadingSignIn ||
                      viewModel.state !=
                          AuthenticationState.loadingForgotPassword,
                  isLoading:
                      viewModel.state == AuthenticationState.loadingGoogle,
                  onPressed: () async {
                    await viewModel.signInWithGoogle();
                  },
                );
              },
            ),
            SizedBox(height: 32),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor:
                          (viewModel.state ==
                                  AuthenticationState.loadingForgotPassword ||
                              viewModel.state ==
                                  AuthenticationState.loadingSignIn ||
                              viewModel.state ==
                                  AuthenticationState.loadingGoogle)
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap:
                            (viewModel.state ==
                                    AuthenticationState.loadingForgotPassword ||
                                viewModel.state ==
                                    AuthenticationState.loadingSignIn ||
                                viewModel.state ==
                                    AuthenticationState.loadingGoogle)
                            ? null
                            : () async {
                                await viewModel
                                    .forgotPassword(emailController.text)
                                    .then((_) {
                                      if (viewModel.state ==
                                          AuthenticationState.success) {
                                        showSnackBar(
                                          false,
                                          "Password reset email sent. Please check your inbox.",
                                        );
                                      }
                                    });
                              },
                        child: Center(
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? DarkTheme.gray400Color
                                  : LightTheme.gray400Color,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child:
                            viewModel.state ==
                                AuthenticationState.loadingForgotPassword
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? DarkTheme.yellow800Color
                                    : LightTheme.yellow500Color,
                              )
                            : null,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return MouseRegion(
                  cursor:
                      (viewModel.state ==
                              AuthenticationState.loadingForgotPassword ||
                          viewModel.state ==
                              AuthenticationState.loadingSignIn ||
                          viewModel.state == AuthenticationState.loadingGoogle)
                      ? SystemMouseCursors.forbidden
                      : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap:
                        (viewModel.state ==
                                AuthenticationState.loadingForgotPassword ||
                            viewModel.state ==
                                AuthenticationState.loadingSignIn ||
                            viewModel.state ==
                                AuthenticationState.loadingGoogle)
                        ? null
                        : () {
                            viewModel.toggleSignUp(true);
                          },
                    child: Center(
                      child: Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.gray400Color
                              : LightTheme.gray400Color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            TextFieldComponent(
              controller: fullNameController,
              hintText: 'John Doe',
              leadingIcon: PhosphorIcons.envelope(),
            ),
            SizedBox(height: 16),
            Text(
              'E-mail address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            TextFieldComponent(
              controller: emailController,
              hintText: 'email@example.com',
              leadingIcon: PhosphorIcons.envelope(),
            ),
            SizedBox(height: 16),
            Text(
              'Your password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            TextFieldComponent(
              controller: passwordController,
              hintText: '******',
              leadingIcon: PhosphorIcons.lock(),
              obscureText: true,
            ),
            SizedBox(height: 16),
            Text(
              'Confirm password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray100Color
                    : LightTheme.gray900Color,
              ),
            ),
            SizedBox(height: 8),
            TextFieldComponent(
              controller: confirmPasswordController,
              hintText: '******',
              leadingIcon: PhosphorIcons.lock(),
              obscureText: true,
            ),
            SizedBox(height: 32),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return ButtonComponent(
                  // filled: true,
                  bordered: false,
                  boldText: true,
                  enabled:
                      viewModel.state != AuthenticationState.loadingSignUp ||
                      viewModel.state != AuthenticationState.loadingGoogle,
                  isLoading:
                      viewModel.state == AuthenticationState.loadingSignUp,
                  width: double.maxFinite,
                  text: "Sign up",
                  onPressed: () {
                    viewModel.signUp(
                      fullNameController.text,
                      emailController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Or continue with',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return ButtonComponent(
                  // filled: false,
                  bordered: true,
                  boldText: false,
                  width: double.maxFinite,
                  icon: ImagesUtil.logoGoogleImage,
                  enabled:
                      viewModel.state != AuthenticationState.loadingGoogle ||
                      viewModel.state != AuthenticationState.loadingSignUp,
                  isLoading:
                      viewModel.state == AuthenticationState.loadingGoogle,
                  text: "Sign up with Google",
                  onPressed: () async {
                    await viewModel.signInWithGoogle();
                  },
                );
              },
            ),
            SizedBox(height: 32),
            Consumer<AuthenticationViewModel>(
              builder: (context, viewModel, child) {
                return MouseRegion(
                  cursor:
                      (viewModel.state != AuthenticationState.loadingGoogle ||
                          viewModel.state != AuthenticationState.loadingSignUp)
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
                  child: GestureDetector(
                    onTap:
                        (viewModel.state != AuthenticationState.loadingGoogle ||
                            viewModel.state !=
                                AuthenticationState.loadingSignUp)
                        ? () {
                            viewModel.toggleSignUp(false);
                          }
                        : null,
                    child: Center(
                      child: Text(
                        "Already have an account? Sign in",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.gray400Color
                              : LightTheme.gray400Color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: ParticleNetwork(
                particleCount: 80,
                maxSpeed: 0.5,
                maxSize: 2.5,
                lineWidth: 0.5,
                lineDistance: 100,
                particleColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.yellow800Color
                    : LightTheme.yellow500Color,
                lineColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.yellow500Color
                    : LightTheme.yellow800Color,
                touchActivation: true,
                drawNetwork: true,
                fill: true,
                isComplex: true,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your\npersonal cloud\n3D Printing tool Hub!",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.gray100Color
                              : LightTheme.gray900Color,
                        ),
                      ),
                      SizedBox(height: 32),
                      Consumer<AuthenticationViewModel>(
                        builder: (context, viewModel, child) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            child: viewModel.showSignUp
                                ? KeyedSubtree(
                                    key: ValueKey('SignUpSubTitle'),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Let\'s go!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? DarkTheme.gray100Color
                                                : LightTheme.gray900Color,
                                          ),
                                        ),
                                        Text(
                                          'Sign up to create your new hub',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? DarkTheme.gray400Color
                                                : LightTheme.gray400Color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : KeyedSubtree(
                                    key: ValueKey('SignInSubTitle'),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? DarkTheme.gray100Color
                                                : LightTheme.gray900Color,
                                          ),
                                        ),
                                        Text(
                                          'Sign in to your hub',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? DarkTheme.gray400Color
                                                : LightTheme.gray400Color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 622,
                child: Consumer<AuthenticationViewModel>(
                  builder: (context, viewModel, child) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      child: viewModel.showSignUp
                          ? KeyedSubtree(
                              key: ValueKey('SignUpForm'),
                              child: buildSignUpForm(),
                            )
                          : KeyedSubtree(
                              key: ValueKey('SignInForm'),
                              child: buildSignInForm(),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 14,
            left: 11,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(1, 1), // deslocamento da sombra
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    ImagesUtil.logoColorImage,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  "Sevy Hub",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray100Color
                        : LightTheme.gray900Color,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            left: 11,
            child: Text(
              "© 2025 Sevy Hub. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : LightTheme.gray400Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
