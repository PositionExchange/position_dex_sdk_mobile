/// @author Musket
import 'package:decimal/decimal.dart';

class UserLiquidity {
  double liquidityAmount = 0;
  double baseAmount = 0;
  double quoteAmount = 0;
  double feeGrowthBase = 0;
  double feeGrowthQuote = 0;
  int indexPipRange = 0;

  UserLiquidity(
      {required this.baseAmount,
      required this.quoteAmount,
      required this.feeGrowthBase,
      required this.feeGrowthQuote,
      required this.liquidityAmount,
      required this.indexPipRange});

  UserLiquidity.init();
}
