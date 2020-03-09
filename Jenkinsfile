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
                    ["http://www.tinycorelinux.net/11.x/x86/release/CorePlus-current.iso",
                     "https://ftp.gnu.org/gnu/guix/guix-system-install-1.0.1.x86_64-linux.iso.xz"].each{
                        sh "wget --continue $it"
                    }
                    sh "xz -d guix-system-install-1.0.1.system.iso.xz"
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

