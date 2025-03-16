import 'package:flutter/material.dart';



class ComponentResultTile extends StatelessWidget {
  const ComponentResultTile({super.key,
    required this.language,
    required this.resultText
  });

  final String language;
  final String resultText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(language, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ),
          Container(
            height: 200,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color(0xfffafafa),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(resultText)
          )
        ]
      ),
    );
  }
}