#!/usr/bin/env python
# Scope: Mobile-Team

import argparse
import os
import uuid

# Handling arguments passed from cmd-line: parsering & distribute to global variables
parser = argparse.ArgumentParser(description="mobile sdk promotion from martifactory release to deploy")

parser.add_argument('VERSION', default='null', help='artifact version')
parser.add_argument('API_TOKEN', default='null', help='GitHub API Token')

# Define script variables
args = parser.parse_args()
deployed_version = args.VERSION
api_token = args.API_TOKEN


def initialize():
    origin_dir = os.getcwd()
    work_dir = os.getcwd() + "/auto-bump"
    move_to_working_dir(work_dir)
    bumped_version = get_bumped_version()
    uuid_string = uuid.uuid4().hex
    cordova_plugin_bump_version(bumped_version, uuid_string)
    os.chdir(work_dir)
    cordova_app_bump_version(bumped_version, uuid_string)
    clear_working_dir(work_dir, origin_dir)


def cordova_plugin_bump_version(bumped_version, uuid_string):
    project_name = "MobileSDK-Cordova"
    git_clone(project_name)
    go_to_folder(project_name)
    bump_file_version_by_line('package.json', '"version":', bumped_version)
    branch_name = push_to_branch(bumped_version, uuid_string)
    open_pr(bumped_version, branch_name, project_name)


def cordova_app_bump_version(bumped_version, uuid_string):
    project_name = "MobileSDK-Cordova-Sample"
    git_clone(project_name)
    go_to_folder(project_name)
    bump_file_version_by_line('package.json', '"version":', bumped_version)
    bump_file_version('platforms/ios/CordovaSample/CordovaSample-Info.plist', bumped_version)
    branch_name = push_to_branch(bumped_version, uuid_string)
    open_pr(bumped_version, branch_name, project_name)


# =============================      Helpers      =============================

def move_to_working_dir(work_dir):
    if os.path.isdir(work_dir):
        os.system("rm -rf " + work_dir)
        print('Existing directory ' + work_dir + ' deleted')

    os.system("mkdir " + work_dir)
    os.system('chmod 777 ' + work_dir)
    print('Working directory ' + work_dir + ' created')

    os.chdir(work_dir)
    print('Switched to ' + os.getcwd())


def clear_working_dir(work_dir, origin_dir):
    os.chdir(origin_dir)
    print('Switched to ' + os.getcwd())
    os.system("rm -rf " + work_dir)


def git_clone(project_name):
    os.system("git clone git@github.medallia.com:Digital/" + project_name + ".git")


def go_to_folder(folder):
    current_path = os.getcwd()
    git_path = current_path + "/" + folder
    os.chdir(git_path)


def bump_file_version_by_line(filePath, line_prefix, bumped_version):
    with open(filePath, 'r') as file:
        lines = file.readlines()
    with open(filePath, 'w') as file:
        for word in lines:
            if line_prefix in word:
                new_word = word.replace(deployed_version, bumped_version)
                file.writelines(new_word)
            else:
                file.writelines(word)


def bump_file_version(filePath, bumped_version):
    with open(filePath, 'r') as file:
        filedata = file.read()
    filedata = filedata.replace(deployed_version, bumped_version)
    with open(filePath, 'w') as file:
        file.write(filedata)


def bump_json_file_version(filePath, bumped_version, json_key):
    a_file = open(filePath, "r")
    json_object = json.load(a_file)
    a_file.close()
    print(json_object)
    json_object[json_key] = bumped_version
    a_file = open(fileName, "w")
    json.dump(json_object, a_file)
    a_file.close()


def push_to_branch(bumped_version, uuid_string):
    branch_name = "BumpVersionTo" + bumped_version + "-" + uuid_string
    print("Creating a branch: " + branch_name)
    os.system("git checkout -b " + branch_name)

    print("Pushing to git")
    os.system("git add .")
    os.system("git commit -m 'Bump version to " + bumped_version + " " + uuid_string + "'")
    os.system("git push origin " + branch_name)
    return branch_name


def open_pr(bumped_version, branch_name, project_name):
    print("Opening a PR")
    os.system("curl \
            --fail \
            -X POST \
            -H \"Accept: application/vnd.github+json\" \
            -H \"Authorization: Bearer " + api_token + "\" \
            https://github.medallia.com/api/v3/repos/Digital/" + project_name + "/pulls \
            -d '{\"title\":\"[AUTO PR] Bump Version To " + bumped_version + "\",\"body\":\"Bumping version\",\"head\":\"" + branch_name + "\",\"base\":\"master\"}'")


def get_bumped_version():
    print("Deployed Version: ", deployed_version)
    split = deployed_version.split(".")
    num_string = split[1]
    num = int(num_string)
    num = num + 1
    bumped_version = split[0] + "." + str(num) + ".0"
    print("Bumped Version: ", bumped_version)
    return bumped_version


if __name__ == '__main__':
    initialize()
