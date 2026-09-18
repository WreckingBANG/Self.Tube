import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> GoToPageDialog({
  required BuildContext context,
  required int lastPage,
  required ValueChanged<int> goToPage
}) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit() {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      goToPage(int.parse(controller.text));
      Navigator.pop(context);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Jump to Page", style: const TextStyle(fontSize: 20)),
            SizedBox(height: 5),
            ListSectionContainer(
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: controller,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                        
                      final int? page = int.tryParse(controller.text);

                      if (page == null) {
                        return "Cannot be empty";
                      }

                      if (page < 1 || page > lastPage) {
                        return "Value has to be between 1 and $lastPage";
                      }

                      return null;

                    },
                    onFieldSubmitted: (_) => submit(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.info, size: 15),
                      SizedBox(width: 2.5),
                      Text(
                        "Value must be between 1 and $lastPage",
                        style: TextStyle(fontSize: 12.5),
                      )
                    ],
                  )
                )
              ],
            ),
          ],
        ), 
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => submit(), 
            child: Text("Go To Page") 
          )
        ],
      );
    }
  );

}
