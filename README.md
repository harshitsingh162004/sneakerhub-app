# SneakerHub App — Flutter Frontend

Premium sneaker auction mobile app built with Flutter.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **HTTP Client:** Dio
- **Navigation:** GoRouter
- **WebSocket:** stomp_dart_client
- **Storage:** flutter_secure_storage

## Features
- JWT Authentication (Login/Register)
- Browse live auctions
- Realtime bidding via WebSocket
- Live price updates across all connected users
- Search with brand filters
- Chat between buyer and seller
- Upcoming auctions
- Seller auction creation
- Premium dark blue UI

## Backend
Connected to live Spring Boot backend deployed on AWS EC2.
Backend repo: https://github.com/harshitsingh162004/sneakerhub-backend

## Setup
1. Clone the repo
2. Run `flutter pub get`
3. Connect your Android device
4. Run `flutter run`

## Screens
- Splash screen with animation
- Login / Register
- Home — live auction feed
- Auction detail — realtime bidding
- Search with filters
- Chat
- Upcoming auctions
- Profile
- Create auction (seller)
