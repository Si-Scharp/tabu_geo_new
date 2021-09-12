import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_geo_new/bloc/game_bloc/game_bloc.dart';
import 'package:tabu_geo_new/widgets/card_buttons.dart';
import 'package:tabu_geo_new/widgets/concentric_card_view.dart';

import 'linear_score_bar.dart';

class NewConcentricPlayPage extends StatelessWidget {
  NewConcentricPlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      builder: (context, state) {
        var bloc = context.read<GameBloc>();

        if (state is GameLoadingState)
          return Center(
            child: Text("Das spiel wird geladen"),
          );

        if (state is GameReadyState)
          return Scaffold(
              appBar: AppBar(),
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: LinearScoreBar(teamStatistics: state.teamStatistics, totalCards: state.totalCards),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 500, width: 500),
                      child: SizedBox.expand(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ConcentricCardView(
                                teamNumber: state.currentTeamNumber,
                                revealed: state is GameCardShownState,
                                card: (state is GameCardShownState) ? state.card : null,
                                onTap: () => context.read<GameBloc>().add(CardRevealedEvent()),
                              ),
                            ),
                            SizedBox(height: 30,
                              child: (state is GameCardShownState)
                                  ? CardButtons(
                                      buttonState: state.buttonState,
                                      clickedCorrectButton: () {
                                        bloc.add(GuessingResultSubmittedEvent(true));
                                      },
                                      clickedDoneButton: () => bloc.add(GuessingResultConfirmedEvent()),
                                      clickedUndoButton: () => bloc.add(UndoResultEvent()),
                                      clickedWrongButton: () => bloc.add(GuessingResultSubmittedEvent(false)),
                                    )
                                  : SizedBox.shrink(),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
        else
          throw UnimplementedError("This State of type ${state.runtimeType} has not been handled");
      },
      listener: (context, state) {},
    );
  }
}

extension _ListExt<T> on List<T?> {
  List<T> rmNull() => ((this..removeWhere((element) => element == null)) as List<T>);
}
