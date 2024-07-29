import 'package:flutter/material.dart';
import 'package:flutter_july25/utils/color_constants.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      this.onDelete,
      required this.title,
      required this.desc,
      required this.date,
      this.onEdit});
  final void Function()? onDelete;
  final void Function()? onEdit;
  final String title;
  final String desc;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    color: ColorConstants.mainblack,
                  )),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: ColorConstants.mainblack,
                  )),
            ],
          ),
          Text(
            desc,
            maxLines: 4,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: ColorConstants.mainblack,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(
                    color: ColorConstants.mainblack,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: ColorConstants.mainblack,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
