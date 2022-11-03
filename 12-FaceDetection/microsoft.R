
library(tidyverse)
library(httr)
library(stringr)
img.url = 'http://ilst.site.nthu.edu.tw/var/file/276/1276/pictures/930/m/mczh-tw250x250_small111732_366078584785.jpg'

# Define Microsoft API URL to request data
URL.emoface = 'https://southcentralus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=emotion&recognitionModel=recognition_03&returnRecognitionModel=false&detectionModel=detection_01&faceIdTimeToLive=86400'

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api)
emotionKEY = '543a13cee1024b1483a9c688942d4172'

api_url <- "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize?visualFeatures=Faces"

get_emotions_microsoft <- function(image_url, api_key){
    
    API_response <- POST(url = api_url,
                         content_type("application/json"),
                         add_headers(.headers = c('Ocp-Apim-Subscription-Key' = api_key)),
                         body = list(url = image_url),
                         encode = "json") 
    
    df <- content(API_response)
    
    map_dfr(df, "faceRectangle") %>% 
        mutate(face_id = row_number()) %>% 
        full_join(map_dfr(df, "scores") %>% 
                      mutate(face_id = row_number()),
                  by = "face_id") %>% 
        mutate(xmin = left,
               xmax = left + width,
               ymin = top, # It is calculated from the top left
               ymax = top + height) %>% 
        select(face_id, xmin:ymax, anger:surprise) %>% 
        gather(emotion, value, -(face_id:ymax)) %>% 
        mutate(value = value %>% round(2)) # Round values for 2 decimals
}

get_emotions_microsoft(img.url,emotionKEY)
