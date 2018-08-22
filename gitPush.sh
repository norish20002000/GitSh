#!/bin/sh

set -ex

date=$(date "+%Y%m%d%H%M")

# git
targetBranch="develop"
currentBranch=`git rev-parse --abbrev-ref HEAD`
branchName="feature/${date}_ohba"

echo ���݂�branch�́A${currentBranch}

if [ ${targetBranch} != ${currentBranch} ]; then
  echo change ${targetBranch} branch
  # �C���ޔ���develop��checkout
  git stash
  git checkout $targetBranch
  git stash pop
fi

if [ $? -ne 0 ]; then
  echo ${targetBranch}��checkout,���s���܂����B
  echo git error���m�F���ĉ������B
  exit 1
fi

# �C���ޔ���pull
git stash
git pull --rebase origin $targetBranch

if [ $? -ne 0 ]; then
  # �C���A��
  git stash pop
  echo ${targetBranch}��pull --rebase,���s���܂����B
  echo git error���m�F���ĉ������B
  exit 1
fi

# �C���u�����`�쐬
git checkout -b ${branchName}
git stash pop

# �C���ǉ�
git add -u
git commit -m "${date}_ohba";

if [ $? -ne 0 ]; then
  echo ${banchName}��commit�Ɏ��s���܂����B
  echo git error���m�F���ĉ������B
  exit 1
fi


# push
git push origin ${branchName}

if [ $? -ne 0 ]; then
  echo ${banchName}��push�Ɏ��s���܂����B
  echo git error���m�F���ĉ������B
  exit 1
fi

# branch�폜
git checkout ${targetBranch}
git branch -D ${branchName}


exit
