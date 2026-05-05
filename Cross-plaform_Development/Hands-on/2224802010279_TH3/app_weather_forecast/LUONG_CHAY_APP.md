# Luồng Chạy Ứng Dụng Dự Báo Thời Tiết

## 📋 Tổng Quan

Ứng dụng này là một **ứng dụng dự báo thời tiết** (Weather Forecast App) được xây dựng bằng **Flutter**. Ứng dụng gọi API từ **OpenWeatherMap** để lấy dữ liệu thời tiết và hiển thị thông tin chi tiết về thời tiết của các thành phố khác nhau.

---

## 🚀 Luồng Chạy Chi Tiết

### 1️⃣ **Khởi Động Ứng Dụng** (`main()`)

```
main()
  └─ runApp(WeatherApp())
```

**Hành động:**

- Điểm vào của ứng dụng Flutter
- Gọi `runApp()` để chạy widget gốc `WeatherApp`

---

### 2️⃣ **Khởi Tạo Ứng Dụng** (`WeatherApp`)

```
WeatherApp (StatelessWidget)
  └─ MaterialApp
      ├─ theme: Material Design 3 (màu xanh)
      ├─ title: "2224802010279 - Dự báo thời tiết"
      └─ home: HomePage()
```

**Hành động:**

- Thiết lập giao diện Material Design
- Đặt `HomePage` làm màn hình chính

---

### 3️⃣ **Trang Chủ** (`HomePage`)

```
HomePage (StatefulWidget)
  └─ initState()
      ├─ Khởi tạo searchController
      ├─ Load dữ liệu thời tiết của 6 thành phố nổi bật
      │   • Hà Nội
      │   • Hồ Chí Minh
      │   • Đà Nẵng
      │   • Tokyo
      │   • Paris
      │   • New York
      └─ Lắng nghe sự thay đổi input search
```

**Giao diện HomePage:**

```
┌────────────────────────────────┐
│   2224802010279 - Dự báo TT    │
├────────────────────────────────┤
│ [Nhập tên thành phố...]  [🔍]  │
│                                │
│ ┌──────────────────────────┐   │ (Nếu có gợi ý)
│ │ • Hà Nội                 │   │
│ │ • Hồ Chí Minh            │   │
│ └──────────────────────────┘   │
│                                │
│ 📍 Thành phố nổi bật          │
├────────────────────────────────┤
│ ☀️ Hà Nội          ☀️ 28.5°C  │
│ ⛅ Hồ Chí Minh      ⛅ 32.1°C  │
│ 🌧️ Đà Nẵng         🌧️ 25.3°C  │
│ ... (6 thành phố)             │
└────────────────────────────────┘
```

**Các hành động trên HomePage:**

#### **Trường hợp 1: Tìm kiếm thành phố**

```
User nhập vào search box
  └─ _onSearchChanged() được trigger
      └─ Gọi WeatherService.getCitySuggestions(query)
          └─ Hiển thị danh sách gợi ý (10 thành phố)
              └─ User chọn một thành phố
                  └─ Gọi _searchWeather()
                      └─ Navigator.push(DetailPage)
                          └─ Chuyển đến DetailPage với city name
```

#### **Trường hợp 2: Xem thời tiết thành phố nổi bật**

```
HomePage được build()
  └─ FutureBuilder<List<WeatherData>>
      ├─ Loading: Hiển thị CircularProgressIndicator
      ├─ Error: Hiển thị thông báo lỗi + nút "Thử lại"
      └─ Success: Hiển thị danh sách 6 thành phố
          └─ User tap vào một thành phố
              └─ Navigator.push(DetailPage)
                  └─ Chuyển đến DetailPage
```

---

### 4️⃣ **Trang Chi Tiết Thời Tiết** (`DetailPage`)

```
DetailPage (StatefulWidget)
  └─ initState()
      └─ Gọi WeatherService.getWeatherByCity(city)
          └─ Chờ API response
```

**Giao diện DetailPage:**

```
┌──────────────────────────────────┐
│ ← (Nút quay lại)                 │
│                                  │
│        Hà Nội                    │
│                                  │
│          ☀️                       │
│                                  │
│        28.5°                     │
│      SUNNY (NẮNG)                │
│                                  │
│  ┌──────────────────────────────┐│
│  │ 💧 Cảm giác: 30.2°C          ││
│  │ 💨 Độ ẩm: 65%               ││
│  │                              ││
│  │ 💨 Sức gió: 3.5 m/s          ││
│  │ 🔘 Áp suất: 1013 hPa         ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

**Luồng DetailPage:**

```
DetailPage.build()
  └─ FutureBuilder<WeatherData>
      ├─ Loading:
      │   └─ Hiển thị CircularProgressIndicator
      │
      ├─ Error:
      │   ├─ Hiển thị biểu tượng ❌
      │   ├─ Hiển thị thông báo lỗi
      │   └─ 2 nút: "Quay lại" + "Thử lại"
      │
      └─ Success:
          ├─ Gradient background (xanh)
          ├─ Hiển thị tên thành phố
          ├─ Hiển thị biểu tượng thời tiết (emoji)
          ├─ Hiển thị nhiệt độ (72 font size)
          ├─ Hiển thị mô tả ("SUNNY", "RAINY", ...)
          └─ Hiển thị chi tiết:
              ├─ Cảm giác (feels_like)
              ├─ Độ ẩm (humidity)
              ├─ Sức gió (wind speed)
              └─ Áp suất (pressure)
```

---

### 5️⃣ **API Service** (`WeatherService`)

#### **API URLs:**

```
Base: https://api.openweathermap.org/data/2.5
Geo:  https://api.openweathermap.org/geo/1.0
API Key: 151aa34a64815d0ac9cafcd276fb3d39
```

#### **Hàm `getWeatherByCity(city)`:**

```
getWeatherByCity(city)
  │
  ├─ Kiểm tra useGeocodingApi flag
  │
  ├─ Nếu true (Recommended):
  │   ├─ Gọi getCoordinates(city)
  │   │   └─ API: /geo/1.0/direct?q={city}&appid={apiKey}
  │   │       └─ Response: {lat, lon}
  │   │
  │   └─ Gọi /data/2.5/weather?lat={lat}&lon={lon}&units=metric&lang=vi
  │       └─ Response: JSON weather data
  │
  ├─ Nếu false:
  │   └─ Gọi /data/2.5/weather?q={city}&appid={apiKey}&units=metric&lang=vi
  │       └─ Response: JSON weather data
  │
  └─ Xử lý lỗi:
      ├─ 200: Trả về data
      ├─ 401: "Invalid API Key"
      ├─ 404: "City not found"
      ├─ 429: "Rate limit exceeded"
      ├─ Timeout: "Network timeout"
      └─ Other: HTTP error
```

#### **Hàm `getCitySuggestions(query)`:**

```
getCitySuggestions(query)
  │
  ├─ Danh sách gợi ý tĩnh (15 thành phố):
  │   • Hà Nội, Hồ Chí Minh, Đà Nẵng, ...
  │   • Tokyo, Paris, New York, ...
  │
  └─ Lọc theo query (case-insensitive):
      └─ Trả về danh sách thành phố khớp
```

---

### 6️⃣ **Data Model** (`WeatherData`)

```
WeatherData {
  - city: String           // Tên thành phố
  - country: String        // Mã quốc gia
  - temperature: double    // Nhiệt độ (°C)
  - feelsLike: double      // Cảm giác nhiệt độ
  - humidity: int          // Độ ẩm (%)
  - pressure: int          // Áp suất (hPa)
  - windSpeed: double      // Sức gió (m/s)
  - description: String    // Mô tả (SUNNY, RAINY, ...)
  - icon: String          // Icon code (01d, 02n, ...)
  - clouds: int           // % mây
}

fromJson(Map) {
  └─ Parse API response JSON
  └─ Trả về object WeatherData
}
```

---

## 🔄 Biểu Đồ Luồng Tổng Thể

```
                    ┌─────────────────┐
                    │   App Start     │
                    │    main()       │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   WeatherApp    │
                    │  MaterialApp    │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   HomePage      │
                    │  StatefulWidget │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
    ┌───────▼──────┐  ┌──────▼──────┐  ┌─────▼──────┐
    │   Search     │  │  Featured   │  │  Get Tips  │
    │   Bar        │  │  Cities     │  │  Suggest   │
    └───────┬──────┘  └──────┬──────┘  └─────┬──────┘
            │                │               │
    ┌───────▼──────────────────────────────────┐
    │  WeatherService                         │
    │  - getWeatherByCity(city)               │
    │  - getCitySuggestions(query)            │
    │  - getCoordinates(city)                 │
    └───────┬──────────────────────────────────┘
            │
    ┌───────▼──────────────────────────────────┐
    │  OpenWeatherMap API                     │
    │  - /geo/1.0/direct                      │
    │  - /data/2.5/weather                    │
    └───────┬──────────────────────────────────┘
            │
    ┌───────▼──────────────────────────────────┐
    │  DetailPage                             │
    │  - Hiển thị chi tiết thời tiết          │
    │  - Thông tin 5 chỉ số chính             │
    └─────────────────────────────────────────┘
```

---

## 🌐 Quy Trình API Call

### **Bước 1: User tìm kiếm thành phố**

```
User: "Ha"
  └─ WeatherService.getCitySuggestions("Ha")
      └─ Lọc danh sách tĩnh
          └─ Return: ["Hà Nội", "Hà Long"]
              └─ Hiển thị dropdown suggestions
```

### **Bước 2: User chọn hoặc nhập thành phố**

```
User: Chọn "Hà Nội" hoặc bấm nút search
  └─ Navigator.push(DetailPage(city: "Hà Nội"))
      └─ DetailPage.initState()
          └─ WeatherService.getWeatherByCity("Hà Nội")
              └─ API Call: /geo/1.0/direct?q=Hà Nội&appid=...
                  └─ Response: {lat: 21.03, lon: 105.85}
                      └─ API Call: /data/2.5/weather?lat=21.03&lon=105.85&...
                          └─ Response: {
                                temp: 28.5,
                                feels_like: 30.2,
                                humidity: 65,
                                ...
                              }
                              └─ WeatherData.fromJson(response)
                                  └─ Hiển thị DetailPage với dữ liệu
```

---

## 🎯 Các State Quan Trọng

### **HomePage:**

- `searchController`: Quản lý input tìm kiếm
- `suggestions`: Danh sách gợi ý thành phố
- `weatherDataFuture`: Future của danh sách thời tiết 6 thành phố
- `featuredCities`: Danh sách 6 thành phố nổi bật

### **DetailPage:**

- `weatherFuture`: Future của dữ liệu thời tiết một thành phố

---

## ⚙️ Các Thành Phần Chính

| Thành Phần       | Loại            | Chức Năng                            |
| ---------------- | --------------- | ------------------------------------ |
| `WeatherApp`     | StatelessWidget | Khởi tạo MaterialApp                 |
| `HomePage`       | StatefulWidget  | Hiển thị trang chủ, quản lý tìm kiếm |
| `DetailPage`     | StatefulWidget  | Hiển thị chi tiết thời tiết          |
| `WeatherService` | Class tĩnh      | Gọi API OpenWeatherMap               |
| `WeatherData`    | Model Class     | Lưu trữ dữ liệu thời tiết            |

---

## 🐛 Xử Lý Lỗi

1. **Network Timeout**: Hiển thị "Network timeout - Emulator has no internet access"
2. **API Error 401**: "Unauthorized - Invalid API Key"
3. **API Error 404**: "City not found"
4. **API Error 429**: "Rate limit exceeded"
5. **Generic Error**: Hiển thị thông báo lỗi + nút "Thử lại"

---

## 📱 Luồng User Journey

```
START
  │
  ├─ HomePage tải 6 thành phố nổi bật
  │   │
  │   ├─ ✅ Thành công: Hiển thị danh sách
  │   └─ ❌ Thất bại: Hiển thị lỗi + nút Thử lại
  │
  ├─ User có 2 tùy chọn:
  │   │
  │   ├─ Tùy chọn 1: Tap vào một thành phố nổi bật
  │   │   └─ Chuyển đến DetailPage
  │   │
  │   └─ Tùy chọn 2: Tìm kiếm thành phố khác
  │       ├─ Nhập vào search box
  │       ├─ Nhìn gợi ý
  │       ├─ Chọn hoặc bấm search
  │       └─ Chuyển đến DetailPage
  │
  ├─ DetailPage tải dữ liệu thời tiết
  │   │
  │   ├─ ✅ Thành công: Hiển thị chi tiết
  │   └─ ❌ Thất bại: Hiển thị lỗi + 2 nút (Quay lại, Thử lại)
  │
  ├─ User có 2 tùy chọn:
  │   │
  │   ├─ Tùy chọn 1: Quay lại HomePage (bấm ← hoặc nút Quay lại)
  │   │   └─ Quay lại HomePage
  │   │
  │   └─ Tùy chọn 2: Thử lại (chỉ khi có lỗi)
  │       └─ Reload dữ liệu
  │
  END
```

---

## 📊 Dữ Liệu Chi Tiết Hiển Thị

**Trên HomePage:**

- Tên thành phố
- Mô tả thời tiết (SUNNY, RAINY, ...)
- Emoji thời tiết
- Nhiệt độ hiện tại

**Trên DetailPage:**

- Tên thành phố
- Emoji thời tiết lớn
- Nhiệt độ hiện tại (72 font size)
- Mô tả thời tiết
- Cảm giác nhiệt độ
- Độ ẩm
- Sức gió
- Áp suất

---

## 🎨 Giao Diện

- **Theme**: Material Design 3 (màu xanh)
- **HomePage**: Danh sách cuộn, search bar trên cùng
- **DetailPage**: Gradient background xanh, grid chi tiết 2x2
- **Icons**: Emoji (☀️, 🌙, ⛅, 🌧️, ⛈️, ❄️, 🌫️)

---

## 📝 Kết Luận

Ứng dụng này theo kiến trúc **MVCS (Model-View-Controller-Service)**:

- **Model**: `WeatherData`
- **View**: `WeatherApp`, `HomePage`, `DetailPage`
- **Service**: `WeatherService`
- **Controller**: State của `HomePage` và `DetailPage`

Luồng chạy chính là:

1. Khởi động app → HomePage
2. HomePage tải dữ liệu 6 thành phố nổi bật
3. User tìm kiếm hoặc chọn thành phố
4. Chuyển đến DetailPage
5. DetailPage tải chi tiết thời tiết từ API
6. Hiển thị dữ liệu (hoặc lỗi)
7. User có thể quay lại hoặc thử lại
