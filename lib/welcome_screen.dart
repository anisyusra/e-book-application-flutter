import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:test1/colors.dart';
import 'package:test1/login.dart';
import 'package:test1/signup.dart';
import 'package:test1/sizes.dart';
import 'package:test1/text_strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage("assets/Picture1.png"), height: height*0.6,),
            Column( 
              children: [
                Text(
                  tWelcomeTitle, 
                  style: Theme.of(context).textTheme.headline3
                ),
                Text(
                  tWelcomeSubTItle, 
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
                    },
                    child: Text(tLogin.toUpperCase()),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrationScreen(),
                ));}, 
                    child: Text(tSignUp.toUpperCase())
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}