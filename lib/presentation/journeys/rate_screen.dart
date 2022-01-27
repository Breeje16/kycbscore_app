import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveller_ratings/data/models/customer.dart';
import 'package:traveller_ratings/presentation/blocs/rate_customer/rate_customer_cubit.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  bool isCompleted = false;

  final fName = TextEditingController();
  final lName = TextEditingController();
  final emailID = TextEditingController();

  String firstName = "";
  String lastName = "";
  String email = "";
  String city = "";
  String country = "";
  late int noOfRatings;
  late double netBehaviourWithStaff;
  late double netCleanliness;
  late double netPayment;
  late double netPoolBehaviour;
  late double netTimelyCheckout;
  late double netScore;
  late RateCustomerCubit rateCustomerCubit;

  @override
  void initState() {
    super.initState();
    rateCustomerCubit = BlocProvider.of<RateCustomerCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return isCompleted
        ? stepsCompleted()
        : Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.purple),
            ),
            child: Stepper(
              margin: const EdgeInsets.only(right: 10),
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (isLastStep) {
                  setState(() {
                    isCompleted = true;
                  });
                  // TODO: Send Data to Server
                  Customer data = Customer(
                    cCity: city,
                    cCountry: country,
                    cEmail: email,
                    cFirstName: firstName,
                    cLastName: lastName,
                    netBehaviourWithStaff: netBehaviourWithStaff.toString(),
                    netCleanliness: netCleanliness.toString(),
                    netPayment: netPayment.toString(),
                    netPoolBehaviour: netPoolBehaviour.toString(),
                    netTimelyCheckout: netTimelyCheckout.toString(),
                    netScore: netScore.toString(),
                    noOfRatings: noOfRatings + 1,
                  );
                  rateCustomerCubit.postCustomerData(data);
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                currentStep == 0
                    ? null
                    : setState(() {
                        currentStep -= 1;
                      });
              },
              controlsBuilder: (context, ControlsDetails controlsDetails) {
                final isLastStep = currentStep == getSteps().length - 1;

                return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                          onPressed: () {
                            if (currentStep == 0) {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();
                              if (isValid) {
                                formKey.currentState?.save();
                              }
                            }
                            controlsDetails.onStepContinue;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (currentStep != 0)
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('BACK'),
                            onPressed: controlsDetails.onStepCancel,
                          ),
                        ),
                    ]));
              },
            ),
          );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text("Email"),
          ),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailID,
                  decoration: const InputDecoration(
                    labelText: 'Customer Email ID',
                    border: OutlineInputBorder(),
                    focusColor: Colors.purple,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => setState(() {
                    email = value!;
                  }),
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    if (!emailValid) {
                      return 'Invalid Email ID';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text("Details"),
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text("Confirm"),
          ),
          content: Container(),
        ),
      ];

  Widget stepsCompleted() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.verified_rounded,
          color: Colors.green,
          size: 200,
        ),
        const Text("Successfully Submitted!"),
        const Text("Click on the Back Button below to Submit Another Rating"),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              textStyle: const TextStyle(fontSize: 24),
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              setState(() {
                isCompleted = false;
                currentStep = 0;

                fName.clear();
                lName.clear();
                emailID.clear();
              });
            },
            child: const Text("Back"))
      ],
    );
  }
}
