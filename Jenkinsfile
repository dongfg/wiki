pipeline {
  agent any
  stages {
    stage("检出代码") {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: env.GIT_BUILD_REF]],
          userRemoteConfigs: [[
            url: env.GIT_REPO_URL,
            credentialsId: env.CREDENTIALS_ID
        ]]])
      }
    }

    stage('构建') {
      steps {
        sh '''
            pip install simiki
            simiki g
            wget -q http://gosspublic.alicdn.com/ossutil/1.7.3/ossutil64 -O /usr/local/bin/ossutil
            chmod 0755 /usr/local/bin/ossutil
        '''
        withCredentials([cloudApi(credentialsId: '38adbfce-ef65-4778-8b28-bf35bdd33ce9', secretIdVariable: 'Ali_Key', secretKeyVariable: 'Ali_Secret')]) {
            sh '''
                echo "[Credentials]
                language=CH
                endpoint=oss-cn-hangzhou.aliyuncs.com
                accessKeyID=${Ali_Key}
                accessKeySecret=${Ali_Secret}" &> $HOME/.ossutilconfig
                cat $HOME/.ossutilconfig
            '''
        }
      }
    }
    stage('同步') {
      steps {
        sh '''
            ls -l output
            ossutil ls
        '''
      }
    }
  }
}