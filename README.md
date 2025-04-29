# ToDoGarden 🌱  
### 할 일 관리로 채워가는 내 손안의 작은 가든

<div align="center">
  하루하루를 채워가는 나만의 할 일 정원  
  직관적인 UI와 다양한 기능으로 할 일을 기록하고,  
  매일의 성장을 확인해보세요.
</div>

<br>

<div align="center">

![UIKit](https://img.shields.io/badge/-UIKit-1225F9?style=flat&logo=swift&logoColor=white)
![CleanSwift](https://img.shields.io/badge/-CleanSwift-123425?style=flat&logo=swift&logoColor=white)
![Combine](https://img.shields.io/badge/-Combine-5DADE2?style=flat&logo=apple&logoColor=white)
![Swift Concurrency](https://img.shields.io/badge/-Swift%20Concurrency-0A84FF?style=flat&logo=swift&logoColor=white)
![Testing](https://img.shields.io/badge/-Testing-27AE60?style=flat&logo=xcode&logoColor=white)
![OAuth](https://img.shields.io/badge/-OAuth2-FF5733?style=flat&logo=Lock&logoColor=white)
![Supabase](https://img.shields.io/badge/-Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)
![GRDB](https://img.shields.io/badge/-GRDB-F39C12?style=flat)
![Lottie](https://img.shields.io/badge/-Lottie-00C7B7?style=flat&logo=airbnb&logoColor=white)
![REST API](https://img.shields.io/badge/-REST%20API-3498DB?style=flat&logo=api&logoColor=white)
![Middlewares](https://img.shields.io/badge/-Middlewares-9B59B6?style=flat)

</div>

<br>

<div align="center">

[![Download on the App Store](https://github.com/HG-SONG/WeatherChaser/assets/88966578/51c13f13-8b33-472d-8d45-5f39f9f0bc81)](https://apps.apple.com/kr/app/weather-chaser/id6475569688)

</div>

<div align="center">

  <img width="500" alt="iconImage" src="https://github.com/user-attachments/assets/7e9bb5eb-2a3e-4167-abf3-ca465345879f">
</div>

---

## 📱 주요 기능 (Features)

- ✅ **할 일 기록 및 수정**: 날짜별로 할 일을 등록하고 수정할 수 있어요.
- 🌱 **정원 메타포 UI**: 할 일을 할수록 나의 정원이 성장합니다.
- 🔁 **오프라인 동기화**: 네트워크가 끊겨도 GRDB를 통해 데이터는 안전하게 저장됩니다.
- 📡 **서버 동기화 및 배치 처리**: Supabase를 활용해 클라우드 동기화도 손쉽게!
- 🔔 **알림 기능**: 정해진 시간에 할 일을 잊지 않도록 알림을 보내줘요.
- 🖼️ **프로필 이미지 변경**: 사진 라이브러리에서 이미지를 선택하여 나만의 프로필을 설정할 수 있어요.
- ✨ **Lottie 애니메이션**: 사용자 경험을 더욱 풍성하게!

---

## ⚙️ 기술 스택 (Tech Stack)

| 영역 | 기술 |
|------|------|
| Architecture | Clean Swift (VIP) |
| UI Framework | UIKit |
| Reactive | Combine |
| Concurrency | Swift Concurrency (async/await) |
| Database | GRDB , Supabase |
| Networking | REST API + Custom Module with Middlewares |
| Backend | Supabase |
| Authentication | OAuth 2.0 , KeyChain |
| Animation | Lottie |

---

## 🔐 권한 안내 (Permissions)

| 권한 | 설명 |
|------|------|
| 사진 라이브러리 접근 | 프로필 이미지 설정 시 사용자의 사진 앨범에 접근합니다. |
| 알림 권한 | 등록한 할 일을 정해진 시간에 리마인드합니다. |

---

## 📱 최소 지원 환경 (Requirements)

- iOS 15.0+

---

## 🧪 테스트

- VIP 아키텍처 기반의 테스트 가능한 유닛 설계
- View Double을 이용한 블랙박스 테스트 구조 구성

---

## 📌 기타

- 모든 네트워크 통신은 비동기 + 미들웨어 기반으로 설계되어 있어 테스트와 유지보수가 용이합니다.
- GRDB + Supabase 조합으로 오프라인-온라인 데이터 싱크가 매우 안정적으로 작동합니다.
- Swift Concurrency 규칙을 엄격히 준수하며, Swift 6 마이그레이션이 가능한 수준의 스레드 안전성을 확보했습니다.
