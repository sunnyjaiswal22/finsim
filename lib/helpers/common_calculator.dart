import 'dart:math';

class CommonCalculator {
  static calculateEMI(
    int amount,
    int durationInMonths,
    double annualRateOfInterest,
  ) {
    //Calculating EMI = P * r * (1 + r)^n/((1 + r)^n - 1)
    //r = monthly_rate = annual_rate / 1200
    //n = number_of_months
    var monthlyRateOfInterest = annualRateOfInterest / (12 * 100);
    var onePlusRToPowerN = pow((1 + monthlyRateOfInterest), durationInMonths);
    var ratio = onePlusRToPowerN / (onePlusRToPowerN - 1);
    return (amount * monthlyRateOfInterest * ratio).toInt();
  }

  static double calculateRemainingLoan(
    int amount,
    int emiAmount,
    double annualRateOfInterest,
    int afterNumberOfMonths,
  ) {
    //remaining_balance = amount_borrowed * (1 + r)^n - monthly_payment * (((1 + r)^n - 1) / r)
    //r = monthly_rate = annual_rate / 1200
    //n = after_number_of_months
    var monthlyRateOfInterest = annualRateOfInterest / (12 * 100);
    var onePlusRToPowerN =
        pow((1 + monthlyRateOfInterest), afterNumberOfMonths);

    var ratio = (onePlusRToPowerN - 1) / monthlyRateOfInterest;
    return ((amount * onePlusRToPowerN) - (emiAmount * ratio));
  }
}
