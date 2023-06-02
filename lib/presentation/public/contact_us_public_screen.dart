import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/public/contact_us_public_cubit.dart';
import 'package:priorli/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/color_extension.dart';
import '../../core/utils/constants.dart';

const contactUsPublicScreenRoute = '/contact-us';

class ContactUsPublicScreen extends StatefulWidget {
  const ContactUsPublicScreen({super.key});

  @override
  State<ContactUsPublicScreen> createState() => _ContactUsPublicScreenState();
}

class _ContactUsPublicScreenState extends State<ContactUsPublicScreen> {
  late final ContactUsPublicCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseAnalytics.instance
          .logScreenView(screenName: contactUsPublicScreenRoute);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactUsPublicCubit>(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 300,
          toolbarHeight: 60,
          leading: InkWell(
            onTap: () => launchUrl(Uri.parse(appWebsite)),
            child: Image.asset(
              'assets/images/priorli_horizontal.png',
              height: 48,
            ),
          ),
          title:
              const Text('Ota yhteyttä', style: TextStyle(color: Colors.white)),
          backgroundColor: HexColor.fromHex(appPrimaryContainerColorDark),
        ),
        body: const Center(
          child: ContactUsForm(),
        ),
      ),
    );
  }
}

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({super.key});

  @override
  State<ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool bookingDemo = false;
  bool messageSent = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Haluatko varata demoesittelyn tai onko sinulla kysyttävää? Voit jättää yhteystietosi ja viestisi tänne, niin otamme sinuun yhteyttä mahdollisimman pian ja annamme sinulle parhaan tarjouksen!',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(hintText: 'Nimi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Syötä nimesi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Sähköposti'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Syötä kelvollinen sähköposti';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(hintText: 'Puhelinnumero'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Syötä puhelinnumerosi';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                  title: const Text('Lähetä minulle demo-tili!'),
                  value: bookingDemo,
                  onChanged: (onChanged) {
                    setState(() {
                      bookingDemo = onChanged!;
                    });
                  }),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                minLines: 5,
                maxLines: 20,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Viesti',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
                validator: (value) {
                  if (bookingDemo == false) {
                    if (value == null || value.isEmpty) {
                      return 'Syötä lyhyt viesti';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: !messageSent
                    ? () {
                        if (_formKey.currentState?.validate() == true) {
                          BlocProvider.of<ContactUsPublicCubit>(context)
                              .submitForm(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  message: _messageController.text,
                                  bookDemo: bookingDemo)
                              .then((success) {
                            setState(() {
                              messageSent = success;
                            });
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Viesti lähetetty!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Viestin lähettäminen epäonnistui!'),
                                ),
                              );
                            }
                          });
                        }
                      }
                    : null,
                child: const Text('Lähetä'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
