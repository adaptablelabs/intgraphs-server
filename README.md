# `cron` server for project `intgraphs`

Purposes of this server

- Be able to update the code of project `intgraphs` ([https://github.com/adaptablelabs/intgraphs](https://github.com/adaptablelabs/intgraphs))
- Set up a `cron` job to automatically run certain task defined in project `intgraphs`.

## Sever Setup

There are two ways to setup the server. 
- Utilize the `Docker` (https://www.docker.com/) to run the "docker container" to handle all the work. 
- "Manually" set up the server as well as the "cron" job. 

> Given the case that the current project needs frequent updates to the app, it is using the "Manual" way to set up the server. 

### Set up Docker

When in this method, the `intgraphs` app code will need to be pulled to this `docker config` folder (where this `README` file locates), 
under the `apps` folder. 

#### Create "Docker Image"

```bash
# Under "root folder", and use `-f` to specify "Dockerfile" location
# Using this way to set "context" of building the docker image
docker build --no-cache \
	-f containers/intgraphs_cron/Dockerfile \
	-t img_intgraphs_server . 
```

#### Start a Docker

```bash
# Start a docker
# Add `-d` to run it as a daemon
docker run --rm -it \
	-v $(pwd):/intgraphs_server \
	-v $(pwd)/scripts:/scripts \
	-v $(pwd)/data/log:/var/log \
	--name intgraphs_server \
	img_intgraphs_server
```

### Manual Setup

#### Config the Server Running Env. 

The setup includes the following steps. 
- Refer to the docker config file `/containers/intgraphs_cron/Dockerfile` to learn the "CLI CMDs" used to set up the server. 
- Create the project folder  (eg. `/intgraphs_server`). 
- Once done, pull the `intgraphs` app code to a folder (eg. `/intgraphs_server/apps`). 
- Create other folders inside the project folder. 
```bash
intgraphs_server
├── apps    # The app code
├── log
│   └── intgraphs-job.log   # The log file to contain the output of "cron running"
├── scripts                 # The scripts to help run the project. 
│   ├── intgraphs-cron      # The setting of "cron" job (timeing).
│   ├── job.sh              # The settings of the actual "job". 
│   └── run-cron.sh         # The CLI script to "start" the cron job. 
└── ssh                     # The SSH used to "pull" the code from the Git repo. 
    ├── id_lei_shi_digitalocean
    └── id_lei_shi_digitalocean.pub
```

> Use the following useful CMDs to help set up and run the project.  

----

## Useful CMDs

### Update `intgraphs` code

```bash
eval $(ssh-agent) \
  && ssh-add ~/.ssh/id_lei_shi_digitalocean \
  && cd /intgraphs_server/apps/intgraphs/ \
  && git pull
```

### Test-run the script

```bash
cd /intgraphs_server/apps/intgraphs/

# Remove the "data" if needed
rm -R 01-ETL/data/ 02-APPs/data/

# Run
cd /intgraphs_server/apps/intgraphs/ \
  && export PATH=/root/anaconda3/bin:$PATH \
  && eval "$(conda shell.bash hook)" \
  && conda activate intgraphs \
  && sh run-pipe-testing.sh  
```

### Re-run the `cron`

```bash
# Check status
service cron status

# Check "cron" process
ps aux | grep cron

# Start
cd /intgraphs_server/ \
  && service cron stop \
  && rm -rf /var/run/crond.pid \
  && sh scripts/run-cron.sh
```

### Install additional Python packages under `conda` env

```bash
conda activate intgraphs
conda install pandas=1.0.0
pip install goose3
pip install git+https://github.com/boudinfl/pke.git
python -c "import nltk; nltk.download(['popular', 'universal_tagset'])"
# Note: 'popular' contains stopwords, averaged_perceptron_tagger, wordnet and punkt
pip install spacy
python -m spacy download en
```

### Install R packages

```bash
# R
install.packages('readr')
install.packages('plotly')
```
