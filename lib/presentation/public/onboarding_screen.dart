import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:priorli/core/utils/color_extension.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/public/chat_public_cubit.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/app_preferences.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../setting_cubit.dart';
import '../shared/custom_form_field.dart';
import '../shared/terms_policies.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onDone});
  final Function()? onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveValue(
                context,
                defaultValue: 16.0,
                valueWhen: [
                  const Condition.smallerThan(
                    name: TABLET,
                    value: 16.0,
                  ),
                  Condition.largerThan(
                    name: TABLET,
                    value: MediaQuery.of(context).size.width * 0.3,
                  )
                ],
              ).value ??
              16.0),
      child: IntroductionScreen(
        onChange: (value) {
          FirebaseAnalytics.instance.logEvent(
              name: 'nameOnboardingScreen',
              parameters: {'screen': value.toString()});
        },
        key: _introKey,
        globalHeader: const AppPreferences(
          mini: true,
        ),
        dotsDecorator: DotsDecorator(
            color: Colors.grey, activeColor: HexColor.fromHex(appPrimaryColor)),
        pages: [
          PageViewModel(
            decoration: PageDecoration(
                imagePadding: EdgeInsets.only(
                    top: ResponsiveValue(
                          context,
                          defaultValue: 150.0,
                          valueWhen: [
                            Condition.smallerThan(
                              name: TABLET,
                              value: MediaQuery.of(context).size.height * 0.2,
                            ),
                            const Condition.largerThan(
                                name: TABLET, value: 150.0)
                          ],
                        ).value ??
                        150.0)),
            title: AppLocalizations.of(context)!.welcome_to_priorli,
            image: GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(appWebsite));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: HexColor.fromHex(appBackgroundColorDark),
                ),
                height: 48,
                child: Image.asset('assets/images/priorli_horizontal.png'),
              ),
            ),
            bodyWidget: Column(
              children: [
                Text(
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    ''),
              ],
            ),
          ),
          PageViewModel(
            decoration: PageDecoration(
                imagePadding: EdgeInsets.only(
                    top: ResponsiveValue(
                          context,
                          defaultValue: 150.0,
                          valueWhen: [
                            Condition.smallerThan(
                              name: TABLET,
                              value: MediaQuery.of(context).size.height * 0.2,
                            ),
                            const Condition.largerThan(
                                name: TABLET, value: 150.0)
                          ],
                        ).value ??
                        150.0)),
            title: '',
            image:
                const AppLottieAnimation(loadingResource: 'computer-apartment'),
            bodyWidget: Column(
              children: [
                Text(
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    AppLocalizations.of(context)!.onboarding_text_2),
              ],
            ),
          ),
          PageViewModel(
            decoration: PageDecoration(
                imagePadding: EdgeInsets.only(
                    top: ResponsiveValue(
                          context,
                          defaultValue: 150.0,
                          valueWhen: [
                            Condition.smallerThan(
                              name: TABLET,
                              value: MediaQuery.of(context).size.height * 0.2,
                            ),
                            const Condition.largerThan(
                                name: TABLET, value: 150.0)
                          ],
                        ).value ??
                        150.0)),
            title: AppLocalizations.of(context)!.onboarding_title_3,
            image: const AppLottieAnimation(loadingResource: 'ai-chat'),
            bodyWidget: Text(
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
                AppLocalizations.of(context)!.onboarding_text_3),
          ),
          PageViewModel(
              decoration: PageDecoration(
                  titlePadding: EdgeInsets.only(
                      top: ResponsiveValue(
                            context,
                            defaultValue: 150.0,
                            valueWhen: [
                              Condition.smallerThan(
                                name: TABLET,
                                value: MediaQuery.of(context).size.height * 0.2,
                              ),
                              const Condition.largerThan(
                                  name: TABLET, value: 150.0)
                            ],
                          ).value ??
                          150.0)),
              title: AppLocalizations.of(context)!.enter_email_to_chat_title,
              bodyWidget: const FinalStep())
        ],
        showNextButton: true,
        showDoneButton: false,
        next: Text(AppLocalizations.of(context)!.next),
        onSkip: widget.onDone,
      ),
    );
  }
}

class FinalStep extends StatefulWidget {
  const FinalStep({super.key});

  @override
  State<FinalStep> createState() => _FinalStepState();
}

class _FinalStepState extends State<FinalStep> {
  final _emailController = TextEditingController();
  bool anonymous = false;
  bool terms = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomFormField(
              enabled: !anonymous,
              hintText: AppLocalizations.of(context)!.email,
              helperText: AppLocalizations.of(context)!.email_chat_helper,
              textEditingController: _emailController,
              autoValidate: true,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) => value!.isValidEmail
                  ? null
                  : AppLocalizations.of(context)!.email_address_error,
            ),
          ),
          Text(AppLocalizations.of(context)!.or,
              style: Theme.of(context).textTheme.bodySmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.anonymous_chat,
                    style: Theme.of(context).textTheme.bodySmall),
                Transform.scale(
                  scale: 0.5,
                  child: Switch(
                    value: anonymous,
                    onChanged: (onChanged) {
                      setState(() {
                        anonymous = onChanged;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          TermsAndPolicies(
            accepted: terms,
            onCheckChanged: (p0) {
              setState(() {
                terms = p0;
              });
            },
          ),
          ElevatedButton(
              onPressed: terms &&
                      (_emailController.text.isValidEmail || anonymous)
                  ? () {
                      BlocProvider.of<ChatPublicCubit>(context)
                          .startChatbotConversation(
                              countryCode: 'fi',
                              conversationName:
                                  AppLocalizations.of(context)?.housing_gpt,
                              languageCode: context
                                      .read<SettingCubit>()
                                      .state
                                      .languageCode ??
                                  '',
                              email: anonymous ? null : _emailController.text);
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.start))
        ],
      ),
    );
  }
}
