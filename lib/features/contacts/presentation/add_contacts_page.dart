import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../auth/presentation/widgets/textfield_widget.dart';

class AddContactsPage extends StatelessWidget {
  const AddContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('New contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            Center(
              child: Container(
                width: 300,
                height: 170,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Expanded(
                  child: MyTextField(
                    hintText: 'First name',
                    labeltext: 'First name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: MyTextField(
                    hintText: 'Last name',
                    labeltext: 'Last name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Expanded(
                  child: MyTextField(
                    hintText: 'Phone',
                    labeltext: 'Phone',
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Expanded(
                  child: MyTextField(
                    hintText: 'Address',
                    labeltext: 'Address',
                    obscureText: false,
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: MyTextField(
                    hintText: 'City',
                    labeltext: 'City',
                    obscureText: false,
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
