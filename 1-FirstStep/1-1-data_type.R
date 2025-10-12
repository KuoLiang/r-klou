#integer
a = 10L
typeof(a)
class(a)
#
a = 10
typeof(a)
class(a)
#default datatype is double
#typeof()
#Internal Type/Storage Mode: typeof() reveals the fundamental internal data type 
#or storage mode of an object, which is how R stores the data in memory. 
#This is a low-level description.
#class()
#Object-Oriented Class: class() returns the object's class, 
#which defines how R should interact with the object in the context of object-oriented programming (OOP). 
#This is a high-level description.

#double
b = 10.1
typeof(b)
class(b)
b = sqrt(b)

#complex
c = 1 + 2i
typeof(c)
class(c)

#character
d = "klou"
typeof(d)
class(d)
paste(d,d)
paste(d,d,d)
paste("hello",d)

#logical

e = TRUE
e2 = c(T,T,F,F) #combines the TTFF into e2
typeof(e)
class(e)
#c() function presents the "combine" action

f = T
f2 = c(T,F,T,F)
g = FALSE
h = F
#############

i = a+b
i   #shows i
typeof(i)
class(i)
#
j = e+f
j    #shows j
typeof(j)
class(j)

###
k = e & f         # AND   element-wise comparison, vector comparison
k
k2 = e2 & f2      # AND   element-wise comparison, vector comparison
k2
k = e && f         # comparision between two elements
k
k2 = e2[3] && f2[3] # comparision between two elements
k2
k2 = e2 && f2    #there is an error

k = e | f   # OR
k = !k      # NOT
typeof(k)
class(k)
#==========

a > b
a < b
a >= b
a == b
a == a
a != b

z = (a>b)
z = !(a>b)

a = !T
a

isTRUE(a)
