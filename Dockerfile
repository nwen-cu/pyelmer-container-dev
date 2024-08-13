# Use an official Ubuntu as a parent image
FROM ubuntu:22.04

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install sudo, software-properties-common
RUN apt-get update && \
    apt-get install -y sudo software-properties-common

# Add the PPA repository for ElmerFEM
RUN sudo add-apt-repository ppa:elmer-csc-ubuntu/elmer-csc-ppa && \
    sudo apt-get update && \
    sudo apt-get install -y elmerfem-csc

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# Install developer utilities and tools
RUN apt-get install -y build-essential git wget curl vim unzip nano nodejs

# Install X11 libraries and other required libraries
RUN apt-get install -y libglu1-mesa libxrender1 libxcursor1 libxft2 libx11-dev libxext-dev libxtst6 libxi6 libxrandr2 libxinerama1 libgl1-mesa-glx libgl1-mesa-dev xvfb x11-xkb-utils xkb-data

# Install JupyterLab
RUN pip3 install 'jupyterlab>=3' notebook ipywidgets 'pyvista[all,trame]' trame_jupyter_extension pyvirtualdisplay

# Install commonly used data science packages
RUN pip3 install numpy pandas matplotlib scipy scikit-learn seaborn plotly

# Install additional specified packages
RUN pip3 install pyelmer objectgmsh meshio datajson

# Expose port for JupyterLab
EXPOSE 8888

ENV PYVISTA_TRAME_JUPYTER_MODE=extension

# Set the working directory
WORKDIR /workspace

# Create a non-root user and switch to it
RUN useradd -ms /bin/bash elmeruser
USER elmeruser

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
