import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('create_account'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
      ),
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
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            32,
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
                          'signup'.tr,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
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
                          'signup_message'.tr,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  16,
                                ),
                              ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            32,
                          ),
                        ),

                        // Display Name Field
                        _buildDisplayNameField(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Username Field
                        _buildUsernameField(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Email Field
                        _buildEmailField(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Role Selection
                        _buildRoleSelector(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Password Field
                        _buildPasswordField(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Confirm Password Field
                        _buildConfirmPasswordField(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            32,
                          ),
                        ),

                        // Create Account Button
                        _buildCreateAccountButton(controller),

                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),

                        // Login Link
                        _buildLoginLink(controller),

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
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.pets, size: 48, color: Colors.white),
    );
  }

  Widget _buildDisplayNameField(SignupController controller) {
    return TextFormField(
      controller: controller.displayNameController,
      validator: controller.validateDisplayName,
      decoration: InputDecoration(
        labelText: 'full_name'.tr,
        hintText: 'enter_full_name'.tr,
        prefixIcon: const Icon(Icons.person),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildUsernameField(SignupController controller) {
    return TextFormField(
      controller: controller.usernameController,
      validator: controller.validateUsername,
      decoration: InputDecoration(
        labelText: 'username'.tr,
        hintText: 'choose_username'.tr,
        prefixIcon: const Icon(Icons.person_outline),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildEmailField(SignupController controller) {
    return TextFormField(
      controller: controller.emailController,
      validator: controller.validateEmail,
      decoration: InputDecoration(
        labelText: 'email'.tr,
        hintText: 'enter_email'.tr,
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildRoleSelector(SignupController controller) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedRole.value,
        decoration: InputDecoration(
          labelText: 'role'.tr,
          prefixIcon: const Icon(Icons.work_outline),
        ),
        items: controller.roles.map((role) {
          return DropdownMenuItem<String>(
            value: role['value'],
            child: Text(role['label']!.tr),
          );
        }).toList(),
        onChanged: controller.changeRole,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'role_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(SignupController controller) {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        validator: controller.validatePassword,
        obscureText: !controller.isPasswordVisible.value,
        decoration: InputDecoration(
          labelText: 'password'.tr,
          hintText: 'create_strong_password'.tr,
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
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildConfirmPasswordField(SignupController controller) {
    return Obx(
      () => TextFormField(
        controller: controller.confirmPasswordController,
        validator: controller.validateConfirmPassword,
        obscureText: !controller.isConfirmPasswordVisible.value,
        decoration: InputDecoration(
          labelText: 'confirm_password'.tr,
          hintText: 'reenter_password'.tr,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            onPressed: controller.toggleConfirmPasswordVisibility,
            icon: Icon(
              controller.isConfirmPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => controller.signup(),
      ),
    );
  }

  Widget _buildCreateAccountButton(SignupController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.signup,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('create_account'.tr),
        ),
      ),
    );
  }

  Widget _buildLoginLink(SignupController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_account'.tr,
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: controller.navigateToLogin,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'sign_in'.tr,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
