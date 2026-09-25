# Farming Simulator Mod Hub for iOS

An iOS application designed for the Farming Simulator community, providing a seamless experience for browsing, managing, and creating in-game content. The app features a rich content library for mods, maps, skins, and wallpapers, alongside a powerful in-app Avatar Creator. All content is dynamically loaded from **Dropbox** and cached locally using **Core Data** for a fast, offline-first experience.

[![Swift Version](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)

## ✨ Key Features

- **Dynamic Content System**: All mods, maps, and other assets are fetched directly from a Dropbox backend, allowing for easy content updates without releasing a new app version.
- **Robust Offline Caching**: Utilizes Core Data to cache all text and image data, ensuring the app is fully functional even without an internet connection.
- **Feature-Rich Avatar Creator**: A complete editor to create and customize characters. Select different body parts, clothing, and accessories, and save your creations.
- **Multiple Content Categories**:
    - mods
    - maps
    - skins
    - wallpapers
- **Powerful Search & Filtering**: Easily find content with a dedicated search bar and filter options for **All**, **New**, **Top**, and **Favorite** items.
- **Nickname Generator**: A fun utility to generate unique nicknames for your gaming profile.
- **Modern & Responsive UI**: Built entirely with **SwiftUI**, featuring a custom design system for a clean and consistent user experience on both iPhone and iPad.

## 🛠️ Tech Stack & Architecture

- **Language**: **Swift**
- **UI**: **SwiftUI**
- **Architecture**: **MVVM** (Model-View-ViewModel) for a clear separation of concerns.
- **Data Persistence**: **Core Data** for robust local storage and offline caching.
- **Networking**: Direct integration with the **Dropbox API** for fetching content manifests and assets.
- **Concurrency**: **async/await** and **TaskGroup** for modern, efficient background operations.
- **Design**: A custom design system with reusable components, colors, and fonts.

## 🚀 Getting Started

### Prerequisites
- Xcode 14.x or later
- Swift 5.7+
- macOS Ventura or later