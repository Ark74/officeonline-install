pipeline {
  agent any
  stages {
    stage('Script checks') {
      agent {
        node {
          label 'debian'
        }
        
      }
      environment {
        SHELLCHECK_OPTS = '-e SC2086 -e SC2001'
      }
      steps {
        sh '''#!/bin/bash
set -xe
for myscript in $(find $WORKSPACE -type f -not -path "*@tmp*" -name \'*.sh\'); do
shellcheck $myscript
 done'''
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
find $WORKSPACE -type f -name \'*.sh\''''
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
find $WORKSPACE -type f -name \'*.sh\''''
          }
        }
      }
    }
    stage('Clean') {
      steps {
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenUnstable: true, cleanupMatrixParent: true, deleteDirs: true)
      }
    }
  }
}