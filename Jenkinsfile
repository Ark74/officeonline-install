pipeline {
  agent {
    node {
      label 'debian'
    }
    
  }
  stages {
    stage('Script checks') {
      agent {
        node {
          label 'debian'
        }
        
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
          agent any
          steps {
            sh '''#!/bin/bash
set -vx
sudo ./officeonline-install.sh -c sh_interactive=false
'''
          }
        }
        stage('Ubuntu') {
          agent {
            node {
              label 'ubuntu'
            }
            
          }
          steps {
            sh '''#!/bin/bash
set -vx
sudo ./officeonline-install.sh -c sh_interactive=false
'''
          }
        }
      }
    }
  }
}