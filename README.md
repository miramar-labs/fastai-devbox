## fast.ai GPU DevBox
If you have some hardware with an NVIDIA GPU laying around and want to make your own GPU development box for fast.ai, then this is one way you can do it, without getting into all the nasty details of installing CUDA drivers and python packages.

STEP 1

Install docker on your machine - I don't know of any Mac's with NVIDIA GPU's so you will likely be doing all this on Ubuntu or some other Linux distro
    
    https://docs.docker.com/install/
    
STEP 2

    git pull git@github.com:miramar-labs/fastai-devbox.git
    
STEP 3

    cd fastai-devbox
    bash make-fastai-devbox.sh
the build might take a while but it is a one-time step. Once the build is finished you will be asked if you want to clean up intermediate files - respond with Y if you want to save on disk space

STEP 4

bring up the devbox container:
    
    docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work fastai/fastai-devbox:v1.0
    
and then navigate to JupyterLab in your browser:
    
    http://localhost:8888?token=<see output of docker run for token>
    
Note: the local folder you run it from will be mounted inside your JupyterLab container at /home/jovyan/work, which is handy for sharing files between host and container.

STEP 5:
    
Open up a Terminal window from JupyterLab and set up an SSH key:
    
        ssh-keygen
        
Some minimal git config:

        # git config
        git config --global user.email "aaron@aaroncody.com"        <--- your email here
        git config --global user.name "Aaron Cody"                  <-- your name here
        git config --global push.default simple
        git config --global url."git@github.com:".insteadOf "https://github.com/"
        
Then copy the public key (.ssh/id_rsa.pub) up to your GitHub/Settings/SSH and GPG keys section if you want to pull any repos down to your container (such as the fast-ai course and book):
    
        # fast.ai v4
        git clone git@github.com:fastai/course-v4.git
        pushd course-v4
        pip install -r requirements.txt
        popd
        
        # fast.ai book
        git clone git@github.com:fastai/fastbook.git
    
REFERENCES:

    Fast.ai: https://www.fast.ai/
    JupyterLab: https://jupyterlab.readthedocs.io/en/stable/
    Docker Stacks: https://github.com/jupyter/docker-stacks
    Dockerized NVIDIA/CUDA: https://github.com/NVIDIA/nvidia-docker/wiki/CUDA
