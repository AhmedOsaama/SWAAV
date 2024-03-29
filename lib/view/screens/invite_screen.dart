import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/widgets/backbutton.dart';
import 'package:swaav/view/widgets/share_option_widget.dart';

class InviteScreen extends StatelessWidget {
  InviteScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyBackButton(),
                Spacer(),
                Text("Invite Friends",style: TextStyles.textViewBold20,),
                Spacer(),
              ],
            ),
            SizedBox(height: 80.h,),
            Container(
              width: double.infinity,
              height: 173.h,
              color: Color.fromRGBO(217, 217, 217, 1),
              child: Center(
                child:
                Text("Picture of friends/people",style: TextStyles.textViewRegular12,),
              ),
            ),
            SizedBox(height: 30.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  ShareOption(optionFunction: (){}, optionName: "WP"),
                  ShareOption(optionFunction: (){}, optionName: "..."),
              ],
            ),
            SizedBox(height: 30.h,),
            GenericField(controller: emailController,validation: (value){
              if(!value!.contains("@") || !value.endsWith(".com")){
                return "INVALID EMAIL ADDRESS";
              }
              return null;
            },
              isFilled: true,
              hintText: "Email",
            ),
            SizedBox(height: 50.h,),
            GenericButton(onPressed: (){}, child: Text("Send",style: TextStyles.textViewBold15,),borderRadius: BorderRadius.circular(10),)
          ],
        ),
      ),
    );
  }
}
