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
xcode_build="xcodebuild -project ${work_project} -configuration Debug"

#工程绝对路径
project_path=$(pwd)
echo "======工程所在路径：${project_path}======"

#创建保存打包结果的目录
result_path=${project_path}/build/build_test_$(date +%Y-%m-%d_%H_%M)
mkdir -p "${result_path}"
echo "======最终打包路径：${result_path}======"


#工程配置文件路径
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
echo "======工程文件名称：${project_name}======"
target_name=${project_name}
echo "======target名称：${target_name}======"
project_infoplist_path=${project_path}/${project_name}/${project_name}-Info.plist
echo "======Info.plist路径：${project_infoplist_path}======"

#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${project_infoplist_path})
echo "======版本号：${bundleShortVersion}======"

#编译配置打印到文件中
setting_out=${result_path}/build_setting.txt
${xcode_build}  -showBuildSettings > ${setting_out}
echo "======编译配置：${setting_out}======"

#编译路径
build_dir=$(grep "CONFIGURATION_BUILD_DIR" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
echo "编译路径：${build_dir}"

#打包完的程序目录
appDir=${build_dir}/${target_name}.app;
#dSYM的路径
dsymDir=${build_dir}/${target_name}.app.dSYM;


#忽略证书检查
ignore_check_codesign=false

if ! $ignore_check_codesign; then
	#检查工程中证书的选择
	echo "======检查是否选择了正确的发布证书======"

	codeSign=$(grep "CODE_SIGN_IDENTITY" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
	rightDistributionSign="iPhone Distribution: Suning Appliance Co., Ltd."
	if [ "${codeSign}" != "${rightDistributionSign}" ]; then
		echo -e "\033[31m 错误的证书:${codeSign}，请进入xcode选择证书为:${rightDistributionSign} \033[0m"
		exit
	fi
	#检查授权文件
	echo "======检查是否选择了正确的签名文件======"
	provisionProfile=$(grep "PROVISIONING_PROFILE[^_]" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
	rightProvision="c59f649f-edb5-4a18-a4fe-870eb7b52d8d"   #这个是企业证书的id
	if [ "${provisionProfile}" != "${rightProvision}" ]; then
		echo -e ${provisionProfile}
		echo -e "\033[31m 错误的签名，请进入xcode重新选择授权文件 \033[0m"
		exit
	fi
fi



























# end
