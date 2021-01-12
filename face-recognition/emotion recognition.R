library("httr")
library("XML")
library("stringr")
library("ggplot2")

# Define image source
img.url = 'http://ilst.site.nthu.edu.tw/var/file/276/1276/pictures/930/m/mczh-tw250x250_small111732_366078584785.jpg'

# Define Microsoft API URL to request data
URL.emoface = 'https://southcentralus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=emotion&recognitionModel=recognition_03&returnRecognitionModel=false&detectionModel=detection_01&faceIdTimeToLive=86400'

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api)
emotionKEY = '543a13cee1024b1483a9c688942d4172'

mybody = list(url = img.url)

# Request data from Microsoft
faceEMO = POST(
  url = URL.emoface,
  content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emotionKEY)),
  body = mybody,
  encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceEMO

# Reuqest results from face analysis
pic1 = httr::content(faceEMO)[[1]]
pic1
# Define results in data frame
result<-as.data.frame(as.matrix(pic1$faceAttributes))
result
# Make some transformation


#####################################################################
# Define image source
img.url = 'https://assets.donaldjtrump.com/site/about_body_img_2.jpg'

# Define Microsoft API URL to request data
faceURL = "https://southcentralus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=true&returnFaceAttributes=emotion&recognitionModel=recognition_03&returnRecognitionModel=false&detectionModel=detection_01&faceIdTimeToLive=86400"

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/face-api)
faceKEY = '543a13cee1024b1483a9c688942d4172'

# Define image
mybody = list(url = img.url)

# Request data from Microsoft
faceResponse = POST(
  url = faceURL, 
  content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = faceKEY)),
  body = mybody,
  encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceResponse

# Reuqest results from face analysis
ObamaR = httr::content(faceResponse)[[1]]

# Define results in data frame
OR<-as.data.frame(as.matrix(ObamaR$faceLandmarks))
OR
# Make some transformation to data frame

