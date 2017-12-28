pipeline {
  agent any
  stages {
    stage('Script checks') {
      agent {
        node {
          label 'debian'
        }
        
      }
      steps {
        sh '''#!/bin/bash;
set -e;
find . -type f -name \'*.sh\' -exec shellcheck {} \\;'''
      }
    }
    stage('Builds') {
      parallel {
        stage('Debian') {
          agent {
            node {
              label 'debian'
            }
            
          }
          steps {
            sh '''#!/bin/bash;
set -e;
find . -type f -name \'*.sh\' -exec shellcheck {} \\;'''
          }
        }
        stage('Ubuntu') {
          agent {
            node {
              label 'ubuntu'
            }
            
          }
          steps {
            sh '''#!/bin/bash;
set -e;
find . -type f -name \'*.sh\' -exec shellcheck {} \\;'''
          }
        }
      }
    }
  }
}