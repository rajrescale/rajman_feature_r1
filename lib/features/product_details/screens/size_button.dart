import 'package:dalvi/constants/global_variables.dart';
import 'package:flutter/material.dart';

class SizeButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool index;
  const SizeButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.0),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              index ? Theme.of(context).primaryColor : Colors.white,
          side: BorderSide(
            color: index
                ? GlobalVariables.specialColor
                : Theme.of(context)
                    .primaryColor, // Change outline border color based on index
            width: 1.0, // Set outline border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: index ? Colors.white : GlobalVariables.specialGray,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
