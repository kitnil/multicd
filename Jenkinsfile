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
    stages {
        stage("Invoking Docker") {
            when { expression { params.BUILD_IMAGE } }
            steps {
                sh "docker build -t localhost:5000/multicd:latest ."
            }
        }
        stage("Fetch sources") {
            steps {
                script {
                    ["TinyCore-current.iso",
                     "debian-live-10.2.0-amd64-xfce.iso",
                     "clonezilla-live-2.6.0-37-i686.iso",
                     "netboot.xyz.iso"].each{
                        sh "wget --continue http://iso.wugi.info/$it"
                    }
                }
            }
        }
        stage("Build iso") {
            steps {
                sh """
docker run                                      \
 --rm                                           \
 --network=host                                 \
 --volume $WORKSPACE:/opt/multicd               \
 --cap-add=SYS_ADMIN                            \
 --device /dev/loop0                            \
 --device /dev/loop-control                     \
 --workdir /opt/multicd/                        \
 --name multicd                                 \
 localhost:5000/multicd:latest                  \
 ./multicd.sh
"""
                sh "sudo chown --recursive 1000:1000 build"
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

