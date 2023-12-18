import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import '../../components/course/course_card.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  late Future<List<Course>> futureCourses;
  @override
  void initState() {
    super.initState();
    futureCourses = CourseService.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    var keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Courses"),
        ),
        body: Column(children: [
          FutureBuilder(
            future: futureCourses,
            builder: (context, AsyncSnapshot<List<Course>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Course>? courses = snapshot.data;
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: SearchAnchor.bar(
                      barHintText: 'Search courses',
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        return getSuggestions(controller, courses!);
                      },
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8 -
                          keyBoardHeight,
                      child: ListView.builder(
                        itemCount: courses!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          return CourseCard(course: courses[index]);
                        },
                      ))
                ]);
              }
            },
          ),
        ]));
  }

  Iterable<Widget> getSuggestions(
      SearchController controller, List<Course> courses) {
    final String input = controller.value.text.toLowerCase();
    return courses
        .where((Course course) => course.title.toLowerCase().contains(input))
        .map(
          (Course filteredCourse) => CourseCard(course: filteredCourse),
        );
  }

  void handleSelection(Course selectedCourse) {
    Navigator.of(context)
        .pushNamed('/courseDetails', arguments: {'instructor': selectedCourse});
  }
}
