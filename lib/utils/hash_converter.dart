int customStringHash(String input) {
  int hash = 0;
  int range = 2147483647; // Using the maximum value for a 32-bit signed integer
  for (int i = 0; i < input.length; i++) {
    hash = (31 * hash + input.codeUnitAt(i)) % range;
  }
  // Making sure the hash is positive
  if (hash < 0) hash = -hash;
  return hash;
}
