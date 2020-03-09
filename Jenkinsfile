pipeline {
    agent {
        label "master"
    }
    parameters {
        booleanParam(name: "BUILD_IMAGE",
                     defaultValue: false,
                     description: "Build container image")
    }
    options {
        disableConcurrentBuilds()
    }
    triggers {
        cron(env.BRANCH_NAME == "master" ? "H 15 * * 1-5" : "")
    }
    stages {
        stage("Invoking Docker") {
            when { expression { params.BUILD_IMAGE } }
            steps {
                sh "docker build -t localhost:5000/multicd:latest ."
            }
        }
        stage("Build iso") {
            steps {
                sh """
docker run                                      \
 --rm                                           \
 --network=host                                 \
 --volume /home/oleg/src/multicd:/opt/multicd   \
 --cap-add=SYS_ADMIN                            \
 --device /dev/loop0                            \
 --device /dev/loop-control                     \
 --workdir /opt/multicd/                        \
 --name multicd                                 \
 localhost:5000/multicd:latest                  \
 ./multicd.sh
"""
                archiveArtifacts (artifacts: "build/multicd.iso")
            }
        }
    }
    post {
        always {
            sendNotifications currentBuild.result
        }
    }
}

