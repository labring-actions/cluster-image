import requests
import json
import base64

image = open("demo_text_det.jpg","rb")
img = base64.b64encode(image.read())



url = "http://172.16.59.17:30889/mmocr"
url = "http://172.16.59.17:30889/v1/private/mmocr"
method = "POST"
headers = {"Content-Type":"application/json"}
data = {
    "header": {
        "app_id": "123456",
        "uid": "39769795890",
        "did": "SR082321940000200",
        "imei": "8664020318693660",
        "imsi": "4600264952729100",
        "mac": "6c:92:bf:65:c6:14",
        "net_type": "wifi",
        "net_isp": "CMCC",
        "status": 3,
        "request_id": None
    },
    "parameter": {
        "mmocr": {
            "category": "ai_category",
            "application_mode": "common_gpu",
            "gpu_id": "first",
            "gpu_type": "T4G16",
            "boxes": {
                "encoding": "utf8",
                "compress": "raw",
                "format": "json"
            }
        }
    },
    "payload": {
        "data": {
            "encoding": "jpg",
            "image": img.decode("utf-8"),
            "status": 3
        }
    }
}

# call the http api.
resp = requests.post(url,headers=headers,data=json.dumps(data))

print(resp.status_code)

if resp.status_code != 200:

    print(resp.json())

result = resp.json()['payload']['boxes']['text']
print("HTTP API response is : %s "% str(result))

print("########################################")

for box in result[0].get("result"):

    msg = "MMocr Result: box located at {box}, box score is {box_score}.  Detected text is {text} , text  score is {text_score}..."
    print(msg.format(**box))

#
