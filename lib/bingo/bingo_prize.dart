import 'package:penalty_game/asset_paths.dart';

enum BingoPrize {
  drink,
  gift;

  String get assetPath => switch (this) {
        BingoPrize.drink => '${AssetPaths.bingoImages}open_drink.png',
        BingoPrize.gift => '${AssetPaths.bingoImages}open_gift.png',
      };
}
