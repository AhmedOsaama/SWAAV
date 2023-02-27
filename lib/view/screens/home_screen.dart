import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/providers/products_provider.dart';
import 'package:swaav/services/network_services.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/screens/product_detail_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/widgets/category_widget.dart';
import 'package:swaav/view/widgets/discountItem.dart';
import 'package:swaav/view/widgets/product_item.dart';
import 'package:swaav/view/widgets/search_item.dart';

import '../../config/routes/app_navigator.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../components/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  late Future<int> getAllProductsFuture;
  List allProducts = [];
  @override
  void initState() {
    super.initState();
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    DynamicLinkService().listenToDynamicLinks(
        context); //case 2 the app is open but in background and opened again via deep link
  }

  @override
  void didChangeDependencies() {
    getAllProductsFuture =
        Provider.of<ProductsProvider>(context, listen: false).getAllProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Text(
                          style: TextStylesDMSans.textViewBold22
                              .copyWith(color: prussian),
                          'Hello, ' + snapshot.data!['username'],
                        );
                      }),
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        return snapshot.data!['imageURL'] != ""
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data!['imageURL']),
                                radius: 30,
                              )
                            : SvgPicture.asset(personIcon);
                      }),
                  // GenericButton(
                  //     onPressed: () async {
                  //       var pref = await SharedPreferences.getInstance();
                  //       pref.setBool("rememberMe", false);
                  //       var isGoogleSignedIn =
                  //           await Provider.of<GoogleSignInProvider>(context,
                  //                   listen: false)
                  //               .googleSignIn
                  //               .isSignedIn();
                  //       if (isGoogleSignedIn) {
                  //         await Provider.of<GoogleSignInProvider>(context,
                  //                 listen: false)
                  //             .logout();
                  //       } else {
                  //         FirebaseAuth.instance.signOut();
                  //       }
                  //       AppNavigator.pushReplacement(
                  //           context: context, screen: RegisterScreen());
                  //       print("SIGNED OUT...................");
                  //     },
                  //     borderRadius: BorderRadius.circular(10),
                  //     height: 31.h,
                  //     width: 100.w,
                  //     child: Text(
                  //       "Log out",
                  //       style: TextStyles.textViewBold12,
                  //     )),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              GenericField(
                isFilled: true,
                onTap: () =>
                    showSearch(context: context, delegate: MySearchDelegate()),
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                hintStyle:
                    TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                height: 100.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryWidget(
                      categoryImagePath: vegetables,
                      categoryName: LocaleKeys.vegetables.tr(),
                      color: Colors.green,
                    ),
                    CategoryWidget(
                      categoryImagePath: fruits,
                      categoryName: LocaleKeys.fruits.tr(),
                      color: Colors.red,
                    ),
                    CategoryWidget(
                      categoryImagePath: beverages,
                      categoryName: LocaleKeys.beverages.tr(),
                      color: Colors.yellow,
                    ),
                    CategoryWidget(
                      categoryImagePath: grocery,
                      categoryName: LocaleKeys.grocery.tr(),
                      color: Colors.deepPurpleAccent,
                    ),
                    CategoryWidget(
                      categoryImagePath: edibleOil,
                      categoryName: LocaleKeys.edibleOil.tr(),
                      color: Colors.cyan,
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 30.h,
              // ),
              // Text(
              //   LocaleKeys.recentSearches.tr(),
              //   style:
              //       TextStylesDMSans.textViewBold16.copyWith(color: prussian),
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // Container(
              //   height: 260.h,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       ProductItemWidget(
              //         price: "8.00",
              //         fullPrice: "1.55",
              //         name: "Fresh Peach",
              //         description: "dozen",
              //         imagePath: peach,
              //         onTap: () {},
              //       ),
              //       ProductItemWidget(
              //           onTap: () {},
              //           price: "8.00",
              //           fullPrice: "1.55",
              //           name: "Fresh Peach",
              //           description: "dozen",
              //           imagePath: peach),
              //       ProductItemWidget(
              //           onTap: () {},
              //           price: "8.00",
              //           fullPrice: "1.55",
              //           name: "Fresh Peach",
              //           description: "dozen",
              //           imagePath: peach),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                LocaleKeys.latestDiscounts.tr(),
                style:
                    TextStylesDMSans.textViewBold16.copyWith(color: prussian),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 250.h,
                child: FutureBuilder<int>(
                    future: getAllProductsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data != 200) {
                        return const Center(
                          child: Text(
                              "Something went wrong. Please try again later"),
                        );
                      }
                      allProducts =
                          Provider.of<ProductsProvider>(context, listen: false)
                              .allProducts;
                      print("\n RESPONSE: ${allProducts.length}");
                      return ListView.builder(
                        itemCount: allProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          var productName = allProducts[i]['Name'];
                          var imageURL = allProducts[i]['Image_url'];
                          var storeName = allProducts[i]['Store'];
                          var description = allProducts[i]['Description'];
                          var price = allProducts[i]['Current_price'];
                          var size = allProducts[i]['Size'];
                          return GestureDetector(
                            onTap: () => AppNavigator.push(
                                context: context,
                                screen: ProductDetailScreen(
                                  storeName: storeName,
                                  productName: productName,
                                  imageURL: imageURL,
                                  description: description,
                                  price: price,
                                  size: size,
                                )),
                            child: DiscountItem(
                                name: allProducts[i]['Name'],
                                imageURL: allProducts[i]['Image_url'],
                                priceBefore: allProducts[i]['Old_price'],
                                priceAfter:
                                    allProducts[i]['Current_price'].toString(),
                                measurement: allProducts[i]['Size']),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
//product Item

//discount item

}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    "Rice",
    "Bread",
    "Biscuits",
    "Milk"
  ]; //TODO: get suggestions from stored user searches
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          query = '';
        },
        child: Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: grey)),
            child: Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List allProducts =
        Provider.of<ProductsProvider>(context, listen: false).allProducts;
    print(allProducts.length);
    var searchResults = allProducts
        .where((product) => product['Name'].toString().contains(query))
        .toList();
    if(searchResults.isEmpty) return const Center(child: Text("No matches found :("),);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (ctx, i) {
          var productName = searchResults[i]['Name'];
          var imageURL = searchResults[i]['Image_url'];
          var storeName = searchResults[i]['Store'];
          var description = searchResults[i]['Description'];
          var price = searchResults[i]['Current_price'];
          var size = searchResults[i]['Size'];
          return GestureDetector(
            onTap: () => AppNavigator.push(
                context: context,
                screen: ProductDetailScreen(
                  storeName: storeName,
                  productName: productName,
                  imageURL: imageURL,
                  description: description, price: price, size: size,
                )),
            child: SearchItem(
              name: searchResults[i]['Name'],
              imageURL: searchResults[i]['Image_url'],
              currentPrice: searchResults[i]['Current_price'].toString(),
              size: searchResults[i]['Size'],
              store: searchResults[i]['Store'],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.recentSearches.tr(),
            style: TextStyles.textViewMedium20.copyWith(color: gunmetal),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (ctx, i) => const Divider(),
                itemCount: suggestions.length,
                itemBuilder: (ctx, i) {
                  final suggestion = suggestions[i];
                  return ListTile(
                    title: Text(suggestion),
                    leading: Icon(Icons.search),
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
