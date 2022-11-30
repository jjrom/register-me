#!/command/with-contenv /bin/bash
#
# Copyright 2022 Jérôme Gasperi
#
# Licensed under the Apache License, version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

###### DO NOT TOUCH DEFAULT VALUES ########
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
JSON_FILE=/tmp/service_description.json
############################################

function showUsage {
    echo -e ""
    echo -e "   Register a service to healthcheckr endpoint (https://github.com/jjrom/healthcheckr)"
    echo -e ""
    echo -e "   Usage:"
    echo -e ""
    echo -e "      ${GREEN}HEALTHCHECKR_SERVICES_ENDPOINT=XXXXXXXXX HEALTHCHECKR_AUTH_TOKEN=XXXXXXXXX $0 -f <json>"${NC}
    echo -e ""
    echo -e "      -f | --file Service description to be registered conforms to https://github.com/jjrom/healthcheckr/blob/main/app/schemas/service.json (default /tmp/service_description.json"
    echo -e "      -h | --help show this help"
    echo -e ""
    echo -e "   [IMPORTANT]"
    echo -e ""
    echo -e "         * The target healthcheckr services endpoint must be set as an environment variable (i.e. HEALTHCHECKR_SERVICES_ENDPOINT)"
    echo -e "         * The authentication token to the target healthcheckr endpoint must be set as an environment variable (i.e. HEALTHCHECKR_AUTH_TOKEN)"
    echo -e ""
}

# Parsing arguments
while [[ $# > 0 ]]
do
	key="$1"
	case $key in
        -f|--file)
            JSON_FILE="$2"
            shift # past argument
            ;;
        -h|--help)
            showUsage
            exit 0
            shift # past argument
            ;;
            *)
        shift # past argument
        # unknown option
        ;;
	esac
done

if [[ ! -f "${JSON_FILE}" ]]; then
    echo -e "[register-me] Service description file \"${JSON_FILE}\" does not exist${NC} - aborting (see -h)"
    exit 0
fi

if [[  "${HEALTHCHECKR_SERVICES_ENDPOINT}" == "" ]]; then
    echo -e "[register-me] The target environment variable HEALTHCHECKR_SERVICES_ENDPOINT is not set - aborting (see -h)"
    exit 0
fi

if [[  "${HEALTHCHECKR_AUTH_TOKEN}" == "" ]]; then
    echo -e "[register-me] The target environment variable HEALTHCHECKR_AUTH_TOKEN is not set - aborting (see -h)"
    echo ""
    exit 0
fi

curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${HEALTHCHECKR_AUTH_TOKEN}" -d @${JSON_FILE} "${HEALTHCHECKR_SERVICES_ENDPOINT}"
 