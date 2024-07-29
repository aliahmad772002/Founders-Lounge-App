// import 'package:flutter/material.dart';
// import 'package:fouders_longe/Controlllers/comment_controller.dart';

// class EditCommentDialog extends StatefulWidget {
//   final String postID;
//   final String commentID;
//   final String initialComment;

//   EditCommentDialog({
//     required this.postID,
//     required this.commentID,
//     required this.initialComment,
//   });

//   @override
//   _EditCommentDialogState createState() => _EditCommentDialogState();
// }

// class _EditCommentDialogState extends State<EditCommentDialog> {
//   final TextEditingController _commentController = TextEditingController();
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _commentController.text = widget.initialComment;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Edit Comment'),
//       content: TextField(
//         controller: _commentController,
//         decoration: InputDecoration(labelText: 'Enter your comment'),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _isUpdating
//               ? null // Disable the button while updating
//               : () async {
//                   // Call the method to update the comment
//                   setState(() {
//                     _isUpdating = true;
//                   });

//                   try {
//                     await CommentController.instance.updateComment(
//                       widget.postID,
//                       widget.commentID,
//                       _commentController.text,
//                     );

//                     // Comment updated successfully
//                     Navigator.of(context).pop(); // Close the dialog
//                   } catch (e) {
//                     // Handle errors during comment update
//                     print('Error updating comment: $e');
//                     // You can show an error message or handle it as needed
//                   } finally {
//                     setState(() {
//                       _isUpdating = false;
//                     });
//                   }
//                 },
//           child: _isUpdating
//               ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//               : Text('Save'),
//         ),
//       ],
//     );
//   }
// }
