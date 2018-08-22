#!/bin/sh

set -ex

date=$(date "+%Y%m%d%H%M")

# git
targetBranch="develop"
currentBranch=`git rev-parse --abbrev-ref HEAD`
branchName="feature/${date}_ohba"

echo 現在のbranchは、${currentBranch}

if [ ${targetBranch} != ${currentBranch} ]; then
  echo change ${targetBranch} branch
  # 修正退避でdevelopへcheckout
  git stash
  git checkout $targetBranch
  git stash pop
fi

if [ $? -ne 0 ]; then
  echo ${targetBranch}へcheckout,失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi

# 修正退避でpull
git stash
git pull --rebase origin $targetBranch

if [ $? -ne 0 ]; then
  # 修正帰還
  git stash pop
  echo ${targetBranch}へpull --rebase,失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi

# 修正ブランチ作成
git checkout -b ${branchName}
git stash pop

# 修正追加
git add -u
git commit -m "${date}_ohba";

if [ $? -ne 0 ]; then
  echo ${banchName}のcommitに失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi


# push
git push origin ${branchName}

if [ $? -ne 0 ]; then
  echo ${banchName}のpushに失敗しました。
  echo git errorを確認して下さい。
  exit 1
fi

# branch削除
git checkout ${targetBranch}
git branch -D ${branchName}


exit
