pipeline {
  agent any
  stages {
    stage('OS builds') {
      parallel {
        stage('Debian build') {
          steps {
            node(label: 'debian') {
              sh '''#!/bin/bash;
set -e;
find . -type f -name \'*.sh\' -exec shellcheck {} \\;'''
            }
            
          }
        }
        stage('Ubuntu build') {
          steps {
            node(label: 'ubuntu') {
              sh '''#!/bin/bash;
set -e;
find . -type f -name \'*.sh\' -exec shellcheck {} \\;'''
            }
            
          }
        }
      }
    }
  }
}