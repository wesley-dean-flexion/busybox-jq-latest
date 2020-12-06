pipeline {

    parameters {
        string (
            name: 'image_name',
            defaultValue: 'wesleydeanflexion/tfsec',
            description: 'the name of the image to tag / push'
        )

        string (
            name: 'repository_url',
            defaultValue: 'https://github.com/wesley-dean-flexion/tfsec_docker.git',
            description: 'the URL of the Git repository'
        )

        string (
            name: 'git_credential',
            defaultValue: 'github-wesley-dean-flexion',
            description: 'the ID of the credential to use to interact with GitHub'
        )

        string (
            name: 'docker_credential',
            defaultValue: 'dockerhub-wesleydeanflexion',
            description: 'the ID of the credential to use to interact with DockerHub'
        )
    }

    environment {
        image_name = "$params.image_name"
        repository_url = "$params.repository_url"
        git_credential = "$params.git_credential"
        docker_credential = "$params.docker_credential"
    }

    triggers {
        cron('@weekly')
        pollSCM('@hourly')
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    agent any
    stages {
        stage ('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: git_credential,
                    url: repository_url
            }
        }

        stage ('Build') {
            steps{
                script {
                    dockerImage = docker.build image_name
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    docker.withRegistry( '', docker_credential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
