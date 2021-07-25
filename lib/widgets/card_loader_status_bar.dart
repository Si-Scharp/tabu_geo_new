import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_geo_new/bloc/card_cubit/card_loader_cubit.dart';

class CardLoaderStatusBar extends StatelessWidget {
  const CardLoaderStatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardLoaderCubit, CardLoaderState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(6),
          color: Theme.of(context).primaryColorDark,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  _generateStatusMessage(state),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              (state is CardsLoadingState)
                  ? SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: () =>
                          context.read<CardLoaderCubit>().loadCards(context),
                      child: Text("Lade Karten")),
              (state is CardsLoadingErrorState)
                  ? ElevatedButton(
                      onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error:"),
                              content: SelectableText(state.errorMessage ??
                                  "error message missing"),
                            ),
                          ),
                      child: Text("Zeige Fehler"))
                  : SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }

  String _generateStatusMessage(CardLoaderState state) {
    String cachedMessage = "";
    if (state is CardsLoadedState)
      return "Die Kartendaten wurden geladen. Es gibt ${state.cards.length} Karten";
    if (state is CardsLoadingErrorState)
      return "Die Karten konnten aufgrund eines Fehlers nicht geladen werden. Bitte lade die Seite neu";
    if (state is CardsNotLoadedState)
      return "Die Karten wurden (noch) nicht geladen";
    if (state is CardsLoadingState)
      return "Die Karten werden geladen. Die App ist noch nicht ganz funktionsfähig";
    return "Das sollte niemals gelesen werden";
  }
}
