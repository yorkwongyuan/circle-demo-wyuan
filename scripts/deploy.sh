#!/bin/sh

# 构想 https://gist.github.com/motemen/8595451

# 基于 https://github.com/eldarlabs/ghpages-deploy-script/blob/master/scripts/deploy-ghpages.sh
# MIT许可 https://github.com/eldarlabs/ghpages-deploy-script/blob/master/LICENSE

# abort the script if there is a non-zero error
set -e
pwd
remote=$(git config remote.origin.url)
echo 'remote is: '$remote

# 新建一个发布目录
mkdir gh-pages-branch
cd gh-pages-branch

# 创建一个新的仓库
# 设置发布的用户名和密码

# >/dev/null 表示将所有日志输入黑洞之中
# 2>&1 表示错误输出和标准输出绑定在一起，错误输出和标准输出将输出到同一个地方
git config --global user.email "$GH_MAIL" >/dev/null 2>&1
git config --global user.name "$GH_NAME" >/dev/null 2>&1
git init
git remote add --fetch origin "$remote"

echo 'email is: '$GH_MAIL
echo 'name is: '$GH_NAME
echo 'sourcesite is: '$sourcesite

# 切换到gh-pages分支
# git rev-parse --verify origin/gh-pages 实际上是判断远程origin是否存在gh-pages分支
if git rev-parse --verify origin/gh-pages >/dev/null 2>&1; then
  git checkout gh-pages
  # 删除就文件内容
  git rm -rf .
else
  # 创建一个无提交记录的分支
  git checkout --orphan gh-pages
fi

# 把构建好的文件拷贝进来
# cp -a 保留源文件属性前提下复制文件
# 让复制之后的文件包括文件权限都一致
cp -a "../${sourcesite}/." .

# -l 表示列出文件的详细信息包括(目录，权限，大小，所有者，修改时间等)
# -a 显示名字前带.的隐藏文件
ls -la

# 把所有文件添加到git
git add -A
# 添加一条提交内容
# 允许空白提交
git commit --allow-empty -m "Deploy to Github pages [ci skip]"

git push origin --quiet --force origin main
# 资源回收，删除临时分支和目录
cd ..

rm -rf gh-pages-branch

echo "Finish Deployment!"
