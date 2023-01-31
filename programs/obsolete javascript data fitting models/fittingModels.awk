BEGIN { 
	    lines = lagrange = leastsquares = 0; 
	    print "% count of lines in Lagrange and Least Squares functions"
	    print "{%";
	  }
/function LagrangePolynomial/ { 
		lines = leastsquares = 0; 
		lagrange++; 
	}
/function LeastSquares/ { 
		lines = lagrange = 0; 
		leastsquares++;
	}
/$/ { 
		lines++;
	}
/^}/ {
    	  if( lagrange == 1 || leastsquares == 1 )
          {   counter = (lagrange == 1)? "linesLagrange": "linesLeastSquares";
          	  printf "  \\newcount \\%s\n  \\%s = %d\n", counter, counter, lines
          }
          lagrange = leastsquares = 0;  
      }

END {
	   print "  Javascript was used for the two models used in figure \\ref{fig-overfit};"
	   print "  \\ifnum \\linesLeastSquares=\\linesLagrange"
	   print "    the linear Least Squares model and";
	   print "    the exact Lagrange polynomial are each \\the\\linesLeastSquares\\ lines of code%"
       print "  \\else"
       print "    the linear Least Squares model is \\the\\linesLeastSquares\\ lines of code,"
       print "    and the exact Lagrange polynomial is \\the\\linesLagrange\\ lines%"
       print "  \\fi"
       print "}.";
}