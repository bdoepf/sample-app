#!/bin/bash
mv /tmp/gs-spring-boot-0.1.0.jar /opt/gs-spring-boot-0.1.0.jar
mv /tmp/sample-app.service /etc/systemd/system/sample-app.service
systemctl enable sample-app.service