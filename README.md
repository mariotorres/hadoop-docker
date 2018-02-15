## Hadoop Dockerfile 

`$ docker build -t hadoop-docker .`
`$ docker run -d -P --name test_sshd hadoop-docker`
`$ docker port test_sshd 22`