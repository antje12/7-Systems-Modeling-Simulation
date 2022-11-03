import random as rand
import math as math

a_1 = 101427
c_1 = 321 # Step
m_1 = 2**16 # Maximum / Modulus

a_2 = 65539
c_2 = 0 # Step
m_2 = 2**31 # Maximum / Modulus

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

input = input()

resultNative = pyNative()
resultLcm1 = lcm(a_1, c_1, m_1)
resultLcm2 = lcm(a_2, c_2, m_2)

print("Kolmogorov-Smirnov Test!")
result = resultNative[0:100]
result.sort()
N = len(result)

D_plus = 0
for index in range(0, N):
    R = result[index]
    D = (index / N) - R
    D_plus = max(D_plus, D)

D_minus = 0
for index in range(0, N):
    R = result[index]
    D = R - ((index-1) / N)
    D_minus = max(D_minus, D)

D = max(D_plus, D_minus)
alfa = 0.05
Da = 1.36/(math.sqrt(N))

if (D <= Da):
    print("Accept H0!")
else:
    print("Reject H0!")


print("Chi-Squared Test!")
result = resultNative
result.sort()
N = len(result)

Ks = []

for index in range(0, N):
    R = result[index]
    if 0 <= R and R < 0.1:
        


# Compare to Uniform distribution!
