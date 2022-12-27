import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: ((value) {
            inputStr = value;
          }),
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // add an event to the bloc - concrete
                  addConcrete();
                },
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // add an event to the bloc - random
                  addRandom();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: const Text('Random'),
              ),
            )
          ],
        )
      ],
    );
  }

  void addConcrete() {
    // Print is for testing purposes
    print(inputStr);
    controller.clear();
    // BlocProvider is an InheritedWidget and we must specify what type of bloc it is, in our case it's NumberTriviaBloc
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
    // reseting the inputStr value to show the invalid input error
    inputStr = '';
  }

  void addRandom() {
    controller.clear();
    // BlocProvider is an InheritedWidget and we must specify what type of bloc it is, in our case it's NumberTriviaBloc
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
