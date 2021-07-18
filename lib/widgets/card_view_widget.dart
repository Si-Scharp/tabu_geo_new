import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tabu_geo_new/models/geo_card.dart';

class CardViewWidget extends StatelessWidget {
  GeoCard card;

  CardViewWidget(this.card);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Titel
      Text(
        card.term,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      //Definition
      card.definition == null
          ? SizedBox()
          : Text(
              card.definition!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
      //Verbotene Wörter
      card.forbiddenWords == null || card.forbiddenWords!.length == 0
          ? SizedBox()
          : Column(
              children: card.forbiddenWords!
                  .map<Widget>((e) => Text(
                        e,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.red),
                      ))
                  .toList()),
      //Bild
      card.image == null ? SizedBox() : Expanded(child: ExtendedImage.network(card.image!.url, fit: BoxFit.contain))
    ]);
  }
}
