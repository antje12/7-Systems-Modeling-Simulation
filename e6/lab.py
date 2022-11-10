import random as rand
import math as math
from scipy.stats import chi2

a = 101427
c = 321 # Step
m = 2**16 # Maximum / Modulus

a_r = 65539
c_r = 0 # Step
m_r = 2**31 # Maximum / Modulus

seed = 123456789 # Seed
amount = 10000

def lcm(a, c, m):
    result = []
    x = seed
    for int in range(0, amount):
        x = (a * x + c) % m
        r = x/m
        result.append(r)
    return result

def pyNative():
    result = []
    rand.seed(seed)
    for int in range(0, amount):
        # https://docs.python.org/3/library/random.html
        # Almost all module functions depend on the basic function random(), which generates a random float uniformly in the semi-open range [0.0, 1.0).
        r = rand.random()
        result.append(r)
    return result

result_Native = pyNative()
result_Lcm = lcm(a, c, m)
result_Randu_Lcm = lcm(a_r, c_r, m_r)

#//////////////////////////////////////////////

print("Kolmogorov-Smirnov Test!")
result = result_Lcm[0:100]
result.sort()
N = len(result)

D_plus = 0
for index in range(1, N+1):
    R = result[index-1]
    D = (index / N) - R
    D_plus = max(D_plus, D)

D_minus = 0
for index in range(1, N+1):
    R = result[index-1]
    D = R - ((index-1) / N)
    D_minus = max(D_minus, D)

D = max(D_plus, D_minus)
print("D+ ", D_plus)
print("D- ", D_minus)
print("D ", D)

alfa = 0.05
Da = 1.36/(math.sqrt(N))
print("Critical value ", Da)

if (D <= Da):
    print("Accept H0!")
else:
    print("Reject H0!")

#//////////////////////////////////////////////

print("Chi-Squared Test!")
result = result_Lcm
uniform = result_Native
result.sort()
uniform.sort()
N = len(result)

observed = {
  1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0
}
expected = {
  1:1000, 2:1000, 3:1000, 4:1000, 5:1000, 6:1000, 7:1000, 8:1000, 9:1000, 10:1000
}

for index in range(0, N):
    R = result[index]
    if R < 0.1:
        observed[1] += 1
    elif R < 0.2:
        observed[2] += 1
    elif R < 0.3:
        observed[3] += 1
    elif R < 0.4:
        observed[4] += 1
    elif R < 0.5:
        observed[5] += 1
    elif R < 0.6:
        observed[6] += 1
    elif R < 0.7:
        observed[7] += 1
    elif R < 0.8:
        observed[8] += 1
    elif R < 0.9:
        observed[9] += 1
    elif R < 1:
        observed[10] += 1

X = 0
l = len(observed)
for i in range(1, len(observed)+1):
    O = observed[i]
    E = expected[i]
    X += ((O - E)**2)/E

print("Chi^2 value ", X)

DoF = len(observed)-1
Xa = chi2.ppf(.95, df=DoF)
print("Degree of freedom ", DoF)
print("Critical value ", Xa)

if (X <= Xa):
    print("Accept H0!")
else:
    print("Reject H0!")

#//////////////////////////////////////////////

