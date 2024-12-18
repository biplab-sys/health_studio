import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:health_studio_user/core/controllers/auth_controller.dart';
import 'package:health_studio_user/ui/widgets/app_bar.dart';
import 'package:health_studio_user/utils/spacing.dart';
import 'package:health_studio_user/utils/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  final Function()? onSuccess;
  final bool isSocial;
  const RegistrationPage({
    super.key,
    this.onSuccess,
    this.isSocial = false,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool passwordsMatch = false;

  List<Map<String, String>> get items => [
        {"M": AppLocalizations.of(context)!.male},
        {"F": AppLocalizations.of(context)!.female}
      ];

  _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.email_required;
    } else if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.valid_email;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (authController) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: authController.signUpFormKey,
                    onChanged: () {
                      if (authController.signUpFormKey.currentState
                              ?.validate() ??
                          false) {
                        authController.isValid = true;
                        authController.update();
                      } else {
                        authController.isValid = false;
                        authController.update();
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight6,
                        appBar(),
                        sizedBoxHeight20,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.isSocial
                                    ? AppLocalizations.of(context)!
                                        .profile_details
                                    : AppLocalizations.of(context)!.register,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xffFFFDFD),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                ),
                              ),
                              sizedBoxHeight16,
                              TextFormField(
                                initialValue: authController.mobile,
                                validator: ((value) {
                                  if (value?.isEmpty ?? true) {
                                    return AppLocalizations.of(context)!
                                        .valid_mobile_no;
                                  } else if (value?.length != 8) {
                                    return AppLocalizations.of(context)!
                                        .mobile_no_format;
                                  } else {
                                    return null;
                                  }
                                }),
                                onChanged: (value) {
                                  authController.mobile = value;
                                  authController.update();
                                },
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Color(0xff0A0909),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .enter_phone_no,
                                ),
                              ),
                              sizedBoxHeight10,
                              Visibility(
                                visible: !widget.isSocial,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _pass,
                                      validator: ((value) {
                                        if (value?.isEmpty ?? true) {
                                          return AppLocalizations.of(context)!
                                              .valid_password;
                                        } else if ((value?.length ?? 0) < 5) {
                                          return AppLocalizations.of(context)!
                                              .password_format;
                                        } else {
                                          return null;
                                        }
                                      }),
                                      onChanged: (value) {},
                                      obscureText: true,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(
                                        color: Color(0xff0A0909),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .enter_password,
                                      ),
                                    ),
                                    sizedBoxHeight10,
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !widget.isSocial,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: ((value) {
                                        if (value != _pass.text) {
                                          return AppLocalizations.of(context)!
                                              .passwords_mismatch;
                                        } else {
                                          passwordsMatch = true;
                                        }
                                      }),
                                      onChanged: (value) {
                                        if (passwordsMatch == true) {
                                          authController.password = value;
                                          authController.update();
                                        }
                                      },
                                      obscureText: true,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(
                                        color: Color(0xff0A0909),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .enter_password_again,
                                      ),
                                    ),
                                    sizedBoxHeight10,
                                  ],
                                ),
                              ),
                              TextFormField(
                                initialValue: authController.name,
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? AppLocalizations.of(context)!
                                            .name_required
                                        : null,
                                onChanged: (value) {
                                  authController.name = value;
                                  authController.update();
                                },
                                keyboardType: TextInputType.name,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Color(0xff0A0909),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .enter_fullname,
                                ),
                              ),
                              sizedBoxHeight10,
                              TextFormField(
                                initialValue: authController.email,
                                validator: validateEmail,
                                onChanged: (value) {
                                  authController.email = value;
                                  authController.update();
                                },
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Color(0xff0A0909),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.enter_email,
                                ),
                              ),
                              sizedBoxHeight10,
                              TextFormField(
                                validator: (value) => (value == null ||
                                        value.isEmpty)
                                    ? AppLocalizations.of(context)!.dob_required
                                    : null,
                                controller: _dobController,
                                readOnly: true,
                                onChanged: (value) {},
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now()
                                        .subtract(const Duration(days: 5475)),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 29200)),
                                    lastDate: DateTime.now()
                                        .subtract(const Duration(days: 5475)),
                                    builder: (context, child) => Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    primary:
                                                        Color(0xffFAAF4A))),
                                        child: child!),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat("yyyy-MM-dd")
                                            .format(pickedDate);

                                    setState(() {
                                      _dobController.text =
                                          formattedDate.toString();
                                      authController.age = formattedDate;

                                      authController.update();
                                    });
                                  }
                                },
                                keyboardType: TextInputType.datetime,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Color(0xff0A0909),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.dob,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                          "assets/images/calender_icon.svg"),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                ),
                              ),
                              sizedBoxHeight10,
                              TextFormField(
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? AppLocalizations.of(context)!
                                            .gender_required
                                        : null,
                                readOnly: true,
                                onChanged: (value) {},
                                controller: _genderController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Color(0xff0A0909),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(context)!.gender,
                                    suffixIcon: PopupMenuButton<String>(
                                      itemBuilder: (BuildContext context) {
                                        return items.map<PopupMenuItem<String>>(
                                            (Map<String, String> value) {
                                          return PopupMenuItem(
                                              value: value.keys.first,
                                              child: Text(
                                                value.values.first,
                                                style: const TextStyle(
                                                  color: Color(0xff0A0909),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ));
                                        }).toList();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                      onSelected: (String value) {
                                        _genderController.text = items
                                            .firstWhere((element) =>
                                                element.keys.first == value)
                                            .values
                                            .first;
                                        authController.gender = value;
                                        authController.update();
                                      },
                                    )),
                              ),
                              sizedBoxHeight40,
                              LoginButton(
                                height: 52,
                                title: AppLocalizations.of(context)!.sign_up,
                                enabled: widget.isSocial
                                    ? authController.isValid
                                    : authController.isValid && passwordsMatch,
                                onTap: () {
                                  if (widget.isSocial) {
                                    authController.registersocial(
                                      onSuccess: widget.onSuccess,
                                    );
                                  } else {
                                    authController.signUp(
                                      onSuccess: widget.onSuccess,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
