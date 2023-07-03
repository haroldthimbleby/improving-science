import numpy as np 
import math

def food(ds):
	'''
	Amount of food in an order as a function of the diameters per pizza (eq. 3). 
	'''
	return (math.pi * (ds/2)**2).sum()

# Order option a in fig. 1, two 12'' pizzas:
two_pizzas = np.array([12, 12])

# Option b, one 18'' pizza: 
one_pizza = np.array([18])

# Decision rule (eq. 2): 
print(food(two_pizzas) > food(one_pizza))

