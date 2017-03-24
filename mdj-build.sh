#!/bin/bash

#--------------------------------------------
# 功能：美到家App 打测试包
# 作者：wealon
# 创建日期：2017/03/24
#--------------------------------------------


#bundleIdentifier
bundle_id="DemoFlowCI.id"

#projectName
work_project="DemoFlowCI.xcodeproj"

#scheme
scheme="DemoFlowCI"

#xocdebuild pre
xcode_build="xcodebuild -project ${work_project} -configuration Release"

#工程绝对路径
project_path=$(pwd)
echo "======工程所在路径：${project_path}======"

#创建保存打包结果的目录
result_path=${project_path}/build/build_test_$(date +%Y-%m-%d_%H_%M)
mkdir -p "${result_path}"
echo "======最终打包路径：${result_path}======"
