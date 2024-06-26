import 'package:credentials/core/shared/extension/context.dart';
import 'package:credentials/core/shared/extension/theme.dart';
import 'package:credentials/features/authentication/presentation/pages/forgotten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config.dart';
import '../../../../core/shared/loading_indicator.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/shared/theme/theme_bloc.dart';
import '../../../dashboard/presentation/pages/dashboard.dart';
import '../bloc/authentication_bloc.dart';
import 'registration.dart';

class AuthenticationPage extends StatefulWidget {
  static const String path = "/authentication";
  static const String tag = "AuthenticationPage";

  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sl<FirebaseAuth>().authStateChanges().listen((user) {
      if (user != null) {
        context.goNamed(DashboardPage.tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        final theme = state.scheme;

        final VoidCallback onSubmit = () {
          if (formKey.currentState?.validate() ?? false) {
            context.read<AuthenticationBloc>().add(
                  Authenticate(
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                );
          }
        };

        final usernameField = TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) => (val?.isNotEmpty ?? false) ? null : "",
          decoration: const InputDecoration(hintText: "email"),
          onFieldSubmitted: (value) {
            onSubmit();
          },
        );

        final passwordField = TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) => (val?.isNotEmpty ?? false) ? null : "",
          decoration: const InputDecoration(hintText: "password"),
          obscureText: true,
          onFieldSubmitted: (value) {
            onSubmit();
          },
        );

        final forgotPassword = InkWell(
          onTap: () {
            context.pushNamed(ForgottenPasswordPage.tag);
          },
          child: Text(
            "Forgotten password?",
            style: TextStyles.title(context: context, color: theme.primary).copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        );

        final signUp = InkWell(
          onTap: () {
            context.pushNamed(RegistrationPage.tag);
          },
          child: Text(
            "Create an account",
            style: TextStyles.title(context: context, color: theme.primary).copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );

        final submitButton = SizedBox(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (_, state) {
              if (state is AuthenticationDone) {
                context.goNamed(DashboardPage.tag);
              } else if (state is AuthenticationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.failure.message,
                      style: TextStyles.body(context: context, color: Colors.red),
                    ),
                    backgroundColor: Colors.red.shade100,
                  ),
                );
              }
            },
            builder: (_, state) {
              if (state is AuthenticationLoading) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                      top: context.bottomInset / 2 + 16,
                      bottom: context.bottomInset + 16,
                    ),
                  ),
                  child: const NetworkingIndicator(dimension: 24, color: Colors.white),
                );
              } else if (state is AuthenticationDone) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                      top: context.bottomInset / 2 + 16,
                      bottom: context.bottomInset + 16,
                    ),
                  ),
                  child: const Icon(
                    Icons.done_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              } else {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                      top: context.bottomInset / 2 + 16,
                      bottom: context.bottomInset + 16,
                    ),
                  ),
                  onPressed: onSubmit,
                  child: Text(
                    "Login".toUpperCase(),
                    style: TextStyles.title(context: context, color: Colors.white).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        );

        return KeyboardDismissOnTap(
          child: Scaffold(
            backgroundColor: theme.background,
            appBar: context.isMobile
                ? AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    centerTitle: false,
                    titleSpacing: 32,
                    title: Text(
                      "Login",
                      style: TextStyles.headline(context: context, color: Colors.black),
                    ),
                  )
                : null,
            body: context.isMobile
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: PhysicalModel(
                      color: theme.tertiary,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(32),
                              children: [
                                const SizedBox(height: 16),
                                usernameField,
                                const SizedBox(height: 16),
                                passwordField,
                                const SizedBox(height: 16),
                              ],
                            ),
                            signUp,
                            const SizedBox(height: 16),
                            submitButton,
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(context.smallestSide / 8),
                    decoration: BoxDecoration(
                      color: theme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.primary,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/icon.png",
                                width: context.smallestSide / 2,
                                height: context.smallestSide / 2,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: Container(
                            color: theme.tertiary,
                            child: Center(
                              child: Form(
                                key: formKey,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(32),
                                  children: [
                                    const SizedBox(height: 16),
                                    usernameField,
                                    const SizedBox(height: 16),
                                    passwordField,
                                    const SizedBox(height: 16),
                                    forgotPassword,
                                    const SizedBox(height: 16),
                                    submitButton,
                                    const SizedBox(height: 16),
                                    signUp,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
