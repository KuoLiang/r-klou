install.packages("opencv")
library(opencv)
unconf <- ocv_read('http://ilst.site.nthu.edu.tw/var/file/276/1276/pictures/930/m/mczh-tw250x250_small111732_366078584785.jpg')
faces <- ocv_face(unconf)
ocv_write(faces, 'faces.jpg') #write a circle to working directory
facemask <- ocv_facemask(unconf)
attr(facemask, 'faces')
### live camera 2
ocv_video(ocv_face)
ocv_video(ocv_edges)
###

