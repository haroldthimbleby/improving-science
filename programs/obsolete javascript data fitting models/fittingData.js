/*
 Author: Harold Thimbleby, 2022
 
 Given an array of (x,y) pairs as data, this simple program finds the best fit linear model (using 
 least squares) and an exact polynomial model (a Lagrange polynomial) to fit the data.
 
 The simple algorithms used are taken straight off Wikipedia:
 
 	Least Squares: https://en.wikipedia.org/wiki/Simple_linear_regression
	Lagrange polynomial: https://en.wikipedia.org/wiki/Lagrange_polynomial
	
Both algorithms generate a vector of polynomial coefficients, and the function polynomialToString converts the coefficients to a string representation of the polynomial in x. Thus, for example, LeastSquares(data) generates the numerical vector [a,b] which represents the linear polynomial a+bx.

 */

var data = [{
    x: 2.2,
    y: 4.9
}, {
    x: 4.7,
    y: 8.2
}, {
    x: 2.6,
    y: 5.7
}, {
    x: 1.,
    y: 2.7
}, {
    x: 0.9,
    y: 1.5
}];

/* Typical shell command (using node to run the Javascript) and resulting output:

    % node p.js
    Given data:
    [
      { x: 2.2, y: 4.9 },
      { x: 4.7, y: 8.2 },
      { x: 2.6, y: 5.7 },
      { x: 1, y: 2.7 },
      { x: 0.9, y: 1.5 }
    ]
    Model coefficients to 4 significant figures:
    
      Linear least squares fit: y =  0.8232 +1.656 x
      Linear evaluated at 5:  9.1032
      Linear evaluated at 5 in LaTeX:
        \def\lineary{$y(5)= 9.1 $}
    
      Lagrange polynomial:      y = -32.04 +69.63 x -46.72 x^2 +13.08 x^3 -1.257 x^4
      Lagrange evaluated at 5:  -2.5149999999999864
      Lagrange evaluated at 5 in LaTeX:
        \def\exacty{$y(5)= -2.5 $}
    
    
    ---
    
    In Mathematica format:
    
    data = {{2.2,4.9},{4.7,8.2},{2.6,5.7},{1,2.7},{0.9,1.5}};    
    linear[x_] :=  0.8232 +1.656 x;
    lagrange[x_] := -32.04 +69.63 x -46.72 x^2 +13.08 x^3 -1.257 x^4;
    
*/

function LeastSquares(data) {
    var n = data.length,
        ssxx = 0, // sum squares (x - xmean)
        ssxy = 0, // sum of (x - xmean) * (y - ymean)
        xm = 0, // x mean
        ym = 0, // y mean
        alpha, beta;
    for (var i = 0; i < n; i++) {
        xm = xm + data[i].x;
        ym = ym + data[i].y;
    }
    xm = xm / n;
    ym = ym / n;
    for (var i = 0; i < n; i++) {
        var dx = data[i].x - xm;
        ssxx = ssxx + dx * dx;
        ssxy = ssxy + dx * (data[i].y - ym);
    }
    beta = ssxy / ssxx;
    alpha = ym - beta * xm;
    return [alpha, beta]; // i.e., the polynomial alpha + beta * x
}

// with n=data.length points, an n-1 degree Lagrange polynomial will be generated
// which of course needs n coefficients...
// the sum and product vectors (in the code) represent the n coefficients for x^0, x^1, x^2 ... x^(n-1)
function LagrangePolynomial(data) {
    var n = data.length,
        sum = new Array(n).fill(0);
    for (var j = 0; j < n; j++) {
        var product = new Array(n).fill(0);
        product[0] = data[j].y;
        for (var m = 0; m < n; m++)
            if (m != j) {
                var divisor = data[j].x - data[m].x;
                for (var i = n - 1; i >= 0; i--) // multiply product by (x-data[m].x)/divisor
                    product[i] = ((i - 1 >= 0 ? product[i - 1] : 0) - product[i] * data[m].x) / divisor;
            }
        for (var i = 0; i < n; i++) // add the product coefficients to running sum
            sum[i] = sum[i] + product[i];
    }
    return sum;
}

// convert a vector of polynomial coefficients into a string
function polynomialToString(s, variable = "x") {
    var n = s.length,
        string = "",
        plus = " ";
    for (var power = 0; power < n; power++) {
        if (s[power] != 0) {
            string += " ";
            string = string + (s[power] > 0 ? plus : "") + s[power];
            if (power > 0) {
                string = string + " " + variable;
                if (power > 1)
                    string = string + "^" + power;
            }
            plus = "+";
        }
    }
    return string;
}

// evaluate a polynomial s at x
function polynomialEvaluate(s, x) {
    var sum = 0,
        p = 1;
    for (var power = 0; power < s.length; power++) {
        sum += p * s[power];
        p *= x;
    }
    return sum;
}

// round every element of a vector
function roundVector(s, significantFigures) {
    for (var power = 0; power < s.length; power++)
        s[power] = s[power].toPrecision(significantFigures);
    return s;
}

// test on the data...
console.log("Given data:");
console.log(data);
var sigfig = 4;
console.log("Model coefficients to " + sigfig + " significant figures:\n");

console.log("  Linear least squares fit: y =" + polynomialToString(roundVector(LeastSquares(data), sigfig)));
console.log("  Linear evaluated at 5: ", polynomialEvaluate(roundVector(LeastSquares(data), sigfig), 5));
console.log("  Linear evaluated at 5 in LaTeX:\n    \\def\\lineary{$y(5)=", polynomialEvaluate(roundVector(LeastSquares(data), sigfig), 5).toPrecision(2), "$}");

console.log();

console.log("  Lagrange polynomial:      y =" + polynomialToString(roundVector(LagrangePolynomial(data), sigfig)));
console.log("  Lagrange evaluated at 5: ", polynomialEvaluate(roundVector(LagrangePolynomial(data), sigfig), 5));
console.log("  Lagrange evaluated at 5 in LaTeX:\n    \\def\\exacty{$y(5)=", polynomialEvaluate(roundVector(LagrangePolynomial(data), sigfig), 5).toPrecision(2), "$}");

console.log("\n\n---\n\nIn Mathematica format:\n");

var s = "data = {";
var sep = "";
for (var i = 0; i < data.length; i++) {
    s += sep + "{" + data[i].x + "," + data[i].y + "}";
    sep = ",";
}
s += "};";
console.log(s);
console.log("linear[x_] :=" + polynomialToString(roundVector(LeastSquares(data), sigfig)) + ";");
console.log("lagrange[x_] :=" + polynomialToString(roundVector(LagrangePolynomial(data), sigfig)) + ";");