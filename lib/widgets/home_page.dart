import "package:flutter/material.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";
import 'package:tabu_geo_new/bloc/card_cubit/card_loader_cubit.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/widgets/card_loader_status_bar.dart';
import 'package:tabu_geo_new/widgets/play_page.dart';
import 'package:tabu_geo_new/widgets/settings_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PanelController _panelController;
  @override
  void initState() {
    _panelController = PanelController();

    super.initState();
  }

  Widget _buildPanelHeader() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _panelController.isAttached &&
                    !_panelController.isPanelOpen &&
                    !_panelController.isPanelClosed
                ? null
                : () => _panelController.isPanelOpen
                    ? _panelController.close()
                    : _panelController.open(),
            child: SizedBox.shrink(),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
                shape: MaterialStateProperty.all(StadiumBorder()),
                minimumSize: MaterialStateProperty.all(Size(1, 1)),
                fixedSize: MaterialStateProperty.all(Size(100, 10)))),
        Text(
          "Einstellungen",
          style: Theme.of(context).textTheme.headline6,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 50,
        onPanelSlide: (_) => setState(() {}),

        controller: _panelController,
        body: ListView(
          children: [
            CardLoaderStatusBar(),
            BlocBuilder<CardLoaderCubit, CardLoaderState>(
              builder: (context, state) {
                return ListTile(
                  enabled: state is CardsLoadedState,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlayPage(
                        cards: (context.read<CardLoaderCubit>().state
                                as CardsLoadedState)
                            .cards,
                        gameSettings: GameSettings()),
                  )),
                  title: Text("Spielen"),
                );
              },
            ),
            ListTile(title: Text("Kompatibilitätshinweis"),subtitle: Text("Nutze auf iOS Safari, sonst Chrome oder Chromium-basierende browser"),)
          ],
        ),

        isDraggable: true,
        //minHeight: 30,
        defaultPanelState: PanelState.CLOSED,

        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        panel: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600, minWidth: 60),
            child: Column(
              children: [
                _buildPanelHeader(),
                SettingsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
