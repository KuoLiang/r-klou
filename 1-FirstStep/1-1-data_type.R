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
paste(d,d,d)
paste("hello",d)

#logical

e = TRUE
e2 = c(T,T,F,F)
f = T
f2 = c(T,F,T,F)
g = FALSE
h = F
typeof(e)

i = a+b
j = e+f
j
typeof(j)
k = e & f    # AND   element-wise comparison
k2 = e2 & f2 # AND   element-wise comparison
k = e && f         # only two elements' comparison
k2 = e2[3] && f2[3] # only two elements' comparison

k = e | f   # OR
k = !k      # NOT
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
