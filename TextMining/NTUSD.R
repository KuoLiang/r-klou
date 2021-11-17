library(tmcn)
data("NTUSD")
p=NTUSD$positive_cht
n=NTUSD$negative_cht
p
n
class(n)
p["一帆風順"]

a=0
for(i in 1:length(p))
{ if(p[i]=="和好")
  {
    a=1
    break
  }
}


b=0
for(i in 1:length(n))
{ if(n[i]=="一連串")
{
  b=1
  break
}
}