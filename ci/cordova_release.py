#!/usr/bin/env python
# 2018 April-12 Aviv Vegh
# Scope: Mobile-Team
# Python script for mobile sdk promotion from martifactory to public artifactory(bintray)

import os
import argparse
import re
import fileinput
import sys
from logs import logger
import logs
import json
import logging
import tarfile
from zipfile import ZipFile

logger = logs.logger

# DEBUG mode
# --------------------------------------------------------------------
# pass argument `-DEBUG=True` examine artifacts without uploading them

# command specified in command_filters won't be executed
# example: `command_filters = ["jfrog","curl", "rm"]`
command_filters = ["jfrog", "curl"]
if len(command_filters) > 0:
    logger.setLevel(logging.DEBUG)
# --------------------------------------------------------------------

# constance
mart_dev_repo = "dev-npm"
mart_release_repo = "release-npm"
art_public_repo = "digital-generic"
path = "/medallia-digital-cordova/"

android_mart_release_repo = "release-mvn"
ios_mart_release_repo = "release-generic"
android_path = "/com/medallia/digital/mobilesdk/android-sdk/"
ios_path = "/ios-sdk/"

# Handling arguments passed from cmd-line: parsering & distribute to global variables
parser = argparse.ArgumentParser(description="mobile sdk promotion from nartifactory to public artifactory")

parser.add_argument('-DEBUG', default='False', help='True/False')

# Define script variables
args = parser.parse_args()
release_version = os.getenv('RELEASE_VERSION')
artifact_version = os.getenv('FROM_VERSION')
debug = args.DEBUG

# Artifact version regex
pattern = re.compile("-.+")


def get_promote_version():
    return release_version


def get_martifactory_url():
    url = mart_dev_repo + path + "-/medallia-digital-cordova-" + artifact_version + ".tgz"
    return url


def get_martifactory_release_url():
    url = mart_release_repo + path
    return url


def get_sdk_release_url(platform, version):
    url = ""
    if platform == "android":
        url = android_mart_release_repo + android_path + version + "/android-sdk-" + version + ".aar"
    elif platform == "ios":
        url = ios_mart_release_repo + ios_path + version + "/ios-sdk-" + version + ".zip"
    else:
        raise Exception("Platform not found")

    return url


def artifact_files_handling():
    for dir_name, sub_dir_list, file_list in os.walk(os.getcwd()):
        logger.info('Found directory: %s' % dir_name)
        os.chdir(dir_name)
        for fname in file_list:
            logger.info('Found directory: %s' % dir_name)
            if "tgz" in fname:
                logger.info('Found fname: %s' % fname)
                tar = tarfile.open(fname, "r:gz")
                tar.extractall()
                tar.close()
                updateJsonFile()
                update_mobile_sdks()
                make_tarfile('medallia-digital-cordova-' + get_promote_version() + '.tgz', 'package')
                # Delete the previus files
                os.system('rm -rf medallia-digital-cordova-' + artifact_version + '.tgz')
                os.system('rm -rf package')


def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))


def updateJsonFile():
    jsonFile = open("package/package.json", "r")  # Open the JSON file for reading
    data = json.load(jsonFile)  # Read the JSON into the buffer
    jsonFile.close()  # Close the JSON file

    ## Working with buffered content
    data["version"] = get_promote_version()

    ## Save our changes to JSON file
    jsonFile = open("package/package.json", "w+")
    jsonFile.write(json.dumps(data))
    jsonFile.close()


def update_mobile_sdks():
    current_dir = os.getcwd()
    logger.info("update mobile sdk current dir = " + current_dir)

    iosVersion = getDownloadSdkVersion("git@github.medallia.com:Digital/MobileSDK-iOS.git", "MobileSDK-iOS")

    mobile_sdk_dir = os.getcwd() + "/mobile-sdks"
    cmd("mkdir " + mobile_sdk_dir)
    os.chdir(mobile_sdk_dir)

    logger.info("downloading ios file = " + get_sdk_release_url("ios", iosVersion))
    os.system("jfrog rt dl " + get_sdk_release_url("ios", iosVersion))
    for dir_name, sub_dir_list, file_list in os.walk(os.getcwd()):
        logger.info('Found directory: %s' % dir_name)
        os.chdir(dir_name)
        for fname in file_list:
            logger.info('Unzip ios artifact')
            ios_version_name = fname
            logger.info('ios artifact = ' + ios_version_name)
            zf = ZipFile(ios_version_name, 'r')
            zf.extractall('.')
            zf.close()
            cmd("\cp -r MedalliaDigitalSDK.xcframework " + current_dir + '/package/src/ios/')

    cmd("rm -rf " + mobile_sdk_dir)
    cmd("mkdir " + mobile_sdk_dir)
    os.chdir(mobile_sdk_dir)

    androidVersion = getDownloadSdkVersion("git@github.medallia.com:Digital/MobileSDK-Android.git", "MobileSDK-Android")

    logger.info("downloading android file = " + get_sdk_release_url("android", androidVersion))
    os.system("jfrog rt dl " + get_sdk_release_url("android", androidVersion))
    for dir_name, sub_dir_list, file_list in os.walk(os.getcwd()):
        logger.info('Found directory: %s' % dir_name)
        os.chdir(dir_name)
        for fname in file_list:
            if ".aar" in fname:
                logger.info('android artifact = ' + fname)
                rename_file(fname, "medallia-android-sdk.aar")
                cmd("\cp -r medallia-android-sdk.aar " + current_dir + '/package/src/android')

    os.chdir(current_dir)
    cmd("rm -rf " + mobile_sdk_dir)


def getDownloadSdkVersion(url, folder):
    current_dir = os.getcwd()

    cmd("git clone " + url)
    os.chdir(folder)
    version = ""
    versions = get_promote_version().split(".")
    cmd("git tag -l --sort=-version:refname v" + versions[0] + "." + versions[1] + ".* >> versions.txt")

    with open('versions.txt') as f:
        version = f.readline()

    version = version.rstrip()
    version = version.replace("v", "")
    os.chdir(current_dir)
    cmd("rm -rf " + folder)

    return version


def rename_file(fname, replace_name):
    os.rename(fname, replace_name)
    logger.info('new file name = %s' % replace_name)


def cmd(command):
    if (debug == 'True' or debug == 'true') and len(command_filters) > 0 and any(
            command_filter in command for command_filter in command_filters):
        logger.debug(command)
        return

    output = os.system(command)
    if output != 0:
        raise Exception("System func execption")


def initialize():
    main_dir_name = os.getcwd()
    artifact_dir_name = os.getcwd() + "/mobile-artifact"
    logger.info('Create directory ' + artifact_dir_name)

    if os.path.isdir(artifact_dir_name):
        logger.info('Delete directory ' + artifact_dir_name)
        os.system("rm -rf " + artifact_dir_name)

    logger.info('Create directory ' + artifact_dir_name)
    cmd("mkdir " + artifact_dir_name)

    logger.info('give permission to dir: ' + "mobile-artifact")
    cmd("chmod 777 " + "mobile-artifact")

    logger.info('Check directory')
    os.chdir(artifact_dir_name)
    logger.info('current directory = ' + os.getcwd())

    artifactUrl = get_martifactory_url()
    logger.info('mArtifact full address:  {}'.format(artifactUrl))

    logger.info('Fetching JFrog artifact from artifactory..')
    os.system("jfrog rt dl " + artifactUrl)

    logger.info(cmd("ls -la"))

    logger.info('Renaming artifacts')
    artifact_files_handling()

    logger.info('uploading file to mArtifactory release = ' + get_martifactory_release_url())
    os.system('jfrog rt u *.* ' + get_martifactory_release_url())

    os.chdir(main_dir_name)
    cmd("rm -rf " + artifact_dir_name)


if __name__ == '__main__':
    initialize()
