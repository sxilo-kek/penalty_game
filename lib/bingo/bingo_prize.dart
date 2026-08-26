import 'package:penalty_game/asset_paths.dart';

enum BingoPrize {
  drink,
  thankyou;

  String get assetPath => switch (this) {
        BingoPrize.drink => '${AssetPaths.bingoImages}open_drink.png',
        BingoPrize.thankyou => '${AssetPaths.bingoImages}open_thankyou.png',
      };

  bool get isWinning => this == BingoPrize.drink;

  String get debugLabel => switch (this) {
        BingoPrize.drink => 'Ундаа',
        BingoPrize.thankyou => 'Баярлалаа',
      };
}
