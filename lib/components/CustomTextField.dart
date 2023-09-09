import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iPizzo/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  String? hintText;
  Icon? prefixIcon;
  TextEditingController txtCtrl;
  dynamic obscureText;
  IconButton? suffixButton;
  bool? IsCenter; //true is center -- false is left alignment
  bool? IsNum;
  double height;
  double width;
  TextStyle? textStyle;
  Color? bgColor;

  CustomTextField({
    required this.txtCtrl,
    this.prefixIcon,
    this.suffixButton,
    this.hintText,
    this.obscureText = false,
    required this.height,
    required this.width,
    this.IsCenter = false,
    this.IsNum = false,
    this.textStyle,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // size provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * widget.width, // use 0.8 on the custom textfield object
      height: size.height * widget.height, // use 0.08
      child: TextField(
        maxLines: 1,
        controller: widget.txtCtrl,
        style: widget.textStyle,
        textAlign: widget.IsCenter != false ? TextAlign.center : TextAlign.left,
        obscureText: widget.obscureText,
        inputFormatters: widget.IsNum == true ? [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))] : null,
        keyboardType: widget.IsNum == true
            ? const TextInputType.numberWithOptions(
                decimal: true,
              )
            : TextInputType.text,

        //decoration
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
          filled: true,
          fillColor: bgColor,
          contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.05),
          prefixIconConstraints: const BoxConstraints(minWidth: 55, minHeight: 60),
          suffixIcon: widget.suffixButton,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
