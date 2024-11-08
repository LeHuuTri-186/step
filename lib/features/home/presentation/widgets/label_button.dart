import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelButton extends StatelessWidget {
  const LabelButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  final Function() onTap;
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: color,
              width: 0.2,
            ),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          highlightColor: Colors.teal.shade50,
          splashColor: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: GoogleFonts.varelaRound(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}