import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Container(
                width: ResponsiveUtils.getMaxContentWidth(context),
                constraints: BoxConstraints(
                  minHeight: ResponsiveUtils.getSafeAreaHeight(context),
                ),
                child: SingleChildScrollView(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  child: Obx(
                    () => Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              20,
                            ),
                          ),

                          // Language Selector and Demo Credentials
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDemoButton(),
                              _buildLanguageSelector(),
                            ],
                          ),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              40,
                            ),
                          ),

                          // Logo / Branding
                          _buildLogo(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              32,
                            ),
                          ),

                          // Headline Text
                          Text(
                            'login'.tr,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        32,
                                      ),
                                ),
                          ),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              8,
                            ),
                          ),

                          // Subheading Text
                          Text(
                            'welcome_message'.tr,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
                                ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              40,
                            ),
                          ),

                          // Username TextField
                          _buildUsernameField(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              20,
                            ),
                          ),

                          // Password TextField
                          _buildPasswordField(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              16,
                            ),
                          ),

                          // Remember Me Checkbox
                          _buildRememberMe(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              32,
                            ),
                          ),

                          // Sign In Button
                          _buildSignInButton(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              16,
                            ),
                          ),

                          // Google Sign In Button
                          _buildGoogleSignInButton(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              16,
                            ),
                          ),

                          // Forgot Password Button
                          _buildForgotPasswordButton(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              32,
                            ),
                          ),

                          // Navigation Link
                          _buildSignupLink(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDemoButton() {
    return TextButton.icon(
      onPressed: controller.showDummyCredentials,
      icon: const Icon(Icons.info_outline, size: 16),
      label: Text('demo'.tr),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedLanguage.value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          iconEnabledColor: const Color(0xFF2E7D32),
          style: Theme.of(Get.context!).textTheme.bodyMedium,
          items: controller.languages.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(language),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.changeLanguage(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.pets, size: 60, color: Colors.white),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: controller.usernameController,
      validator: controller.validateUsername,
      decoration: InputDecoration(
        labelText: 'username_or_email'.tr,
        hintText: 'enter_username_email'.tr,
        prefixIcon: const Icon(Icons.person_outline),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        validator: controller.validatePassword,
        obscureText: !controller.isPasswordVisible.value,
        decoration: InputDecoration(
          labelText: 'password'.tr,
          hintText: 'enter_password'.tr,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            onPressed: controller.togglePasswordVisibility,
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => controller.login(),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: controller.rememberMe.value,
            onChanged: controller.toggleRememberMe,
            activeColor: const Color(0xFF2E7D32),
          ),
        ),
        Text(
          'remember_me'.tr,
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('sign_in'.tr),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: controller.isLoading.value
              ? null
              : controller.signInWithGoogle,
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: Text('sign_in_google'.tr),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: controller.forgotPassword,
      child: Text('forgot_password'.tr),
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr,
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: controller.navigateToSignup,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'create_one'.tr,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
