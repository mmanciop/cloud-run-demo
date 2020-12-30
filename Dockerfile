FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt-get install -y dialog

ADD ./src/* /demo/

RUN ln -s /demo/deploy_and_run.sh /bin/cloudshell_open