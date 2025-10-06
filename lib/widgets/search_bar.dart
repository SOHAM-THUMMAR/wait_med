import 'package:flutter/material.dart';

class HospitalSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const HospitalSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,
      left: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: "Search hospitals...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
