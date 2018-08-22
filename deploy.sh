#!/bin/sh

set -ex

# user確認
USERNAME=$(whoami)
if [${USERNAME} = "root"]; then
 echo root user です。
 exit 1 
fi

# git
targetBranch="master"
currentBranch=`git rev-parse --abbrev-ref HEAD`

echo 現在のbranchは、${currentBranch}

if [ ${targetBranch} != ${currentBranch} ]; then
  echo change ${targetBranch} branch
  git checkout $targetBranch
fi

if [ $? -ne 0 ]; then
  echo ${targetBranch}へcheckout,失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi

git pull --rebase origin $targetBranch

if [ $? -ne 0 ]; then
  echo ${targetBranch}へpull --rebase,失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi


# apach restart
#sudo su -<<EOC
#  /etc/init.d/httpd graceful
#  su moremall
#  cd ~
#
#EOC

exit

