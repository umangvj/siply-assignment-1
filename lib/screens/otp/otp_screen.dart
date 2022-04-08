import 'package:assignment1/screens/otp/cubit/otp_cubit.dart';
import 'package:assignment1/screens/screens.dart';
import 'package:assignment1/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpScreenArgs {
  final String? phone;
  final String? verificationId;

  OtpScreenArgs({@required this.phone, @required this.verificationId});
}

class OtpScreen extends StatefulWidget {
  static const String routeName = '/otp';

  static Route route(OtpScreenArgs args) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => OtpCubit(
          phone: args.phone,
          verificationId: args.verificationId,
        ),
        child: const OtpScreen(),
      ),
    );
  }

  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0.0, 1.5),
        blurRadius: 4.0,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state.status == OtpStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure?.message),
          );
        }

        if (state.status == OtpStatus.success) {
          Navigator.of(context).pushNamed(HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 20.0,
                ),
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
                    Text(
                      'Please enter OTP sent to mobile number +91 ${state.phone}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black45,
                        letterSpacing: 0.7,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle: TextStyle(
                      fontSize: 25.0,
                      color: Colors.grey[800],
                    ),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinPutFocusNode,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    validator: (value) =>
                        value!.length < 6 ? 'Invalid OTP' : null,
                    onChanged: (value) =>
                        context.read<OtpCubit>().otpChanged(value),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              state.status == OtpStatus.submitting
                  ? Container(
                      margin: const EdgeInsets.only(right: 18.0),
                      alignment: Alignment.centerRight,
                      child: const CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onPanUpdate: (details) {
                        if (details.delta.dx > 1.5) {
                          _submitForm(
                              context, state.status == OtpStatus.submitting);
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
                              ? state.status == OtpStatus.submitting
                                  ? Colors.grey
                                  : Colors.green
                              : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            state.status == OtpStatus.submitting
                                ? 'Verifying'
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
        );
      },
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<OtpCubit>().submitOtp();
    }
  }
}
