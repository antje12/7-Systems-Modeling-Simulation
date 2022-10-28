import random as rand

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

print("What you wanna do? 1: Native, 2: LCM, 3: LCM RANDU")

input = input()

if input == "1":
    print(pyNative())
elif input == "2":
    print(lcm(a_1, c_1, m_1))
elif input == "3":
    print(lcm(a_1, c_1, m_1))
else: 
    print("Wrong input!")
