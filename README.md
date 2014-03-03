# Technology Scavenger

## Goal

* Goof around with Processing [1]
* Given an image, create random clusters of pixels of about the same color (given a threshold)
	* Clusters have random size (minimum and maximum sizes are specified)
	* Clusters might not even reach the minimum size if neighboring pixels do not comply with the average color of that cluster

## Solution

Algorithm:
1. Create cluster from the top-left corner of the image
2. Pick random pixel from current cluster
3. Check random neighbor (not already clustered or invalid - corner cases) for color proximity
4. If possible to cluster, add it to the cluster
5. Otherwise, move on to another random pixel
6. Repeat from 2. until cluster size is reached or nowhere to go (no neighboring pixel shares average color)
7. Pick new pixel from the ones not yet clustered
8. Repeat from 2. until there are no more pixels to cluster

# References
* [1] [Processing Documentation](http://www.processing.org/reference/)

*by Daniel Serrano*