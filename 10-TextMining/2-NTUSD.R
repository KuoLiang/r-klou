library(tmcn)
data("NTUSD")
p=NTUSD$positive_cht
n=NTUSD$negative_cht
p
n
class(n)
p[100]

a=0
for(i in 1:length(p))
{ if(p[i]=="很棒")
  {
    a=1
    break
  }
}
a


