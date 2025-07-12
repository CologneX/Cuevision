# Cuevision

Cuevision is an iOS application built with Swift that helps billiard players improve their aim using the Diamond System. The app uses computer vision and machine learning to provide visual guidance, identify ball colors and numbers, and locate their positions on the table.

## 🎱 Features

  * **Diamond System Aiming**: Provides visual guidance to players for aiming based on the Diamond System calculations.
  * **Ball Detection and Recognition**: Uses fine-tuned YOLOv8 to detect and identify the color and number of each ball on the billiard table.
  * **Ball Position Tracking**: Accurately locates and tracks the position of each ball on the table in real-time.
  * **Visual Guidance**: Overlays visual aids on the camera feed to guide the player's shots.

## 💻 Technology Stack

  * **Platform**: iOS
  * **Language**: Swift
  * **Frameworks**:
      * **SwiftUI**: For building the user interface.
      * **AVFoundation**: For accessing the camera feed.
      * **Vision**: For implementing computer vision features.
      * **Core ML**: For integrating machine learning models for ball recognition.
      * **YOLOv8**: Pre-trained machine learning model, fine-tuned with billiard balls dataset made in Roboflow

## 🚀 Getting Started

These are instructions on setting up your project locally. To get a local copy up and running follow these simple example steps.

### Prerequisites

  * iOS 15.0 or later

### Installation

As of now, our TestFlight links are not available, due to the Apple Developer Program account responsible for uploading to App Store is expired 

-----
## Usage

1.  Launch the app on your iOS device.
2.  Point the camera at the billiard table.
3.  Follow the on-screen instructions to mark the positions of the cue ball and the object ball.
4.  The app will display the calculated aiming path.
5.  Align your shot using the visual guidance provided.
6.  Take the shot with confidence\!
