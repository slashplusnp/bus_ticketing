import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../app/constants.dart';
import '../app/dependency_injection.dart';
import '../data/hive/hive_utils.dart';
import '../data/requests/login_request/login_request.dart';
import '../data/responses/hardware_data/hardware_data_response.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/extensions.dart';
import '../network/api_service.dart';
import '../resources/color_manager.dart';
import '../resources/hive_box_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/string_manager.dart';
import '../resources/values_manager.dart';
import '../utils/form_validation_utils.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/slash_plus_bottom_bar.dart';
import '../widgets/widget_utils/widget_utils.dart';

final buttonPressedProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final identifierController = TextEditingController();

    final buttonPressedWatch = ref.watch(buttonPressedProvider);
    final buttonPressedNotifier = ref.watch(buttonPressedProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: identifierController,
                      validator: (value) => FormValidationUtils.formFieldValidator(value: value, fieldName: AppString.identifier),
                      decoration: const InputDecoration(
                        labelText: AppString.identifier,
                        hintText: AppString.identifierHint,
                      ),
                    ),
                    WidgetUtils.verticalSpace(10.h),
                    CustomElevatedButton(
                      buttonColor: context.primary,
                      onPressed: buttonPressedWatch
                          ? null
                          : () {
                              if ((formKey.currentState?.validate()).orFalse()) {
                                formKey.currentState?.save();
                                final ApiService apiService = getInstance<ApiService>();

                                HiveUtils.clearBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox);

                                buttonPressedNotifier.state = true;
                                apiService
                                    .login(
                                  context,
                                  loginRequest: LoginRequest(
                                    identifier: identifierController.text,
                                  ),
                                )
                                    .then(
                                  (data) async {
                                    if (data != null) {
                                      HiveUtils.storeToObjectBox(
                                        boxName: HiveBoxManager.hardwareDataBox,
                                        boxModel: data,
                                      );

                                      await DependencyInjection.reset().then((_) {
                                        context.navigator.pushNamedAndRemoveUntil(
                                          Routes.home.name,
                                          (route) => false,
                                        );
                                      });
                                    } else {
                                      buttonPressedNotifier.state = false;
                                    }
                                  },
                                );
                              }
                            },
                      title: buttonPressedWatch
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: AppSize.s20,
                                  width: AppSize.s20,
                                  child: FittedBox(
                                    child: CircularProgressIndicator(
                                      color: ColorManager.background,
                                    ),
                                  ),
                                ),
                                WidgetUtils.horizontalSpace(AppSize.s10),
                                const Text(AppLoadingString.login),
                              ],
                            )
                          : const Text(AppString.submit),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SlashPlusBottomBar(),
        ],
      ),
    );
  }
}
