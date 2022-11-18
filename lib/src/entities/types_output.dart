/// @author Musket

class RemoveLiquidityOutput {
  num baseAmount = 0;
  num quoteAmount = 0;

  RemoveLiquidityOutput({required this.quoteAmount, required this.baseAmount});

  RemoveLiquidityOutput.init();
}

class FeeRewardOutput {
  num baseFeeReward = 0;

  num quoteFeeReward = 0;

  FeeRewardOutput({required this.quoteFeeReward, required this.baseFeeReward});

  FeeRewardOutput.init();
}

class ShiftRangeOutput {
  num needBaseAmount = 0;
  num needQuoteAmount = 0;
  num receiveBaseAmount = 0;
  num receiveQuoteAmount = 0;

  ShiftRangeOutput(
      {required this.needBaseAmount,
      required this.needQuoteAmount,
      required this.receiveBaseAmount,
      required this.receiveQuoteAmount});

  ShiftRangeOutput.init();
}

class AddLiquidityOutput {
  num quoteAmount = 0;
  num baseAmount = 0;
  num liquidityAmount = 0;

  AddLiquidityOutput(
      {required this.quoteAmount,
      required this.liquidityAmount,
      required this.baseAmount});

  AddLiquidityOutput.init();
}
