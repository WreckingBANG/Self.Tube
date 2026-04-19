import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget{
  final List<ButtonRowItem> items;
  final int selectedItem;
  final ValueChanged<int> onSelected;
  
  ButtonRow({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: 
            index == selectedItem
              ? FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      if (items[index].icon != null)
                        Padding(
                          padding: EdgeInsets.only(right: 2.5),
                          child: Icon(
                            items[index].icon,
                            size: 15,
                          ),
                        ),
                        Text(
                        items[index].title,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ) 
                )
              : FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: _buildShape(index, items.length),
                  ), 
                  onPressed: () => onSelected(index),
                  child: Row(
                    children: [
                      if (items[index].icon != null)
                        Padding(
                          padding: EdgeInsets.only(right: 2.5),
                          child: Icon(
                            items[index].icon,
                            size: 15,
                          ),
                        ),
                      Text(
                        items[index].title,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                )
            );
          }
        )  
      ],
    );
  }

  RoundedRectangleBorder _buildShape(int index, int total) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: index == 0
          ? const Radius.circular(20)
          : const Radius.circular(5),
        right: index == total - 1
          ? const Radius.circular(20)
          : const Radius.circular(5)
      )
    );
  }
}

class ButtonRowItem {
  final String title;
  final IconData? icon;

  const ButtonRowItem({
    required this.title,
    this.icon
  });
}
