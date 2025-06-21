
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omt/core/common/widgets/omt_button.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';
import 'package:omt/features/auth/widgets/omt_text_field.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool signUp=false;
  bool obscureText=false;


  final logosPath = [
    if(Platform.isIOS)
    'assets/images/apple.png',
    'assets/images/google.png',
    'assets/images/x.png',
  ];

  Future<void> _submitForm() async {
    setState(() {
      isLoading=true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final authFunctionsProvider = ref.read(authProvider.notifier);
      try {
        await authFunctionsProvider.signIn(name, password);
      } catch (e) {
        setState(() {
          isLoading=false;
        });
        print(e);
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final height = media.size.height;
    final width = media.size.width;

    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                SvgPicture.asset('assets/images/Logo.svg'),
                SizedBox(height: 32),
                Text(
                  'Welcome to OMT',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Your all in one place for movie and show rating and tracking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 35),
                
                SizedBox(height: 4),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [if(signUp)...[
                                            Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),OmtTextField(
                        validator: (value) {
                          if(value!.isEmpty||value==null){
                            return 
                            'Please enter your name';
                          }
                        },
                        suffixIcon: Icon(Icons.person),
                        hintText: 'Enter your name',
                        onSaved: (value) {
                          name = value;
                        },
                      ),SizedBox(height: 16.h,)

                    ],
                      Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                      OmtTextField(
                        validator: (value) {
                          if(value!.isEmpty||value==null){
                            return 
                            'Please enter your name';
                          }
                        },
                        suffixIcon: Icon(Icons.email),
                        hintText: 'Enter your name',
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      OmtTextField(validator: (value){
                        if(value!.isEmpty||value==null){
                          return 'Please enter your password';
                        }
                      },
                        obscureText: obscureText,
                        suffixIcon: GestureDetector(onTap: (){
                          setState(() {
                            obscureText=!obscureText;
                          });
                          print(obscureText);
                        },
                          child: Icon(obscureText
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye)),
                        hintText: '••••••••',
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      SizedBox(height: 45),
                      OmtButton(isLoading: isLoading,
                        onPressed: () async {
                          await _submitForm();
                        },
                        text: 'Log in',
                      ),
                      SizedBox(height: 45),
                      GestureDetector(onTap: () {
                        
                      },
                        child: Text(
                          'Or, sign up with',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(letterSpacing: -0.8),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final logo in logosPath) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Image.asset(logo, width: 25),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don’t have an account? ',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            TextSpan(recognizer:TapGestureRecognizer()..onTap=(){
                              setState(() {
                                signUp=!signUp;
                              });
                              print(signUp);
                            },
                              text:signUp?'Sign In': 'Sign Up ',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
