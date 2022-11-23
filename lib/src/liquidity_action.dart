/// @author Musket

import 'entities/entities.dart';
import 'package:position_dex_sdk/src/liquidity_formula.dart';

class LiquidityAction {
  AddLiquidityOutput calculateAddLiquidity(
      num amount, num targetIndexPipRange, TypeAsset type, PairInfo pairInfo) {
    var output = AddLiquidityOutput.init();

    num baseReal = 0;
    num quoteReal = 0;

    var liquidityInfo = pairInfo.liquidityInfo![targetIndexPipRange];

    if ((targetIndexPipRange < pairInfo.currentIndexPipRange) ||
        (targetIndexPipRange == pairInfo.currentIndexPipRange &&
            pairInfo.currentPrice == liquidityInfo!.priceMax)) {
      if (type == TypeAsset.base) return output;
      output.quoteAmount = amount;

      pairInfo.currentPrice = liquidityInfo!.priceMax;

      quoteReal = calculateQuoteRealFromQuoteVirtual(
          pairInfo.currentPrice, amount, liquidityInfo!.priceMin);
    } else if ((targetIndexPipRange > pairInfo.currentIndexPipRange) ||
        (targetIndexPipRange == pairInfo.currentIndexPipRange &&
            pairInfo.currentPrice == liquidityInfo!.priceMin)) {
      if (type == TypeAsset.quote) return output;
      output.baseAmount = amount;
      pairInfo.currentPrice = liquidityInfo!.priceMin;

      baseReal = calculateBaseRealFromBaseVirtual(
          pairInfo.currentPrice, amount, liquidityInfo!.priceMax);
    } else if (targetIndexPipRange == pairInfo.currentIndexPipRange) {
      if (type == TypeAsset.base) {
        output.baseAmount = amount;

        baseReal = calculateBaseRealFromBaseVirtual(
            pairInfo.currentPrice, amount, liquidityInfo!.priceMax);
        output.quoteAmount = calculateQuoteVirtualFromBaseReal(
            pairInfo.currentPrice,
            baseReal,
            liquidityInfo.priceMin,
            liquidityInfo.priceMax);
        quoteReal = calculateQuoteRealFromQuoteVirtual(
            pairInfo.currentPrice, output.quoteAmount, liquidityInfo.priceMin);
      }
      if (type == TypeAsset.quote) {
        output.quoteAmount = amount;
        quoteReal = calculateQuoteRealFromQuoteVirtual(
            pairInfo.currentPrice, amount, liquidityInfo!.priceMin);
        output.baseAmount = calculateBaseVirtualFromQuoteReal(
            pairInfo.currentPrice,
            quoteReal,
            liquidityInfo.priceMin,
            liquidityInfo.priceMax);
        baseReal = calculateBaseRealFromBaseVirtual(
            pairInfo.currentPrice, output.baseAmount, liquidityInfo.priceMax);
      }
    }
    output.liquidityAmount = baseReal != 0
        ? calculateLiquidity(baseReal, pairInfo.currentPrice, true)
        : calculateLiquidity(quoteReal, pairInfo.currentPrice, false);

    return output;
  }

  RemoveLiquidityOutput calculateRemoveLiquidity(
      UserLiquidity userLiquidity, PairInfo pairInfo) {
    var output = RemoveLiquidityOutput.init();

    var liquidityInfo = pairInfo.liquidityInfo![userLiquidity.indexPipRange];

    if ((userLiquidity.indexPipRange < pairInfo.currentIndexPipRange) ||
        (userLiquidity.indexPipRange == pairInfo.currentIndexPipRange &&
            pairInfo.currentPrice == liquidityInfo!.priceMax)) {
      output.quoteAmount = calculateQuoteByLiquidity(
          userLiquidity.liquidityAmount,
          liquidityInfo!.priceMin,
          liquidityInfo!.priceMax);
    } else if ((userLiquidity.indexPipRange > pairInfo.currentIndexPipRange) ||
        (userLiquidity.indexPipRange == pairInfo.currentIndexPipRange &&
            pairInfo.currentPrice == liquidityInfo!.priceMin)) {
      output.baseAmount = calculateBaseByLiquidity(
          userLiquidity.liquidityAmount,
          liquidityInfo!.priceMax,
          liquidityInfo!.priceMin);
    } else if (userLiquidity.indexPipRange == pairInfo.currentIndexPipRange) {
      output.quoteAmount = calculateQuoteByLiquidity(
          userLiquidity.liquidityAmount,
          liquidityInfo!.priceMin,
          pairInfo.currentPrice);
      output.baseAmount = calculateBaseByLiquidity(
          userLiquidity.liquidityAmount,
          liquidityInfo!.priceMax,
          pairInfo.currentPrice);
    }

    return output;
  }

  FeeRewardOutput calculateCollectFee(
      UserLiquidity userLiquidity, PairInfo pairInfo) {
    var output = FeeRewardOutput.init();
    var liquidityInfo = pairInfo.liquidityInfo![userLiquidity.indexPipRange];
    output.baseFeeReward =
        (liquidityInfo!.feeGrowthBase - userLiquidity.feeGrowthBase) *
            userLiquidity.liquidityAmount;

    output.quoteFeeReward =
        (liquidityInfo!.feeGrowthQuote - userLiquidity.feeGrowthQuote) *
            userLiquidity.liquidityAmount;

    return output;
  }

  ShiftRangeOutput calculateShiftRange(UserLiquidity userLiquidity,
      PairInfo pairInfo, num targetIndexPipRange, num amount, TypeAsset type) {
    var output = ShiftRangeOutput.init();

    var removeLiquidity = calculateRemoveLiquidity(userLiquidity, pairInfo);
    var collectFee = calculateCollectFee(userLiquidity, pairInfo);

    var baseReceiveEstimate =
        removeLiquidity.baseAmount + collectFee.baseFeeReward;
    var quoteReceiveEstimate =
        removeLiquidity.quoteAmount + collectFee.quoteFeeReward;

    AddLiquidityOutput addLiquidity = AddLiquidityOutput.init();
    if (amount > 0) {
      if (type == TypeAsset.base) {
        baseReceiveEstimate += amount;
      } else {
        quoteReceiveEstimate += amount;
      }

      addLiquidity = calculateAddLiquidity(
          type == TypeAsset.base ? baseReceiveEstimate : quoteReceiveEstimate,
          targetIndexPipRange,
          type,
          pairInfo);
    } else {
      addLiquidity = calculateAddLiquidity(
          targetIndexPipRange > userLiquidity.indexPipRange
              ? userLiquidity.baseAmount
              : userLiquidity.quoteAmount,
          targetIndexPipRange,
          targetIndexPipRange > userLiquidity.indexPipRange
              ? TypeAsset.base
              : TypeAsset.quote,
          pairInfo);
    }

    if (removeLiquidity.quoteAmount + collectFee.quoteFeeReward >
        addLiquidity.quoteAmount) {
      output.receiveQuoteAmount = removeLiquidity.quoteAmount +
          collectFee.quoteFeeReward -
          addLiquidity.quoteAmount;
    } else {
      output.needQuoteAmount = addLiquidity.quoteAmount -
          removeLiquidity.quoteAmount -
          collectFee.quoteFeeReward;
    }

    if (removeLiquidity.baseAmount + collectFee.baseFeeReward >
        addLiquidity.baseAmount) {
      output.receiveBaseAmount = removeLiquidity.baseAmount +
          collectFee.baseFeeReward -
          addLiquidity.baseAmount;
    } else {
      output.needBaseAmount = addLiquidity.baseAmount -
          removeLiquidity.baseAmount -
          collectFee.baseFeeReward;
    }
    return output;
  }
}
