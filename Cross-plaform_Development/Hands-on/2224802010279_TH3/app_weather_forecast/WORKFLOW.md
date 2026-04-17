# Luồng Hoạt Động Ứng Dụng MSSV - Dự Báo Thời Tiết

## 1. Tổng Quan Kiến Trúc

```
┌─────────────────────────────────────────────────────────┐
│                    WeatherApp (Root)                     │
│              - Material App Theme & Navigation           │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
   ┌────▼──────┐        ┌────────▼──────┐
   │  HomePage │        │  DetailPage   │
   │(List View)│        │(Detail View)  │
   └────┬──────┘        └────────┬──────┘
        │                        │
        │      ┌────────────────┘
        │      │
   ┌────▼──────▼────────────────┐
   │    WeatherService API      │
   │  (OpenWeatherMap.org)      │
   └────────────────────────────┘
```

## 2. Các Thành Phần Chính

### 2.1 WeatherService (API Service Layer)

**Roles:**

- Kết nối với API OpenWeatherMap
- Lấy dữ liệu thời tiết theo tên thành phố
- Cung cấp danh sách gợi ý thành phố

**Methods:**

- `getWeatherByCity(city)`: Trả về Map chứa dữ liệu JSON từ API
- `getCitySuggestions(query)`: Trả về List các thành phố khớp query

### 2.2 WeatherData (Model)

**Roles:**

- Lưu trữ cấu trúc dữ liệu thời tiết
- Chuyển đổi JSON từ API thành Object Dart

**Properties:**

- `city`, `country`: Thông tin địa điểm
- `temperature`, `feelsLike`: Nhiệt độ (°C)
- `humidity`, `pressure`: Độ ẩm (%), áp suất (hPa)
- `windSpeed`: Tốc độ gió (m/s)
- `description`, `icon`, `clouds`: Mô tả và biểu tượng thời tiết

### 2.3 HomePage (List View)

**Roles:**

- Hiển thị danh sách thành phố nổi bật
- Quản lý chức năng tìm kiếm
- Điều hướng đến chi tiết thành phố

**Features:**

- Search TextField với gợi ý real-time
- ListView hiển thị 6 thành phố nổi bật (Hà Nội, TP.HCM, Đà Nẵng, Tokyo, Paris, New York)
- Mỗi item có: tên thành phố, mô tả thời tiết, temperature, icon

### 2.4 DetailPage (Detail View)

**Roles:**

- Hiển thị thông tin thời tiết chi tiết
- Quản lý hiển thị các chỉ số khí tượng

**Features:**

- Background gradient Blue
- Tiêu đề thành phố to
- Icon thời tiết lớn
- Nhiệt độ chính (format: XX.X°)
- Grid 4 chỉ số: Cảm giác, Độ ẩm, Sức gió, Áp suất
- Nút quay lại

## 3. Luồng Dữ Liệu (Data Flow)

### 3.1 Khởi Động Ứng Dụng

```
main()
  → runApp(WeatherApp)
  → WeatherApp builds MaterialApp
  → Thiết lập theme (seedColor: Colors.blue)
  → Điều hướng đến HomePage
```

### 3.2 Tải Dữ Liệu Thành Phố Nổi Bật (Initialization)

```
HomePage.initState()
  → _loadFeaturedWeather()
  → Loop qua 6 thành phố:
      → WeatherService.getWeatherByCity(city)
      → API call: GET /weather?q={city}&appid={apiKey}
      → JSON response → WeatherData.fromJson()
      → Add vào weatherList
  → setState() rebuild UI
  → FutureBuilder hiển thị danh sách
```

### 3.3 Tìm Kiếm Thành Phố - Gợi Ý

```
User types in SearchTextField
  → _onSearchChanged() callback
  → _loadSuggestions()
  → WeatherService.getCitySuggestions(query)
  → Filter suggested cities (local list)
  → setState() update suggestions
  → Hiển thị dropdown với matching cities
```

### 3.4 Chọn Thành Phố - Điều Hướng

```
User taps city in suggestions/featured list
  → Navigator.push()
  → DetailPage(city: selectedCity)
  → DetailPage.initState()
  → WeatherService.getWeatherByCity(city)
  → API call → JSON response
  → Convert to WeatherData
  → FutureBuilder renders detail page
```

### 3.5 Xử Lý Lỗi

```
API error / network timeout:
  → catch exception
  → FutureBuilder displays error message
  → User can tap "Quay lại" to return
```

## 4. API Integration Details

### 4.1 OpenWeatherMap API Standards

- **Base URL**: `https://api.openweathermap.org/data/2.5`
- **Endpoint**: `/weather?q={city}&appid={apiKey}&units=metric&lang=vi`
- **API Key**: `a91e7f4aef8e37fd5e7286a20d53d5cb`
- **Units**: metric (Celsius)
- **Language**: Vietnamese (vi)
- **Timeout**: 8 seconds

### 4.2 Response Structure

```json
{
  "name": "Hà Nội",
  "sys": {
    "country": "VN"
  },
  "main": {
    "temp": 32.0,
    "feels_like": 34.4,
    "humidity": 50,
    "pressure": 1002
  },
  "wind": {
    "speed": 8.07
  },
  "weather": [
    {
      "main": "Clear",
      "icon": "01d"
    }
  ],
  "clouds": {
    "all": 5
  }
}
```

## 5. State Management Pattern

### 5.1 HomePage State

- `searchController`: Quản lý text input
- `suggestions`: Danh sách gợi ý hiện tại
- `weatherDataFuture`: Future chứa danh sách thời tiết 6 thành phố

### 5.2 DetailPage State

- `weatherFuture`: Future chứa dữ liệu thli tiết 1 thành phố

## 6. User Interactions Flow

```
Start
  │
  ├─→ [View Featured Cities]
  │    ├─→ [Tap City] → DetailPage
  │    └─→ [Back] → HomePage
  │
  ├─→ [Type in Search]
  │    └─→ [Show Suggestions] → Dropdown
  │         ├─→ [Tap Suggestion] → DetailPage
  │         └─→ [Clear] → Hide Suggestions
  │
  ├─→ [Tap Search Button]
  │    └─→ DetailPage (if city valid)
  │
  └─→ DetailPage
       └─→ [Tap Back Arrow] → HomePage
```

## 7. Tối Ưu Hóa & Performance

### 7.1 Lazy Loading

- FutureBuilder chỉ tải dữ liệu khi cần
- Featured cities tải một lần khi khởi động
- Detail page tải khi user chọn thành phố

### 7.2 Caching Suggestions

- Cache danh sách gợi ý cục bộ (không API call)
- Giảm độ trễ & tải API

### 7.3 Error Handling

- API timeout: 8 giây
- Try-catch block cho mọi API call
- Hiển thị error message thân thiện

## 8. Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.1.0          # HTTP requests
  intl: ^0.19.0         # Internationalization
```

## 9. File Structure

```
lib/
  └── main.dart
      ├── WeatherApp                (Root widget)
      ├── WeatherService            (API service)
      ├── WeatherData               (Data model)
      ├── HomePage                  (List screen)
      └── DetailPage                (Detail screen)
```

## 10. Màn Hình UI Description

### HomePage

- **Header**: "MSSV - Dự báo thời tiết"
- **Search Section**:
  - TextField với placeholder
  - Search button (blue)
  - Suggestions dropdown (if match)
- **Featured Cities**:
  - Title: "Thành phố nổi bật"
  - 6 cards with: city name, description, temperature, weather icon

### DetailPage

- **Header**: Back arrow button
- **Main Display**:
  - City name (large)
  - Weather icon (emoji)
  - Temperature (very large)
  - Description (uppercase)
- **Details Grid** (2x2):
  - Cảm giác (°C)
  - Độ ẩm (%)
  - Sức gió (m/s)
  - Áp suất (hPa)

## 11. Color Scheme

- **Primary**: Colors.blue
- **Background (Detail)**: Blue gradient
- **Text**: Black, White, Grey
- **Cards**: White borders with light backgrounds
- **Icons**: Emoji for weather (flexible)

## 12. Sequence Diagram

```
User          App             API
 │             │               │
 ├─ Tap City ─→│               │
 │             ├─ getWeather ──→│
 │             │                │
 │             │  ←─ JSON ──────┤
 │             ├─ Parse ──→ WeatherData
 │             │
 │ ←─ Show Detail Page ────│
 │             │
 ├─ Tap Back ─→│
 │             │
 │ ←─ Return to HomePage ────│
```
