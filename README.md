# Jenkins in Docker using Alpine Linux
jenkins in Docker using the alpine image, updated with a few packages i need for my demo


## Details

* Installs needed packages
* Mounts docker.sock as a volume to be used by the jenkins docker plugin
* Installs specific plugins needed
* Sets up Groovy sdk 
* Copies "fake" credentials to handle permissions (would need to be updated)

## Alpine Linux

### Adding Packages

    Adding a package you just need to add a line: ` apk add <your package name> `
* [Alpine Packages](http://pkgs.alpinelinux.org/packages)

### Installed Packages

* sudo
* curl 
* nodejs 
* ruby 
* go 

## References

* [Codecentric Blog post on Docker CI](https://blog.codecentric.de/en/2015/10/continuous-integration-platform-using-docker-container-jenkins-sonarqube-nexus-gitlab)

