import 'package:flutter/material.dart';


class OtpDesign extends StatefulWidget {
  const OtpDesign({super.key});

  @override
  State<OtpDesign> createState() => _OtpDesignState();
}
TextEditingController countryCode = TextEditingController();

class _OtpDesignState extends State<OtpDesign> {

  @override
  Widget build(BuildContext context) {
    countryCode.text = "+91";
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Container(
            height: 50,
            width: 800,
            color: Colors.blue,
            child: Row(
            children: [
              Container(
                width: 50,
                color: Colors.white,
               child: TextFormField(
                 controller: countryCode,
                ),
              ),
              Container(
                width: 250,
                color: Colors.white,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter Phone Number",
                  ),
                ),
              ),
            ],
            ),
          ),
          ElevatedButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpCode(),));
          }, child: const Text("Submit"))
        ],
      ))
    );
  }
}
