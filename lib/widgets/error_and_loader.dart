import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyCategoriesWidget extends StatelessWidget {
  final VoidCallback onReload;
  const EmptyCategoriesWidget({Key? key, required this.onReload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height * 0.6;
    double width = MediaQuery.of(context).size.width * 0.7;
    if (height > width * 1.6) {
      height = width * 1.6;
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.7,
            child: SizedBox.expand(
                child: Container(
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "Комёб нашуд!\n"),
                TextSpan(
                  text: "Ба интернет пайваст шавед!\n",
                  style: theme.bodyText2!.copyWith(color: Colors.white),
                ),
                WidgetSpan(
                  child: TextButton(
                    onPressed: onReload,
                    child: Text(
                      "Инҷоро зер кунед".toUpperCase(),
                      style: theme.subtitle1!.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ]),
              textAlign: TextAlign.center,
              style: theme.headline5!.copyWith(color: Colors.white),
            ),
          )),
        ],
      ),
    );
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.6;
    double width = MediaQuery.of(context).size.width * 0.7;
    if (height > width * 1.6) {
      height = width * 1.6;
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.7,
            child: SizedBox.expand(
                child: Container(
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
