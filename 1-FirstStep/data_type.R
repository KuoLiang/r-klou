#integer
a = 10L
typeof(a)
a = 10
typeof(a)
#default datatype is double


#double
b = 10.1
typeof(b)
b = sqrt(b)
#complex

c = 1 + 2i
typeof(c)

#character

d = "klou"
typeof(d)
paste(d,d)

#logical

e = TRUE
f = T
g = FALSE
h = F
typeof(e)

i = a+b
j = e+f
j
typeof(j)
k = e & f
k = e | f

typeof(k)

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
