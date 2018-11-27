#!/usr/bin/env groovy

// Global scope required for multi-stage persistence
def artServer = Artifactory.server 'art-p-01'
def buildInfo = Artifactory.newBuildInfo()
def distDir = 'build/dist/'
def agentSbtVersion = 'sbt_0-13-13'

pipeline {
    libraries {
        lib('jenkins-pipeline-shared')
    }
    environment {
        SVC_NAME = "sbr-schema"
        ORG = "SBR"
        LANG = "en_US.UTF-8"
    }
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
        timeout(time: 1, unit: 'HOURS')
        ansiColor('xterm')
    }
    agent { label 'download.jenkins.slave' }
    stages {
        stage('Checkout') {
            agent { label 'download.jenkins.slave' }
            steps {
                checkout scm        
                script {
                    buildInfo.name = "${SVC_NAME}"
                    buildInfo.number = "${BUILD_NUMBER}"
                    buildInfo.env.collect()
                }
                colourText("info", "BuildInfo: ${buildInfo.name}-${buildInfo.number}")
                stash name: 'Checkout'
            }
        }

        stage('Run'){
            agent { label "test.${agentSbtVersion}" }
            steps {
                unstash name: 'Checkout'
                sh "whoami"
                sh "ls config/Test"
                // sh "sudo chmod -R 777 HBase_scripts"
                // sh "sudo chmod -R 777 Dummy_Data"
                // sh "bash Run.sh sbr_dev_db 999912 r"
            }
            post {
                success {
                    colourText("info","Stage: ${env.STAGE_NAME} successful!")
                }
                failure {
                    colourText("warn","Stage: ${env.STAGE_NAME} failed!")
                }
            }
        }
        // stage('Test Edits'){
        //     agent { label "test.${agentSbtVersion}" }
        //     steps {
        //         unstash name: 'Checkout'
        //         sh "whoami"
        //         sh "ls"
        //         sh "sudo chmod -R 777 Edits/"
        //         sh "bash edit.sh Edits/test_edits.txt sbr_dev_db 999912 r"
        //     }
        //     post {
        //         success {
        //             colourText("info","Stage: ${env.STAGE_NAME} successful!")
        //         }
        //         failure {
        //             colourText("warn","Stage: ${env.STAGE_NAME} failed!")
        //         }
        //     }
        // }
        // stage('Test Data'){
        //     agent { label "test.${agentSbtVersion}" }
        //     steps {
        //         unstash name: 'Checkout'
        //         sh "whoami"
        //         sh "ls"
        //         sh "sudo chmod -R 777 HBase_Tests"
        //         sh "bash HBase_Tests/Data.sh sbr_dev_db 999912 r"
        //     }
        //     post {
        //         success {
        //             colourText("info","Stage: ${env.STAGE_NAME} successful!")
        //         }
        //         failure {
        //             colourText("warn","Stage: ${env.STAGE_NAME} failed!")
        //         }
        //     }
        // }
        
    }
}
