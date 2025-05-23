import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWithDivider extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;

  const SearchWithDivider({
    super.key,
    this.controller,
    this.hintText = "Search",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search_rounded),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        const Divider(),
        SizedBox(height: 10.h),
      ],
    );
  }
}
