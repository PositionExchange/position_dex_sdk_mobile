import 'package:flutter_test/flutter_test.dart';

import 'package:position_dex_sdk/position_dex_sdk.dart';
import 'package:position_dex_sdk/src/entities/entities.dart';

import 'utils.dart';

void main() {
  const basicPoint = 10000;
  const pipRange = 30000;

  group("add-liquidity", () {
    test("add-liquidity-in-same-index", () {
      LiquidityAction liquidity = LiquidityAction();

      AddLiquidityOutput output = liquidity.calculateAddLiquidity(
          20,
          1,
          TypeAsset.base,
          PairInfo(
              currentIndexPipRange: 1,
              currentPrice: 5.0000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                1: LiquidityInfo(
                    priceMin: 3.0000,
                    priceMax: 5.9999,
                    liquidityAmount: 0,
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.baseAmount, 20, 0.01), true);
      expect(
          expectDataInRange(output.quoteAmount, 258.7230766976834, 0.01), true);
      expect(expectDataInRange(output.liquidityAmount, 513.321950387419, 0.01),
          true);
    });
    test("add-liquidity-in-same-index-priceMax-equal-priceCurrent", () {
      LiquidityAction liquidity = LiquidityAction();
      AddLiquidityOutput output = liquidity.calculateAddLiquidity(
          100,
          5,
          TypeAsset.quote,
          PairInfo(
              currentIndexPipRange: 5,
              currentPrice: 17.9999,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 0,
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.baseAmount, 0, 0.01), true);
      expect(expectDataInRange(output.quoteAmount, 100, 0.01), true);
      expect(expectDataInRange(output.liquidityAmount, 270.52942592077, 0.01),
          true);
    });
    test("add-liquidity-in-same-index-priceMin-equal-priceCurrent", () {
      LiquidityAction liquidity = LiquidityAction();
      AddLiquidityOutput output = liquidity.calculateAddLiquidity(
          10,
          5,
          TypeAsset.base,
          PairInfo(
              currentIndexPipRange: 5,
              currentPrice: 15.0000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 0,
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.baseAmount, 10, 0.01), true);
      expect(expectDataInRange(output.quoteAmount, 0, 0.01), true);
      expect(expectDataInRange(output.liquidityAmount, 444.52397234324, 0.01),
          true);
    });
    test("add-liquidity-in-greater-index", () {
      LiquidityAction liquidity = LiquidityAction();
      AddLiquidityOutput output = liquidity.calculateAddLiquidity(
          15,
          2,
          TypeAsset.base,
          PairInfo(
              currentIndexPipRange: 1,
              currentPrice: 5.0000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                2: LiquidityInfo(
                    priceMin: 6.0000,
                    priceMax: 8.9999,
                    liquidityAmount: 0,
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      // print(output.baseAmount);
      // print(output.quoteAmount);
      // print(output.liquidityAmount);
      expect(expectDataInRange(output.baseAmount, 15, 0.01), true);
      expect(expectDataInRange(output.quoteAmount, 0, 0.01), true);
      expect(
          expectDataInRange(output.liquidityAmount, 200.23198807858523, 0.01),
          true);
    });
    test("add-liquidity-in-less-index", () {
      LiquidityAction liquidity = LiquidityAction();
      AddLiquidityOutput output = liquidity.calculateAddLiquidity(
          100,
          0,
          TypeAsset.quote,
          PairInfo(
              currentIndexPipRange: 1,
              currentPrice: 5.0000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                0: LiquidityInfo(
                    priceMin: 0.0001,
                    priceMax: 2.9999,
                    liquidityAmount: 0,
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.baseAmount, 0, 0.01), true);
      expect(expectDataInRange(output.quoteAmount, 100, 0.01), true);
      expect(expectDataInRange(output.liquidityAmount, 58.07029592882688, 0.01),
          true);
    });
  });

  group("remove-liquidity", () {
    test("remove-liquidity-in-same-index", () {
      LiquidityAction liquidity = LiquidityAction();

      RemoveLiquidityOutput output = liquidity.calculateRemoveLiquidity(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 12690.7587645247,
              indexPipRange: 5),
          PairInfo(
              currentIndexPipRange: 5,
              currentPrice: 16.5000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 12690.7587645247,
                    baseReal: 3124.24883596877,
                    quoteReal: 51550.1057934846,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(
          expectDataInRange(output.quoteAmount, 2399.00844774457, 0.01), true);
      expect(expectDataInRange(output.baseAmount, 133, 0.01), true);
    });
    test("remove-liquidity-in-same-index-priceMax-equal-priceCurrent", () {
      LiquidityAction liquidity = LiquidityAction();

      RemoveLiquidityOutput output = liquidity.calculateRemoveLiquidity(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 270.52942592077,
              indexPipRange: 5),
          PairInfo(
              currentIndexPipRange: 5,
              currentPrice: 17.9999,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 811.58827776232,
                    baseReal: 0,
                    quoteReal: 3443.26788375064,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.quoteAmount, 100, 0.01), true);
      expect(expectDataInRange(output.baseAmount, 0, 0.01), true);
    });
    test("remove-liquidity-in-same-index-priceMin-equal-priceCurrent", () {
      LiquidityAction liquidity = LiquidityAction();

      RemoveLiquidityOutput output = liquidity.calculateRemoveLiquidity(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 444.52397234324,
              indexPipRange: 5),
          PairInfo(
              currentIndexPipRange: 5,
              currentPrice: 15.0000,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 2889.40582023103,
                    baseReal: 746.04137481264,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.quoteAmount, 0, 0.01), true);
      expect(expectDataInRange(output.baseAmount, 10, 0.01), true);
    });
    test("remove-liquidity-in-less-index", () {
      LiquidityAction liquidity = LiquidityAction();

      RemoveLiquidityOutput output = liquidity.calculateRemoveLiquidity(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 954.19238831013,
              indexPipRange: 5),
          PairInfo(
              currentIndexPipRange: 6,
              currentPrice: 18.2,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 6202.25052401584,
                    baseReal: 1461.88852885692,
                    quoteReal: 26313.8473305716,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(
          expectDataInRange(output.quoteAmount, 352.71297570031, 0.01), true);
      expect(expectDataInRange(output.baseAmount, 0, 0.01), true);
    });
    test("remove-liquidity-in-less-index", () {
      LiquidityAction liquidity = LiquidityAction();

      RemoveLiquidityOutput output = liquidity.calculateRemoveLiquidity(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 954.19238831013,
              indexPipRange: 5),
          PairInfo(
              currentIndexPipRange: 4,
              currentPrice: 13.5,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                5: LiquidityInfo(
                    priceMin: 15.0000,
                    priceMax: 17.9999,
                    liquidityAmount: 6202.25052401584,
                    baseReal: 1601.41419923464,
                    quoteReal: 24021.2129885196,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0),
              }));

      expect(expectDataInRange(output.quoteAmount, 0, 0.01), true);
      expect(expectDataInRange(output.baseAmount, 21.46548775042, 0.01), true);
    });
  });

  group("collect-fee", () {
    test("collect-fee-ok", () {
      LiquidityAction liquidity = LiquidityAction();

      FeeRewardOutput output = liquidity.calculateCollectFee(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0.48,
              feeGrowthQuote: 0,
              liquidityAmount: 100,
              indexPipRange: 1),
          PairInfo(
              currentIndexPipRange: 4,
              currentPrice: 3.5,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                1: LiquidityInfo(
                  priceMin: 3.0000,
                  priceMax: 5.9999,
                  liquidityAmount: 200,
                  baseReal: 1601.41419923464,
                  quoteReal: 24021.2129885196,
                  feeGrowthBase: 0.505,
                  feeGrowthQuote: 0.505,
                ),
              }));

      expect(expectDataInRange(output.quoteFeeReward, 50.5, 0.01), true);
      expect(expectDataInRange(output.baseFeeReward, 2.5, 0.01), true);
    });
  });

  group("shift-range", () {
    test("shift-range-ok", () {
      LiquidityAction liquidity = LiquidityAction();

      ShiftRangeOutput output = liquidity.calculateShiftRange(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0.001010365185377907,
              feeGrowthQuote: 0.050627750649587265,
              liquidityAmount: 9.190462263649374,
              indexPipRange: 1),
          PairInfo(
              currentIndexPipRange: 1,
              currentPrice: 3.8998,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                1: LiquidityInfo(
                    baseReal: 8291.024620192113,
                    quoteReal: 32333.652872827184,
                    feeGrowthBase: 0.002452295778829888,
                    feeGrowthQuote: 0.005508727330270747,
                    liquidityAmount: 16373.121633621233,
                    priceMax: 5.9999,
                    priceMin: 3.0),
                2: LiquidityInfo(
                    baseReal: 2486.052940261752,
                    quoteReal: 14916.317641570417,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0,
                    liquidityAmount: 6089.561177187104,
                    priceMax: 8.9999,
                    priceMin: 6.0),
                4: LiquidityInfo(
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0,
                    liquidityAmount: 0,
                    priceMax: 14.9999,
                    priceMin: 12),
                0: LiquidityInfo(
                    baseReal: 0,
                    quoteReal: 0,
                    feeGrowthBase: 0,
                    feeGrowthQuote: 0,
                    liquidityAmount: 0,
                    priceMax: 2.9999,
                    priceMin: 0.0001),
              }),
          0,
          0,
          TypeAsset.base);

      print(output.receiveQuoteAmount);
      print(output.receiveBaseAmount);
      print(output.needQuoteAmount);
      print(output.needBaseAmount);

      // expect(expectDataInRange(output.quoteFeeReward, 50.5, 0.01), true);
      // expect(expectDataInRange(output.baseFeeReward, 2.5, 0.01), true);
    });
    test("shift-range", () {
      LiquidityAction liquidity = LiquidityAction();

      ShiftRangeOutput output = liquidity.calculateShiftRange(
          UserLiquidity(
              baseAmount: 0,
              quoteAmount: 0,
              feeGrowthBase: 0,
              feeGrowthQuote: 0,
              liquidityAmount: 379.779735,
              indexPipRange: 0),
          PairInfo(
              currentIndexPipRange: 2,
              currentPrice: 6.9917,
              basisPoint: basicPoint,
              pipRange: pipRange,
              liquidityInfo: {
                0: LiquidityInfo(
                  baseReal: 219.26593245125028,
                  quoteReal: 657.7977973537453,
                  feeGrowthQuote: 0.0,
                  feeGrowthBase: 0.0,
                  liquidityAmount: 379.77973537452937,
                  priceMax: 3.0,
                  priceMin: 0.0001,
                ),
                2: LiquidityInfo(
                  baseReal: 1343.070904401152,
                  quoteReal: 9390.441686293954,
                  feeGrowthQuote: 0.0,
                  feeGrowthBase: 0.000027055294838251,
                  liquidityAmount: 3551.3418602462225,
                  priceMax: 3.0,
                  priceMin: 0.0001,
                ),
                3: LiquidityInfo(
                  baseReal: 918.1092269470731,
                  quoteReal: 8262.98304252366,
                  feeGrowthQuote: 0.0,
                  feeGrowthBase: 0.0,
                  liquidityAmount: 2754.3276808412197,
                  priceMax: 11.9999,
                  priceMin: 9.0,
                ),
              }),
          3,
          23,
          TypeAsset.base);

      print("*******");
      print(output.receiveQuoteAmount);
      print(output.receiveBaseAmount);
      print(output.needQuoteAmount);
      print(output.needBaseAmount);

      // expect(expectDataInRange(output.quoteFeeReward, 50.5, 0.01), true);
      // expect(expectDataInRange(output.baseFeeReward, 2.5, 0.01), true);
    });
  });
}
