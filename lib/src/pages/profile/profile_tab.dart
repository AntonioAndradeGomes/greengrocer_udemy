import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/controllers/auth_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/services/validators.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do usuário',
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () {
              _authController.signOut();
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
            initialValue: _authController.user.email,
            icon: Icons.email,
            label: 'Email',
            readOnly: true,
          ),
          CustomTextField(
            initialValue: _authController.user.name,
            icon: Icons.person,
            label: 'Nome',
            readOnly: true,
          ),
          CustomTextField(
            initialValue: _authController.user.phone,
            icon: Icons.phone,
            label: 'Celular',
            readOnly: true,
          ),
          CustomTextField(
            icon: Icons.file_copy,
            initialValue: _authController.user.cpf,
            label: 'CPF',
            isSecret: true,
            readOnly: true,
          ),
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                updatePassword();
              },
              child: const Text(
                'Atualizar senha',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> updatePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Text(
                        'Atualização de senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CustomTextField(
                      controller: currentPasswordController,
                      icon: Icons.lock,
                      label: 'Senha atual',
                      isSecret: true,
                      validator: passwordValidator,
                    ),
                    CustomTextField(
                      controller: newPasswordController,
                      icon: Icons.lock_outline,
                      label: 'Nova senha',
                      isSecret: true,
                      validator: passwordValidator,
                    ),
                    CustomTextField(
                      icon: Icons.lock_outline,
                      label: 'Confirmar nova senha',
                      isSecret: true,
                      validator: (password) {
                        final result = passwordValidator(password);

                        if (result != null) {
                          return result;
                        }

                        if (password != newPasswordController.text) {
                          return 'As senhas não são equivalentes';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 45,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    _authController.changePassword(
                                      currentPassword:
                                          currentPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    );
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: _authController.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Atualizar senha',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                splashRadius: 25,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
