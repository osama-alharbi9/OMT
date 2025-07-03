# OMT – Media Recommendation App

OMT is a Flutter-based mobile application that recommends movies and TV shows based on user preferences and interaction history. Inspired by Tinder-style flashcards, users can swipe right to save content to their watchlist or left to dismiss.

Built with a clean, scalable Feature-First architecture, powered by Riverpod, and integrated with Firebase and TMDB API, OMT delivers a smooth, intuitive experience on both Android and iOS.

---

## Features

- Personalized recommendations based on user watch history  
- Swipe-based UI using animated flashcards  
- Real-time watchlist sync with Firebase Firestore  
- Search and discover trending or popular titles  
- Supports dark mode and system theme  
- Clean and modular project structure

## Project Structure

lib/
├── features/
│   ├── home/
│   ├── watchlist/
│   ├── discover/
│   └── auth/
├── core/
│   ├── theme/
│   ├── constants/
│   └── utils/
└── main.dart
