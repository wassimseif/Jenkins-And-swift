# Jenkins-And-swift
Dockerfile for an image with jenkins and swift inside
This Dockerfile builds an image for that contains the latest version `jenkins` and `swift(DEVELOPMENT-SNAPSHOT-2016-07-25-a-ubuntu14.04`.
I have written this Dockerfile for using jenkins and CI/CD for swift projects without dealing with ephemeral docker swarm.
## How to use
<ol>
<li> Make sure docker is installed. <code>version 1.12</code> and later </li>
<li><code>git clone git@github.com:wassimseif/Jenkins-And-swift.git && cdJenkins-And-swift</code> </li>
<li><code>docker build -t jenkins-swift -f Dockerfile .</code></li>
<li><code>docker run  --name jenkins-swift  -d -p 8080:8080 jenkins-swift</code></li>
<li>Head to <code>http://"your ip address":8080</code></li>
</ol>
