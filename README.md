# CCA-F Practice Exam App

A comprehensive Flutter-based practice exam application designed to help cloud professionals prepare for the **Certified Cloud Architect - Foundations (CCA-F)** certification. The app provides a robust testing environment with a massive question bank, advanced randomization, and performance analytics.

## ✨ Features

- **Massive Question Bank:** Includes over 1,300+ community-sourced questions spanning all 5 core CCA-F domains.
- **Dynamic Randomization Engine:** Questions and multiple-choice options are fully shuffled on every attempt to prevent pattern memorization and option-length bias.
- **Mock & Practice Modes:** Simulate real timed exams or use practice mode to get immediate feedback.
- **Flag & Skip Functionality:** Flag difficult questions for later review and skip through questions seamlessly.
- **Performance Analytics:** Interactive dashboard using `fl_chart` to track domain mastery and recent exam scores.
- **Modern UI:** Distraction-free, dark-themed glassmorphism aesthetic tailored for developer focus.
- **Local Persistence:** Saves user progress, high scores, and exam states locally using `shared_preferences`.
- **AdMob Integration:** Pre-configured for Google AdMob banner and interstitial ads.

## 🛠 Tech Stack

- **Framework:** Flutter (Dart)
- **State/Storage:** `shared_preferences`
- **Charts:** `fl_chart`
- **Monetization:** `google_mobile_ads`
- **Configuration:** `flutter_dotenv`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`^3.11.5` or later)
- Android Studio / Xcode for emulators and building.

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd "cca-f practice exam app"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   Create a `.env` file in the root directory and add your AdMob and Package details:
   ```env
   # AdMob Config
   ANDROID_BANNER_AD_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
   ANDROID_INTERSTITIAL_AD_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
   IOS_BANNER_AD_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
   IOS_INTERSTITIAL_AD_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx

   # App Info
   DEVELOPER_WEBSITE=https://your-website.com/
   PACKAGE_NAME=com.yourcompany.ccapractice
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## 📦 Building for Production

To create a release app bundle for the Google Play Store:

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```
*(Note: Ensure your keystore configuration is properly set up in `android/key.properties` or your `.env` file depending on your CI/CD setup).*

## 📚 Domains Covered

The practice questions thoroughly evaluate understanding in the following domains:
1. Agentic Architecture & Orchestration
2. Claude Code Configuration & Workflows
3. Prompt Engineering & Structured Output
4. Tool Design & MCP Integration
5. Context Management & Reliability

## 📄 License
This project is for educational and certification preparation purposes.
