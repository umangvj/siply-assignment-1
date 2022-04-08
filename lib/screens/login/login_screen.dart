import 'package:assignment1/repositories/auth/auth_repository.dart';
import 'package:assignment1/screens/screens.dart';
import 'package:assignment1/screens/login/cubit/login_cubit.dart';
import 'package:assignment1/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure?.message,
            ),
          );
        }
        if (state.status == LoginStatus.codeSent) {
          Navigator.of(context).pushNamed(
            OtpScreen.routeName,
            arguments: OtpScreenArgs(
                phone: state.phone, verificationId: state.verificationId),
          );
        }
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushNamed(HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Welcome to ',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            children: [
                              const TextSpan(
                                text: 'CHHOTA ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'STOCK',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Enter your phone number and start investing in stocks with as low as ₹100',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black45,
                          letterSpacing: 0.7,
                          wordSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 12.0, right: 2.0),
                              child: Text(
                                '+91',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minHeight: 0, minWidth: 0),
                          ),
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (phone) {
                            context.read<LoginCubit>().phoneChanged(phone);
                          },
                          validator: (value) {
                            if (value!.length != 10) {
                              return 'Please enter a valid phone number.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                state.status == LoginStatus.submitting
                    ? Container(
                        margin: const EdgeInsets.only(right: 18.0),
                        alignment: Alignment.centerRight,
                        child: const CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx > 1.5) {
                            _submitForm(context,
                                state.status == LoginStatus.submitting);
                          }
                        },
                        child: Container(
                          height: 55.0,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: size.width / 3),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            color: state.isFormValid
                                ? state.status == LoginStatus.submitting
                                    ? Colors.grey
                                    : Colors.green
                                : Colors.grey,
                          ),
                          child: Center(
                            child: Text(
                              state.status == LoginStatus.submitting
                                  ? 'Getting Started'
                                  : 'Swipe To Submit',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
