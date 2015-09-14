#!/usr/bin/env bash
cd "/opt/echoprint/echoprint-server/solr/solr"
java -Djava.awt.headless=true -jar start.jar &
