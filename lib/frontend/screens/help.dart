import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

@override
 Widget build(BuildContext context) {
  return Scaffold(
     body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center, 
           children: [
             const Text(
               'Help page',
             ),
           ],
         ),
       ),
     );
   }
 }