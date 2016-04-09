# ENSC424-Focus_Stacking
Multimedia Communications Engineering project on image focus stacking written in MATLAB

## Introduction
Focus stacking is a digital image processing technique that increases the depth of focus of an image. It does this by combining a focal stack, which is defined as multiple images of the same subject taken at different focal depths. In order to combine the images correctly, you need to identify the most focused pixels in each image of the focal stack and choose those as the pixels for the final focus stacked image. In other words, the in-focus regions of each picture need to be selected and blended together into a single image. The result is a sharply focussed single image with an extended depth of field that covers all significant elements in a scene. 

The portion of a scene that appears sufficiently sharp is called the depth of field of an image. There are many applications where it is difficult to capture all important elements of a picture in proper focus in a single image. This is especially a concern for macrophotography (extreme close-up), landscape photography, and microscopy. In landscape photography many important elements will appear at different depths throughout the field of view, hence the need for focus stacking. Likewise, small changes of focal distance in the scale of micrometres result in very differently focussed output images when dealing with microscopy.

## Method
There were several different ways of implementing focus stacking in software. The most straightforward method is to measure contrast; the image with the largest differences between pixel values is the sharpest. An alternative way would be to compute the variance (or standard deviation) of the pixel values; and the region with the larger number is the sharpest. By using a Fast Fourier Transform, you could determine what sections of the image have the highest frequency content. This allows to favor a picture that's extremely sharp in some parts (but less so in others) over one that has more depth of field, so more of the image is reasonably sharp, but the maximum sharpness is lower. The most common technique is to determine the sharpness of the image would be through edge detection. This method finds the boundaries of objects in an image by looking for discontinuities in brightness; higher the number of edges, the sharper the image.

This project achieves its goal by combining Gaussian and Laplacian Edge Detection filters which lead to a practical and straightforward implementation of focus stacking.
