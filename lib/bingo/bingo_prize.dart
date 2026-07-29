import 'package:penalty_game/asset_paths.dart';

enum BingoPrize {
  drink,
  gift,
  thankyou;

  String get assetPath => switch (this) {
        BingoPrize.drink => '${AssetPaths.bingoImages}open_drink.png',
        BingoPrize.gift => '${AssetPaths.bingoImages}open_gift.png',
        BingoPrize.thankyou => '${AssetPaths.bingoImages}open_thankyou.png',
      };

  bool get isWinning => this == BingoPrize.drink || this == BingoPrize.gift;

  String get debugLabel => switch (this) {
        BingoPrize.drink => 'Ундаа',
        BingoPrize.gift => 'Бэлэг',
        BingoPrize.thankyou => 'Баярлалаа',
      };
}
