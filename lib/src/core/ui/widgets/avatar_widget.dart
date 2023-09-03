import 'package:dw_barbershop/src/core/ui/barbershop_icons.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  bool hideUploadButton;
  AvatarWidget({super.key, this.hideUploadButton = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      width: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.avatar),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: ColorsConstants.brown, width: 3)),
                child: const Icon(
                  BarbershopIcons.addEmployee,
                  size: 20,
                  color: ColorsConstants.brown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
