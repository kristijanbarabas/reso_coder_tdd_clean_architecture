import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reso_coder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
        ),
        // in the BlocProvider we inject our dependency from the injection container
        body: SingleChildScrollView(child: buildBody(context: context)));
  }

  BlocProvider<NumberTriviaBloc> buildBody({required BuildContext context}) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              // Top half of the screen with a fixed height (1/3 of the entire screen)
              // This half handles displaying of the number and text for the fetched trivia
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return const Text('Test');
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              // Bottom half
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
