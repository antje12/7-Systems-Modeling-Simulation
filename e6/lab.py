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
result = lcm(a, c, m)[0:100]
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
result = lcm(a, c, m)
result.sort()
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

print("Runs Test!")
result = lcm(a, c, m)
N = len(result)

sequence = []

for index in range(0, N-1):
    i1 = result[index]
    i2 = result[index+1]
    if (i1 < i2):
        sequence.append("<")
    if (i1 > i2):
        sequence.append(">")

i = {}
symbol = ""
count = 0
for index in range(0, len(sequence)):
    if symbol == "":
        symbol = sequence[index]
        count = 1
    elif symbol != sequence[index]:
        if count in i:
            i[count] += 1
        else:
            i[count] = 1
        symbol = sequence[index]
        count = 1
    elif symbol == sequence[index]:
        count += 1

# remember to save last sequence!
if count in i:
    i[count] += 1
else:
    i[count] = 1

X = 0
for index in range(1, len(i)+1):
    O = i[index]
    E = (2/math.factorial(index+3))*(N*(index**2+3*index+1)-(index**3+3*index**2-index-4))
    X += ((O - E)**2)/E

print("Chi^2 value ", X)

DoF = len(i)-1
Xa = chi2.ppf(.95, df=DoF)
print("Degree of freedom ", DoF)
print("Critical value ", Xa)

if (X <= Xa):
    print("Accept H0!")
else:
    print("Reject H0!")

#//////////////////////////////////////////////

print("Autocorrelation Test!")
result = lcm(a, c, m)
m = 128
i = 3
N = len(result)
M = ((N-i)/m)-1
M = math.floor(M)

Sum = 0
for k in range(0, M+1):
    R1 = result[i+k*m]
    R2 = result[i+(k+1)*m]
    Sum += R1*R2

Rho = (1/(M+1))*(Sum)-0.25
Sigma = (math.sqrt(13*M+7))/(12*(M+1))

Z = Rho / Sigma

test = 1
