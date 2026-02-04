######
# docker build script for image
######
#!/bin/bash
set -e

image_build() {
    echo "Building Docker image..."
    IMAGE_NAME="model-base-image"
    docker build -t $IMAGE_NAME -f /docker/Dockerfile .
    echo "Docker image '$IMAGE_NAME' built successfully."

}


#######
# push the image to a registry
#######

image_push() {
    echo "Pushing Docker image to registry..."
    IMAGE_NAME="model-base-image"
    tag="v1.0"  
    REGISTRY_URL="docker.io/sunnydeva" 
    docker tag $IMAGE_NAME $REGISTRY_URL/$IMAGE_NAME:$tag
    docker push $REGISTRY_URL/$IMAGE_NAME:$tag
    echo "Docker image '$IMAGE_NAME' pushed to '$REGISTRY_URL' successfully."  
} 
 
# Main script execution
image_build
