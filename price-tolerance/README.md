# Price Tolerance Zero-knowledge Program

This program accepts prices in an integer exponent notation, chooses the median as the correct value and shows only the prices which are within the tolerance range of the correct value.

The format for a price is `[ X, Y ]`, where `X` and `Y` are (signed) integers and the actual value is `XeY` (scientific notation).
Unfortunately Noir doesn't natively support floating-point numbers, so this is the second best thing.

The first output is the correct value (median) while all the rest are the prices within tolerance.
