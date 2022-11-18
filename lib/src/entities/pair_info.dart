/// @author Musket
import 'package:decimal/decimal.dart';

class PairInfo {
  late int currentIndexPipRange;
  late double currentPrice;
  late int pipRange;
  late int basisPoint;
  late Map<int, LiquidityInfo>? liquidityInfo;

  PairInfo(
      {required this.currentIndexPipRange,
      required this.currentPrice,
      required this.pipRange,
      required this.basisPoint,
      required this.liquidityInfo});
}

class LiquidityInfo {
  late double baseReal;
  late double quoteReal;
  late double feeGrowthBase;
  late double feeGrowthQuote;
  late double liquidityAmount;
  late double priceMax;
  late double priceMin;

  LiquidityInfo(
      {required this.baseReal,
      required this.quoteReal,
      required this.feeGrowthQuote,
      required this.feeGrowthBase,
      required this.liquidityAmount,
      required this.priceMax,
      required this.priceMin});
}
