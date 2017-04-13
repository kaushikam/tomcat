# tomcat
Trying to build a minimal tomcat docker container

### Things to note

1. Add following files to the root of the repo
    1. apache-tomcat-8.5.13.tar.gz 
    2. jdk-8u121-linux-x64.tar.gz
2. User name and password for the apache tomcat
    * ___User name___: _admin_
    * ___Password___: _password_
3. If you want to map the SSH server running to a port 32270 and tomcat server to 32271, your docker run command should be like below:
    * _docker run --name tomcat -p 32270:22 -p 32271:8080 -it kaushik/tomcat_
4. Root user password is "_secret_"    

