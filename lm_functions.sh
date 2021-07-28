#!/bin/bash

# Copyright (c) 2017, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# 
# License of this script file:
#   MIT License
# 
# License is available online:
#   https://github.com/lordmikefin/LMToysBash/blob/master/LICENSE
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/LMToysBash/blob/master/lm_functions.sh



# lm_functions.sh
# This is collection of shell script functions.

# This script itself does not do anything.
# This script is used as source from other scripts.

# Some functions are using 'subshell' to protect variables.
# We do not want accidentally overwrite data set in caller script.



# Usage:
# ----------------------------------------------------------------------------
#	CURRENT_SCRIPT_REALPATH=$(realpath ${BASH_SOURCE[0]})
#	CURRENT_SCRIPT_DIR=$(dirname ${CURRENT_SCRIPT_REALPATH})
#   LM_TOYS_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/path/of/submodule/LMToysBash")
#	#IMPORT_FUNCTIONS="$(realpath "${CURRENT_SCRIPT_DIR}/../../script/lm_functions.sh")"
#	IMPORT_FUNCTIONS=$(realpath "${LM_TOYS_DIR}/lm_functions.sh")
#	if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
#		>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
#		exit 1
#	fi
#
#	source ${IMPORT_FUNCTIONS}
#
#	if [ ${LM_FUNCTIONS_LOADED} == false ]; then
#		>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Something went wrong while loading functions."
#		exit 1
#	elif [ ${LM_FUNCTIONS_VER} != "1.0.0" ]; then
#		lm_functions_incorrect_version
#		if [ "${INPUT}" == "FAILED" ]; then
#			lm_failure
#		fi
#	fi
# ----------------------------------------------------------------------------




# Currently this script provides functions:
# :Functions without subshell:
#  - lm_failure_message ()
#  - lm_failure ()
#  - lm_functions_incorrect_version ()
#  - lm_read_to_INPUT ()
#  - lm_check_KVM_WORKSPACE ()
#  - lm_select_gpu_GPU_BUS_and_GPU_SOUND () {
# :Functions with subshell:
#  - lm_verify_argument ()
#  - lm_max_argument ()
#  - lm_string_to_lower_case ()
#  - lm_create_folder_recursive ()
#  - lm_download_to_folder ()
#  - lm_verify_and_download_to_folder ()
#  - lm_file_size ()
#  - lm_add_time_stamp_to_file ()
#  - lm_rename_file ()
#  - lm_copy_file ()
#  - lm_get_git_version ()
#  - lm_get_app_version ()
#  - lm_get_java_version ()
#  - lm_pause ()
#  - lm_generate_two_hex_num ()
#  - lm_generate_mac_address ()




unset LM_FUNCTIONS_VER LM_FUNCTIONS_DATE LM_FUNCTIONS_LOADED
LM_FUNCTIONS_LOADED=false
LM_FUNCTIONS_VER="1.3.6"
LM_FUNCTIONS_DATE="2021-07-28"
#echo "LM functions version: ${LM_FUNCTIONS_VER} (${LM_FUNCTIONS_DATE})"


unset LM_FUNCTIONS LM_FUNCTIONS_REALPATH LM_FUNCTIONS_DIR LM_FUNCTIONS_WORK_DIR
unset CALLER_SCRIPT_REALPATH
CALLER_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[1]})"
LM_FUNCTIONS_REALPATH="$(realpath ${BASH_SOURCE[0]})"
LM_FUNCTIONS="$(basename ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_DIR="$(dirname ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_WORK_DIR="${PWD}"
#echo ""
#echo "LM_FUNCTIONS: ${LM_FUNCTIONS}"
#echo "LM_FUNCTIONS_REALPATH: ${LM_FUNCTIONS_REALPATH}"
#echo "LM_FUNCTIONS_DIR: ${LM_FUNCTIONS_DIR}"
#echo "LM_FUNCTIONS_WORK_DIR: ${LM_FUNCTIONS_WORK_DIR}"
#echo ""
#echo "CALLER_SCRIPT_REALPATH: ${CALLER_SCRIPT_REALPATH}"



# NOTE to myself: Read more about Bash exit codes.
#   ( http://tldp.org/LDP/abs/html/exitcodes.html )

unset OS_NAME OS_VER OS_ARCH CURRENT_SHELL INCORRECT_VERSION
OS_NAME="$(uname)"
OS_VER="$(uname -r)"
OS_ARCH="$(uname -m)"
case "${OS_NAME}" in
	"Linux" )
		# Linux is OK
		;;
	* )
		>&2 echo -e ""
		>&2 echo -e "Current OS name: ${OS_NAME}"
		>&2 echo -e "System is not supported.  Aborting."
		exit 1
esac


echo "This script is in test mode :)  Aborting." >&2
exit 1 # 127


CURRENT_SHELL="$(basename $SHELL)"
if [[ ${CURRENT_SHELL} != "bash" ]] ; then
	>&2 echo -e "\n This script is tested only with Bash.  Aborting."
	exit 1
fi


unset INCORRECT_VERSION

# Check Bash version.
TESTED_BASH_VERSION=(4 3 46)
INCORRECT_VERSION=false
# TODO: fix bash version check
#if [[ "${BASH_VERSINFO[0]}" -lt  "${TESTED_BASH_VERSION[0]}"  ]] ; then
#	INCORRECT_VERSION=true
#else
#	if [[ "${BASH_VERSINFO[1]}" -lt  "${TESTED_BASH_VERSION[1]}"  ]] ; then
#		INCORRECT_VERSION=true
#	else
#		if [[ "${BASH_VERSINFO[2]}" -lt  "${TESTED_BASH_VERSION[2]}"  ]] ; then
#			INCORRECT_VERSION=true
#		fi
#	fi
#fi

#echo "INCORRECT_VERSION : ${INCORRECT_VERSION}"
if [ "${INCORRECT_VERSION}" == true ] ; then
	IFS_BACKUP="${IFS}"
	IFS="."
#	>&2 echo -e "\n This script is tested only with Bash version 4.3.46 (or higher).  Aborting."
	>&2 echo -e "\n This script is tested only with Bash version ${TESTED_BASH_VERSION[*]} (or higher).  Aborting."
	IFS="${IFS_BACKUP}"
	exit 1
fi







lm_failure_message () {
	
	# Usage:
	#	lm_failure_message
	
	# Secondary usage:
	#	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "${MESSAGE}"
	
	# NOTE: Parameters must be in order. Each are optional.
	
	ARG_BASH_SOURCE="${BASH_SOURCE[1]}"
	if [ -n "$1" ]; then
		ARG_BASH_SOURCE="$1"
	fi
	
	ARG_BASH_LINENO="${BASH_LINENO[0]}"
	if [ -n "$2" ]; then
		ARG_BASH_LINENO="$2"
	fi
	
	ARG_MESSAGE="Script  FAILED"
	if [ -n "$3" ]; then
		ARG_MESSAGE="$3"
	fi
	
	>&2 echo "${ARG_BASH_SOURCE}: line ${ARG_BASH_LINENO}: ${ARG_MESSAGE}"
}

lm_failure () {
	# Will exit the caller script with error 1.
	# Prints error with caller script name and row number.
	
	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}"
	
	exit 1
}



lm_functions_incorrect_version () {
	
	>&2 echo ""
	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "Source script '${LM_FUNCTIONS}' is incorrect version!" # echo into stderr
	>&2 echo ""
	
	echo ""
	echo "Something has changed in ${LM_FUNCTIONS}."
	echo "Everything might not run correctly."
	echo ""
	
	unset INPUT
	lm_read_to_INPUT "Do you want to run this script as is?"
	
	case "${INPUT}" in
		"YES" )
			echo "OK then. Let's run and see what happens." ;;
		"NO" )
			echo "OK then. bye."
			exit 1 ;;
		"FAILED" | * )
			lm_failure_message ;;
	esac
}

lm_read_to_INPUT () {
	# Read input from user until we get acceptable answer.
	
	# WARNING: 
	#   This fuction will over write variables INPUT and STRING_LOW_CASE !!!
	
	# Usage:
	#	unset INPUT
	#	lm_read_to_INPUT "Do you wanna do something?"
	#	case "${INPUT}" in
	#		"YES" )
	#			INPUT="YES" ;;
	#		"NO" )
	#			INPUT="NO" ;;
	#		"FAILED" | * )
	#			lm_failure_message
	#			INPUT="FAILED" ;;
	#	esac
	
	unset INPUT
	while [[ -z ${INPUT} ]]; do
		echo -n "$1 ( Yes / [No] ): "
		read INPUT
		
		STRING_LOW_CASE="$(lm_string_to_lower_case "${INPUT}")"  || { STRING_LOW_CASE="FAILED";  lm_failure_message; }
		
		case "${STRING_LOW_CASE}" in
			"yes" | "ye" | "y" )
				INPUT="YES" ;;
			"no" | "n" | "" )
				INPUT="NO" ;;
			"FAILED" )
				INPUT="FAILED" ;;
			* )
				unset INPUT ;; # Clear input ( = stay in while loop )
		esac
	done
}

lm_check_KVM_WORKSPACE () {
	# Check if KVM_WORKSPACE variable is set.
	# If it is not, then ask what user wants to do.
	
	# Usage:
	#	unset KVM_WORKSPACE_DEFAULT
	#	lm_check_KVM_WORKSPACE
	
	if [[ -z "${KVM_WORKSPACE}" ]] ; then
		KVM_WORKSPACE_DEFAULT="${HOME}/kvm-workspace"
		
		echo ""
		echo "Variable 'KVM_WORKSPACE' is not set."
		echo "  I will use the default path: ${KVM_WORKSPACE_DEFAULT}"
		
		# Show quide how to add environment variable
		#   https://unix.stackexchange.com/questions/117467/how-to-permanently-set-environmental-variables
		
		# $ nano ~/.profile
		
		# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
		
		##add lines at the bottom of the file:
		#	export KVM_WORKSPACE="${HOME}/kvm-workspace"
		
		echo ""
		echo "Set the variable by adding line at the bottom of the file ~/.profile :"
		echo "  export KVM_WORKSPACE="${HOME}/kvm-workspace""
		
		echo ""
		echo "NOTE: If you are running bash script as sudoer, then all environment variables"
		echo "      are not preserved. Use sudo flag '-E, --preserve-env'."
		echo ""
		echo "  $ sudo -E ./script/test.sh"
		
		echo ""
		unset INPUT
		lm_read_to_INPUT "Do you want to use defalut path?"
		if [ "${INPUT}" == "YES" ]; then
			KVM_WORKSPACE="${KVM_WORKSPACE_DEFAULT}"
		fi
	fi
	
	if [[ -z "${KVM_WORKSPACE}" ]] ; then
		>&2 echo -e "\n Variable 'KVM_WORKSPACE' not set.  Aborting."
		exit 1
	fi
}

lm_select_gpu_GPU_BUS_and_GPU_SOUND () {
	# List GPUs from the file.
	# User can select GPU from the list.
	
	# WARNING: 
	#   This fuction will over write variables GPU_BUS, GPU_SOUND and SELECTED !!!
	
	# Usage:
	#	unset GPU_BUS GPU_SOUND SELECTED
	#	lm_select_gpu_GPU_BUS_and_GPU_SOUND "/path/to/vm_GPUs.conf"  || lm_failure
	
	VM_GPUS_CONF_FILE="$(lm_verify_argument "${1}")"  || lm_failure
	
	lm_max_argument "${2}"  || lm_failure
	
    if [[ ! -f "${VM_GPUS_CONF_FILE}" ]]; then
	    # >&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
	    lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "Config file '${VM_GPUS_CONF_FILE}' missing!"
	    exit 1
    fi

    #echo ""
    #echo "VM_GPUS_CONF_FILE : ${VM_GPUS_CONF_FILE}"
    #echo ""
    #echo "$(cat "${VM_GPUS_CONF_FILE}")"
    #echo "length : ${#VM_GPUS_CONF_FILE}"
    #echo ""


    echo ""
    echo "Select card to use with the vm."
    echo ""
    
    # NOTE: Read more about arrays
    #   https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
    
    BACKUP_IFS="${IFS}"
    IFS=$'\n'
    COUNT=0
    COUNT_DEV=0
    SELECTIONS_STR="0,"
    SELECTIONS=(" #0	NONE") # Declare array
    PCI_BUS_VGA=() # Declare array
    PCI_BUS_AUDIO=() # Declare array
    #echo "LINE ${COUNT} : ${LINE}"
    for LINE in $(cat "${VM_GPUS_CONF_FILE}") ; do
	    let COUNT=COUNT+1
	    if [ ${COUNT} == 1 ]; then
		    SELECTIONS+=(${LINE}) # Append to array
	    elif [ ${COUNT} == 2 ]; then
		    PCI_BUS_VGA+=(${LINE}) # Append to array
	    elif [ ${COUNT} == 3 ]; then
		    PCI_BUS_AUDIO+=(${LINE}) # Append to array
		    COUNT=0
		    let COUNT_DEV=COUNT_DEV+1
		    SELECTIONS_STR+="${COUNT_DEV},"
	    fi
    done

    IFS="${BACKUP_IFS}"
    
    #echo ""
    #echo "SELECTIONS : ${SELECTIONS[@]}"
    #echo ""
    #echo "PCI_BUS_VGA : ${PCI_BUS_VGA[@]}"
    #echo "PCI_BUS_AUDIO : ${PCI_BUS_AUDIO[@]}"
    #echo "SELECTIONS_STR : ${SELECTIONS_STR}"
    #echo ""

    unset SELECTED
    unset INPUT
    for LINE in "${SELECTIONS[@]}" ; do
	    echo " ${LINE}"
    done
    while [[ -z ${INPUT} ]]; do
	    
	    echo -n "Select one device: "
	    read INPUT
	    
	    STRING_LOW_CASE="$(lm_string_to_lower_case "${INPUT}")"  || { STRING_LOW_CASE="FAILED";  lm_failure_message; }

	    if [[ -z ${INPUT} ]]; then
		    INPUT="N/A"
	    fi
	    
	    if [[ ${SELECTIONS_STR} == *"${STRING_LOW_CASE},"* ]]; then
		    echo "FOUND"
		    SELECTED=${STRING_LOW_CASE}
	    else
		    unset INPUT  # Clear input ( = stay in while loop )
	    fi
    done
    
    echo ""
    echo "SELECTED : ${SELECTED}"
    
    # Host device bus address
    #GPU_BUS="01:00.0" # Nvidia GeForce GTX 1050 # ASUSTeK Computer Inc. Device
    #GPU_SOUND="01:00.1"
    #GPU_BUS="02:00.0" # Nvidia GeForce GT 710 # Micro-Star International Co., Ltd. [MSI] Device
    #GPU_SOUND="02:00.1"
    SEL=$((${SELECTED}-1))
    if [[ $((${SELECTED})) -gt 0 ]]; then
	    GPU_BUS="${PCI_BUS_VGA[${SEL}]}"
	    GPU_SOUND="${PCI_BUS_AUDIO[${SEL}]}"
	    echo ""
	    echo "PCI_BUS_VGA : ${GPU_BUS}"
	    echo "PCI_BUS_AUDIO : ${GPU_SOUND}"
    fi
}



######################################################################
#                                                                    #
#  Following functions are using 'subshell' to protect variables.    #
#  We do not want accidentally overwrite data set in caller script.  #
#                                                                    #
######################################################################

lm_verify_argument () {
	# Verify the argument.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   STRING="$(lm_verify_argument "${1}")"  || lm_failure
	
	( # subshell
		STRING="$1"
		
		if [ "${STRING}" == "" ]; then
			>&2 echo "Argument can not be empty."
			exit 1
		fi
		
		echo "${STRING}"
	)
}

lm_max_argument () {
	# Verify that the there is no more arguments than max.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   lm_max_argument "${1}"  || lm_failure
	
	( # subshell
		STRING="$1"
		
		if [ "${STRING}" != "" ]; then
			>&2 echo "Too many argument has been set."
			exit 1
		fi
	)
}

lm_string_to_lower_case () {
	# Convert given sting to lower case string.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   STRING_LOW_CASE="$(lm_string_to_lower_case "${STRING}")"  || lm_failure
	
	( # subshell
		
		#STRING="$(lm_verify_argument "${1}")"  || lm_failure
		STRING="${1}"
		
		lm_max_argument "${2}"  || lm_failure
		
		#$(echo "${STRING,,}")  || lm_failure
		#echo "${STRING,,} ${foo&#}"  || lm_failure
		
		echo "${STRING,,}"
		#exit 1
	)
}

lm_create_folder_recursive () {
	# Create given folder. Recursively.
	
	# Usage:
	#   lm_create_folder_recursive "${HOME}/kvm-workspace/iso"  || lm_failure
	
	( # subshell
		PATH_FOLDER="$(lm_verify_argument "${1}")"  || lm_failure
		
		lm_max_argument "${2}"  || lm_failure
		
		if [ ! -d "${PATH_FOLDER}" ]; then
			echo ""
			echo "Directory '${PATH_FOLDER}' does not exist."
			
			unset INPUT
			lm_read_to_INPUT "Do you want to create the folder?"
			case "${INPUT}" in
				"YES" )
					# No error if existing, make parent directories as needed.
					mkdir -p "${PATH_FOLDER}"  || lm_failure
					echo "Directory '${PATH_FOLDER}' and parents are created."
					INPUT="YES" ;;
				"NO" )
					echo "Folder not created."
					exit 1 ;;
				"FAILED" | * )
					lm_failure ;;
			esac
		fi
	)
}

lm_download_to_folder () {
	# Download file from the URL into the folder.
	
	# Usage:
	#   lm_download_to_folder "${FOLDER}" "${URL}"  || lm_failure
	
	( # subshell
		PATH_FOLDER="$(lm_verify_argument "${1}")"  || lm_failure
		URL="$(lm_verify_argument "${2}")"  || lm_failure
		
		lm_max_argument "${3}"  || lm_failure
		#echo ${PWD} 
		cd ${PATH_FOLDER}  || exit 1
		#echo ${PWD}
		
		echo -e "\n Downloading  ${URL} \n"
		#echo "into  ${PATH_FOLDER}"
		
		wget ${URL}  || exit 1
		
		cd ${WORK_DIR}  || exit 1
		#echo ${PWD}
	)
}

lm_verify_and_download_to_folder () {
	# Check file in the URl.
	# Check file in destination folder.
	# Verify sizes.
	# If all ok, then download file from the URL into the folder.
	
	# Usage:
	#   lm_verify_and_download_to_folder "${FILE}" "${FOLDER}" "${URL}"  || lm_failure
	
	( # subshell
		FILE="$(lm_verify_argument "${1}")"  || lm_failure
		LOCAL_FOLDER="$(lm_verify_argument "${2}")"  || lm_failure
		URL="$(lm_verify_argument "${3}")"  || lm_failure
		
		lm_max_argument "${4}"  || lm_failure
		
		
		URL_FILE="${URL}/${FILE}"
		LOCAL_FILE="${LOCAL_FOLDER}/${FILE}"
		
		
		URL_INFO="$(wget --spider "${URL_FILE}" 2>&1)"  #  || { 
#			# Must print the error. Because errors was directed to veriable.
#			>&2 echo -e "\n${URL_INFO}\n"; 
#			lm_failure; 
#		}
		URL_LENGTH_INFO="$(echo "${URL_INFO}" | grep -i "Length:")"
		URL_ARRAY=(${URL_LENGTH_INFO})
		URL_SIZE="${URL_ARRAY[1]}"
		URL_FOUND=false
		
		REGEX_INTEGER="^[0-9]+$"
		if [[ "${REGEX_INTEGER}" != "" ]] && [[  "${URL_SIZE}" =~ ${REGEX_INTEGER} ]]; then
			URL_FOUND=true
			echo "Got size of file from server: ${URL_SIZE}"
		else
			echo "Could not get size of file from server: ${URL_SIZE}"
		fi
		
##		LOCAL_FILE_INFO="$(ls -l "${LOCAL_FILE}")"  || lm_failure
#		LOCAL_FILE_INFO="$(ls -l "${LOCAL_FILE}")"
#		LOCAL_ARRAY=(${LOCAL_FILE_INFO})
#		LOCAL_SIZE="${LOCAL_ARRAY[4]}"
		LOCAL_SIZE="$(lm_file_size "${LOCAL_FILE}")"  || lm_failure
		LOCAL_FOUND=false
		
		if [[ "${REGEX_INTEGER}" != "" ]] && [[  "${LOCAL_SIZE}" =~ ${REGEX_INTEGER} ]]; then
			LOCAL_FOUND=true
			echo "Got size of local file: ${LOCAL_SIZE}"
		else
			echo "Could not get size of local file: ${LOCAL_SIZE}"
		fi

		if [ ${LOCAL_FOUND} == false ] && [ ${URL_FOUND} == false ]; then
			>&2 echo "FAILED: No local file. Can not downolad file."
			# Must print the error. Because errors was directed to veriable.
			>&2 echo -e "\n${URL_INFO}\n"; 
			lm_failure
		fi
		
		if [ ${LOCAL_FOUND} == true ] && [ ${URL_FOUND} == true ]; then
			if [ "${URL_SIZE}" == "${LOCAL_SIZE}" ]; then
				echo "File exists. URL and local file are same size."
			else
				>&2 echo "FAILED: URL and local file are different size."
				echo "TODO: Redownload ???"
				echo "TODO: Ask user to redownload."
				echo "URL_FILE : ${URL_FILE}"
				echo "LOCAL_FILE : ${LOCAL_FILE}"
#				lm_failure
				
				unset INPUT
				lm_read_to_INPUT "Do you wanna redownload it? (I'll backup the old file.)"
				case "${INPUT}" in
					"YES" )
						FILE_STAMPED="$(lm_add_time_stamp_to_file "${FILE}")"  || lm_failure #"
#						echo "FILE_STAMPED : ${FILE_STAMPED}"
						NEW_NAME="${LOCAL_FOLDER}/${FILE_STAMPED}"
#						lm_rename_file "${LOCAL_FILE}" "${NEW_NAME}" # Backup the file
						lm_rename_file "${LOCAL_FILE}" "${NEW_NAME}"  || lm_failure
						
						lm_download_to_folder "${LOCAL_FOLDER}" "${URL_FILE}"  || lm_failure
						LOCAL_SIZE="$(lm_file_size "${LOCAL_FILE}")"  || lm_failure #"
			
						if [[ "${REGEX_INTEGER}" != "" ]] && [[  "${LOCAL_SIZE}" =~ ${REGEX_INTEGER} ]]; then
							LOCAL_FOUND=true
							echo "Got size of local file: ${LOCAL_SIZE}"
						else
							echo "Could not get size of local file: ${LOCAL_SIZE}"
						fi
						;;
					"NO" )
						INPUT="NO" ;;
					"FAILED" | * )
						lm_failure_message
						INPUT="FAILED" ;;
				esac
			fi
		fi
		
		if [ ${LOCAL_FOUND} == false ] && [ ${URL_FOUND} == true ]; then
			lm_download_to_folder "${LOCAL_FOLDER}" "${URL_FILE}"  || lm_failure
			LOCAL_SIZE="$(lm_file_size "${LOCAL_FILE}")"  || lm_failure
			
			if [[ "${REGEX_INTEGER}" != "" ]] && [[  "${LOCAL_SIZE}" =~ ${REGEX_INTEGER} ]]; then
				LOCAL_FOUND=true
				echo "Got size of local file: ${LOCAL_SIZE}"
			else
				echo "Could not get size of local file: ${LOCAL_SIZE}"
			fi
		fi
		
		
		if [ ${URL_FOUND} == true ]; then
			if [ "${URL_SIZE}" == "${LOCAL_SIZE}" ]; then
				echo "File download complete."
			else
				>&2 echo "FAILED: File download was not completed."
				echo "TODO: Redownload ???"
				echo "URL_FILE : ${URL_FILE}"
				echo "LOCAL_FILE : ${LOCAL_FILE}"
#				lm_failure
				
				unset INPUT
				lm_read_to_INPUT "Do you wanna use local file?"
				case "${INPUT}" in
					"YES" )
						INPUT="YES" ;;
					"NO" )
						lm_failure
						INPUT="NO" ;;
					"FAILED" | * )
						lm_failure_message
						INPUT="FAILED" ;;
				esac
			fi
		fi
	)
}

lm_file_size () {
	# Return size of file.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.

	# Usage:
	#   FILE_SIZE="$(lm_file_size "${FILE}")"  || lm_failure
	
	( # subshell
		FILE="$(lm_verify_argument "${1}")"  || lm_failure
		
		lm_max_argument "${2}"  || lm_failure
		
#		LOCAL_FILE_INFO="$(ls -l "${FILE}")"  || lm_failure
		LOCAL_FILE_INFO="$(ls -l "${FILE}")"
		LOCAL_ARRAY=(${LOCAL_FILE_INFO})
		LOCAL_SIZE="${LOCAL_ARRAY[4]}"
		
		echo "${LOCAL_SIZE}"
	)
}

lm_add_time_stamp_to_file () {
	# Return file name with time stamp.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.

	# Usage:
	#   FILE_STAMPED="$(lm_add_time_stamp_to_file "${FILE}")"  || lm_failure
	
	( # subshell
		FILE="$(lm_verify_argument "${1}")"  || lm_failure
		
		lm_max_argument "${2}"  || lm_failure
		
		TIMESTAMP=$(date +"%y-%m-%d_%H-%M-%S")  || lm_failure
		FILE_BASE="$(basename ${FILE})"  || lm_failure
		FILENAME="${FILE%.*}"
		
#		EXTENSION="${FILE##*.}"
		if [[ "${FILE_BASE}" == *.* ]]; then
			EXTENSION="${FILE##*.}"
			FILE_STAMPED="${FILENAME}_${TIMESTAMP}.${EXTENSION}"
		else
			EXTENSION=""
			FILE_STAMPED="${FILENAME}_${TIMESTAMP}"
		fi
		
		echo "${FILE_STAMPED}"
	)
}

lm_rename_file () {
	# Rename (move) the file.
	
	# Usage:
	#   lm_rename_file "${FILE}" "${NEW_NAME}"  || lm_failure
	
	( # subshell
		FILE="$(lm_verify_argument "${1}")"  || lm_failure
		NEW_NAME="$(lm_verify_argument "${2}")"  || lm_failure
		
		lm_max_argument "${3}"  || lm_failure
		
#		echo "mv -v ${FILE} ${NEW_NAME}"
		mv -v "${FILE}" "${NEW_NAME}"  || lm_failure
	)
}

lm_copy_file () {
	# Copy file.
	
	# Usage:
	#   lm_copy_file "${FILE}" "${NEW_NAME}"  || lm_failure
	
	( # subshell
		FILE="$(lm_verify_argument "${1}")"  || lm_failure
		NEW_NAME="$(lm_verify_argument "${2}")"  || lm_failure
		
		lm_max_argument "${3}"  || lm_failure
		
		#echo "cp -v ${FILE} ${NEW_NAME}"
		cp -v "${FILE}" "${NEW_NAME}"  || lm_failure
	)
}

lm_get_git_version () {
	# Print git version.
	# Will print empty if 'git' aplication is not available
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   GIT_VERSION=$(lm_get_git_version)  || lm_failure
	
	( # subshell
		lm_max_argument "${1}"  || lm_failure
		
		git --version  2>/dev/null  || {
			#lm_failure
			
			# NOTE: No need to fail the script. Just return empty.
			echo ""
		}
	)
}

lm_get_app_version () {
	# Print APP version.
	# Will print empty, if aplication is not available.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   GIT_VERSION=$(lm_get_app_version git)  || lm_failure
	
	( # subshell
		APP="$(lm_verify_argument "${1}")"  || lm_failure
		
		lm_max_argument "${2}"  || lm_failure
		#>&2 echo ${APP}
		EVAL_THIS="${APP} --version"
		#$(${APP} --version  2>/dev/null)  || {
		eval ${EVAL_THIS}  2>/dev/null  || {
			#lm_failure
			
			# NOTE: No need to fail the script. Just return empty.
			echo ""
		}
	)
}

lm_get_java_version () {
	# Print APP version.
	# Will print empty, if java is not available.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   JAVA_VERSION=$(lm_get_java_version)  || lm_failure
	
	( # subshell
		lm_max_argument "${1}"  || lm_failure
		eval java -version  2>/dev/null  || {
			echo "Failed"
		} && {
		    echo ""
		}
	)
}

lm_pause () {
	# Implements good old DOS 'pause' command for Bash ;)
	
	# Usage:
	#   pause
	
	( # subshell
		read -p "Press [Enter] key to continue..."
	)
}

lm_generate_two_hex_num () {
	# Generate two hexadecimal numbers.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   RAND_HEX="$(lm_generate_two_hex_num)"  || lm_failure
	
	( # subshell
		HEX=$(printf '%02X' $((RANDOM%256)))
		
		echo "${HEX}"
	)
}

lm_generate_mac_address () {
	# Generate a MAC address.
	# Define different mac address for each vm.
	# Otherwise all vms are using the default one.
	
	# https://www.linux-kvm.org/page/Networking
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   MACADDRESS="$(lm_generate_mac_address)"  || lm_failure
	
	( # subshell
	    #HEX1="$(lm_generate_two_hex_num)"
	    #HEX2="$(lm_generate_two_hex_num)"
	    #HEX3="$(lm_generate_two_hex_num)"
	    #HEX4="$(lm_generate_two_hex_num)"
	    HEX5="$(lm_generate_two_hex_num)"
	    HEX6="$(lm_generate_two_hex_num)"
	    
	    # NOTE: Looks like all mac addresses are not allowed ???
	    # TODO: Find out why is not all mac addresses allowed.
	    
		#MAC="${HEX1}:${HEX2}:${HEX3}:${HEX4}:${HEX5}:${HEX6}"
		MAC="DE:AD:BE:EF:${HEX5}:${HEX6}"
		
		echo "${MAC}"
	)
}

#echo ""
#echo "Functions loaded from: '${LM_FUNCTIONS}'"
#echo ""

LM_FUNCTIONS_LOADED=true

