#!/usr/bin/env groovy

import hudson.model.*

/**
 * List of published branches names in regex representation
 */
List publishedBranches = [
        ~/^v\d+\.\d+/,
        '^(master)$'
]

node('general') {
    // Notifications - for the email sent in the end
    def subject = null
    def body = null
    def version
    def commitDescription = "upgrade versions.properties file"

    // Executor node env setup
    def nodeHome = tool name: 'NODEJS6.9.2', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
    env.PATH = "${nodeHome}/bin:${env.PATH}"

    def publishable = isPublishedBranch(env.BRANCH_NAME as String, publishedBranches as List)
    def bintrayEmail = ''
    def bintrayToken = ''
    try {
        stage('checkout') {
            checkout scm
            sh "git branch -D ${env.BRANCH_NAME} || true && git checkout -b ${env.BRANCH_NAME}"
            sh 'git clean -dfx'
        }

        stage('CI Tools Checkout') {
            sh "/home/jenkins/.local/bin/citools-install.sh"
        }

        stage('Version') {
            version = sh(script: "./ci/citools/bin/citools printPreReleaseVersion ", returnStdout: true).trim()
            echo "Version = ${version}"
        }

        stage('install') {
            sh 'npm install'
        }

        stage('publish') {
            echo "versionName = ${version}"
            sh "npm run scoped-tag-version ${version}"
            echo 'publish to mArtifactoy'
            sh "npm run scoped-publish:dev"
        }

        stage('Rafiki') {
            def name = "com.medallia.digital.mobilesdk.medallia-digital-cordova"

            sh "test -e build && echo file exists || mkdir build"
            sh "./ci/citools/bin/citools cleanup"
            sh "./ci/citools/bin/citools generateNpmArtifactManifest --npmName ${name} --npmVersion '${version}'"
            sh "./ci/citools/bin/citools generateAndPublishManifest --appVersion ${version}"
            sh "./ci/citools/bin/citools labelManifest --label=committed,latest"
        }

        stage('build sample app') {
            if (env.BRANCH_NAME == 'master' || publishable) {
                def sdk_version = readFile("version.properties")
                println(sdk_version)
                sh 'rm -rf ./MobileSDK-Cordova-Sample'
                sh "git clone git@github.medallia.com:Digital/MobileSDK-Cordova-Sample.git"
                dir('MobileSDK-Cordova-Sample/platforms/android') {
                    def fileContents = readFile file: "version.properties", encoding: "UTF-8"
                    fileContents = sdk_version
                    writeFile file: "version.properties", text: fileContents, encoding: "UTF-8"

                    try {
                        sh "git commit -a -m '${commitDescription}'"
                        sh "git push"
                    } catch (Exception e) {

                    }
                }
            }
        }
    } catch (exception) {
        subject = "Build #${env.BUILD_NUMBER} of '${env.JOB_NAME}' job has finished with result of ${currentBuild.result}"
        body = "It appears that ${env.JOB_NAME} is failing."

        throw exception
    } finally {
        if (subject == null && body == null) {
            // First successful build
            if (currentBuild.result in [null, 'SUCCESS'] && currentBuild.previousBuild == null) {
                subject = "Job '${env.JOB_NAME}' first build went smooth!"
                body = "Log: ${env.BUILD_URL}"
            }

            // Build back to normal
            if (subject == null && currentBuild.result in [null, 'SUCCESS'] && currentBuild.previousBuild.result != 'SUCCESS') {
                subject = "Job '${env.JOB_NAME}' back to normal on build #${env.BUILD_NUMBER}"
                body = "Log: ${env.BUILD_URL}"
            }

            // Successful build on master branch
            if (subject == null && currentBuild.result in [null, 'SUCCESS'] && env.BRANCH_NAME == 'master') {
                subject = "Job '${env.JOB_NAME}' build #${env.BUILD_NUMBER} was made from 'master' branch and finished successfully"
                body = "Build details: ${env.BUILD_URL}"
            }
            // Successful build on RC branch
            else if (subject == null && currentBuild.result in [null, 'SUCCESS'] && publishable) {
                subject = "Job '${env.JOB_NAME}' build #${env.BUILD_NUMBER} was made from '${env.BRANCH_NAME}' branch and finished successfully"
                body = "Build details: ${env.BUILD_URL}"
            }
        }

        try {
            def recipients = publishable ? 'md-jenkins-watchers@medallia.com' : ''

            if (subject) {
                emailext(
                        subject: subject,
                        body: body,
                        recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                        to: recipients,
                        attachLog: true
                )
            }
        } catch (exception) {
            echo "Failed to send email notification. Reason: ${exception}"
        }
    }
}

/**
 * Determines whenever the branch is published or not based on its name
 * @param branch Branch name to check
 * @param publishedBranchesRegex List of published branches names in regex representation
 * @return is published branch
 */
def isPublishedBranch(String branch, List publishedBranchesRegex) {
    publishedBranchesRegex.find { branch ==~ it } as boolean
}
