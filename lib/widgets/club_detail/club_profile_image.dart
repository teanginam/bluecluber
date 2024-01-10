import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/models/club.dart';
import 'package:tttttt/providers/club_provider.dart';

class ClubProfileImage extends StatelessWidget {
  const ClubProfileImage({
    super.key,
    required this.id,
    required this.club,
  });

  final String id;
  final Club club;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 프로필사진 변경 옵션
        _showActionSheet(context);
      },
      child: club.imgUrl.isEmpty
          ? Container(
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white),
            )
          : CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: club.imgUrl,
              imageBuilder: ((context, imageProvider) => Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  )),
              placeholder: (context, url) => Container(
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
    );
  }

  // 프로필사진 변경 옵션
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('프로필 사진 설정'),
        // message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              Provider.of<ClubProvider>(context, listen: false)
                  .changeClubProfile(id);
              Navigator.pop(context);
            },
            child: const Text('이미지 변경'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Provider.of<ClubProvider>(context, listen: false)
                  .deleteClubProfile(id);
              Navigator.pop(context);
            },
            child: const Text('이미지 삭제'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
}
