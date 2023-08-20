
// double risk_to_reward(double base, double extreme, double target) {
//     double mid_price = get_half_zone(base, extreme);
//     double mid_stop_range = 



//     return true;
// }

double get_half_zone(double base, double extreme) {
   return MathAbs((base + extreme) / 2);
}