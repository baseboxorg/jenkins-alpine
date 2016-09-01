FROM jenkins:2.7.2-alpine

USER root
RUN   apk update \
      && apk add sudo \
      && apk add curl \
      && apk add nodejs \
      && apk add ruby \
      && apk add go \
      && rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# update npm
# RUN npm install -g npm

# getting the docker-cli
# --- Attention: docker.sock needs to be mounted as volume in docker-compose.yml
# see: https://issues.jenkins-ci.org/browse/JENKINS-35025
# see: https://get.docker.com/builds/
# see: https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Custom+Build+Environment+Plugin#CloudBeesDockerCustomBuildEnvironmentPlugin-DockerinDocker
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz && tar -xvzf docker-latest.tgz
RUN mv docker/* /usr/bin/

USER jenkins

# installing specific list of plugins. see: https://github.com/jenkinsci/docker#preinstalling-plugins
COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# Adding default Jenkins Jobs
COPY jobs/1-docker-test-job.xml /usr/share/jenkins/ref/jobs/docker-test-job/config.xml

#copy over the job script this works better if it is in git
#COPY seedjobs/dockerTestJob.groovy /var/jenkins_home/seedjobs/dockerTestJob.groovy

############################################
# Configure Jenkins
############################################
# Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml

# Jenkins Settings, i.e. Maven, Groovy, ...
#COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
#COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

# SSH Keys & Credentials
COPY config/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY config/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
COPY config/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

# tell Jenkins that no banner prompt for pipeline plugins is needed
# see: https://github.com/jenkinsci/docker#preinstalling-plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state