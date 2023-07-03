# (c) Harold Thimbleby, harold@thimbleby.net, 28 June 2023 @ 14:54:35 
print("Running the Python code extracted by awk script from pizza.tex")


import math

pi = math.pi

# A map of Pizza orders
# Variable orders[] maps order ID to a list of pizza diameters in inches\ 
orders = {
   "a": [12, 12], # Order a is two 12 inch pizzas
   "b": [18] # Order b is one 18 inch pizza
}

# Implement $\phi$ from (\refeqn-corrected-area-generalized)
# Tota area of all pizzas in orderID
def phi(orderID):
   totalArea = 0
   for diameter in orders[orderID]:
      totalArea += pi * (diameter/2)**2
   return totalArea

# Implement $\omega$ from equation (\refeqn-set-corrected-specification) 
# Determine maximum area order(s) over all orders
maxArea = 0
maxAreaIDs = []
for orderID in orders :
   area = phi(orderID)
   if maxArea == area : 
      maxAreaIDs.append(orderID)
   if maxArea < area  :
      maxArea = area
      maxAreaIDs = [orderID]

print(maxAreaIDs)

   
print("Pizza order", maxAreaIDs, 
      "has largest area =", round(maxArea, 1), "sq in"
     )

N = len(maxAreaIDs)
if N == 0 : 
   print("No pizza orders were made")
else :
       print("Pizza", "orders" if N > 1 else "order", 
	        maxAreaIDs, "has" if N == 1 else "have equal",
	        "largest area =", round(maxArea, 1), "sq in"
	        )
