import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/category/category_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';

class CategoryIncome extends StatelessWidget {
  final CategoryModel? data;
  CategoryIncome({Key? key, this.data}) : super(key: key);

//final _addtextController = TextEditingController();
  final addcategoryContyroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        (CategoryTiles()),
        //Expanded(child: tapListtile(name: data!.name,))
      ],
    );
  }
}

class CategoryTiles extends StatelessWidget {
  final CategoryModel? data;
  const CategoryTiles({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    return GestureDetector(
      child: Container(
          width: 39.h,
          height: 50.h,
          //color: Colors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ValueListenableBuilder(
              valueListenable: CategoryDB().incomeCategoryListNotifier,
              builder:
                  (BuildContext ctx, List<CategoryModel> newList, _) {
                return newList.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Please Add categories",
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                          const Icon(
                            Icons.warning,
                            color: Colors.white,
                          ),
                        ],
                      )
                    : GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 19.0,
                        mainAxisSpacing: 19.0,
                        children: List.generate(newList.length, (index) {
                          final category = newList[index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () => showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Categorydelete(category: category);
                                  },
                                ), //ShowcategorydeletePopup(context),

                                child: Container(
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 142, 139, 139),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 243, 238, 237)),
                                  child: Center(
                                    child: Text(category.name),
                                  ),
                                ),
                              ));
                        }));
              })),
    );
  }
}

class Categorydelete extends StatelessWidget {
  const Categorydelete({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Delete this category"),
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  CategoryDB.instance.DeleteCategory(category.id);

                  Navigator.of(context).pop();
                },
                child: const Text("Yes")),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("no")),
          ],
        ),
      ],
    );
  }
}
