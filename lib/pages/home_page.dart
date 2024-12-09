import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint/providers/drawing_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_painter.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrawingProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    // Color picker dialog
    void selectColor() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Color Chooser'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: provider.selectedColor,
                onColorChanged: (color) {
                  provider.setColor(color);
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ])),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/createPair'),
                  child: Text('Create Pair'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * 0.80,
                    height: height * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onPanStart: (details) {
                        provider.startDrawing(details.localPosition);
                      },
                      onPanUpdate: (details) {
                        provider.updateDrawing(details.localPosition);
                      },
                      onPanEnd: (details) {
                        provider.endDrawing();
                      },
                      child: SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(
                              points: provider.points,
                              currentStroke: provider.currentStroke,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Wrap the Row in an Expanded to avoid layout issues
                Expanded(
                  child: Container(
                    width: width * 0.80,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.color_lens,
                            color: provider.selectedColor,
                          ),
                          onPressed: selectColor,
                        ),
                        Expanded(
                          child: Slider(
                            min: 1.0,
                            max: 5.0,
                            label: "Stroke ${provider.strokeWidth}",
                            activeColor: provider.selectedColor,
                            value: provider.strokeWidth,
                            onChanged: (double value) {
                              provider.setStrokeWidth(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.layers_clear,
                            color: Colors.black,
                          ),
                          onPressed: provider.clear,
                        ),
                        IconButton(
                          icon: Icon(
                            provider.isEraserActive
                                ? Icons.delete
                                : Icons.highlight_remove,
                            color: Colors.black,
                          ),
                          onPressed: provider.toggleEraser,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
