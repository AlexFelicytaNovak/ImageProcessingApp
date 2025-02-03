# 🖼️ Image Processing Application
MacOS application, developed in **Swift** and **SwiftUI**, provides  graphical user interface for applying:
- Functional filters
- Convolution filters
- Morphological operations
- Dithering
- Color quantization
to the image.
Users may load images, apply transformations, and save the results.
All filter and transformation implementations are done using **pixel-by-pixel operations**.

## ✨ Key Features
### Image Filtering
**1. Functional filters** <br>
The application provides an interactive graph for functional filters using polylines. Users can create new filters starting with an identity function (a straight line), add, move, or delete points on the graph, and edit existing filters (except gamma correction). Available filters:
- Inversion
- Brightness 
- Contrast adjustment
- Gamma correction

**2. Convolution filters**
- Blur 
- Gaussian blur
- Sharpen
- Edge detection 
- Emboss

### Morphological operations
The application supports essential morphological operations using a 3x3 kernel:
- Erosion
- Dilation
- Opening
- Closing

### Dithering algorithm
The application applies **ordered dithering** using adjustable threshold maps, with sizes chosen by the user (2, 3, 4, or 6). Both RGB and grayscale images are supported, with dithering applied separately to each channel.

### Color quantization algorithm
The application uses **median cut**, which reduces the number of colours in an image to a value selected by the user while preserving the image’s overall appearance.

## 🔨 Installation 
To install the project you need a Mac with **Xcode 14 or later** installed.
1. Open `CGProject2.xcodeproj` in Xcode.
2. Select CGProject2 build target and My Mac as run destination.
3. Build and Run the project.

## 📸 Screenshots
<img width="1680" alt="imgProcessingApp" src="https://github.com/user-attachments/assets/7d96ffb1-4d48-4c4c-8192-1ae1458f942f" />

## 📄 Credits
The project was developed as part of the **Computer Graphics** course at **Warsaw University of Technology**
