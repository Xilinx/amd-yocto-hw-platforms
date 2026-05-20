#!/usr/bin/env bash
#
# enable_segmented_config.sh
#
# Ensures the 'segmented_configuration' property is set to 'true' in
# update_bd.tcl inside the Vitis_Embedded_Platform_Source submodule for
# the vck190_base platform.
#

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

DEFAULT_TARGET="${REPO_ROOT}/eval_board_examples/Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/vck190_base/hw/xsa_scripts/update_bd.tcl"
TARGET_FILE="${1:-${DEFAULT_TARGET}}"

INSERT_AT_LINE=13
DESIRED_VALUE="true"
COMMENT_LINE="#enable segmented configuration"

# Matches an existing 'set_property segmented_configuration <true|false>' line.
PROP_REGEX='^[[:space:]]*set_property[[:space:]]+segmented_configuration[[:space:]]+(true|false)\b'
# Matches the line already set to DESIRED_VALUE.
DESIRED_REGEX="^[[:space:]]*set_property[[:space:]]+segmented_configuration[[:space:]]+${DESIRED_VALUE}\\b"

if [[ ! -f "${TARGET_FILE}" ]]; then
    echo "ERROR: target file not found: ${TARGET_FILE}" >&2
    echo "Hint: make sure the Vitis_Embedded_Platform_Source submodule is initialized:" >&2
    echo "        git submodule update --init --recursive" >&2
    exit 1
fi

# If a segmented_configuration property already exists, leave it alone when
# it matches DESIRED_VALUE, otherwise flip it in place.
if grep -qE "${PROP_REGEX}" "${TARGET_FILE}"; then
    # Already at desired value: no-op.
    if grep -qE "${DESIRED_REGEX}" "${TARGET_FILE}"; then
        echo "INFO: segmented_configuration already set to '${DESIRED_VALUE}' in:"
        echo "        ${TARGET_FILE}"
        echo "      Nothing to do."
        exit 0
    fi

    # Rewrite the existing true/false value to DESIRED_VALUE.
    sed -i -E "s/(set_property[[:space:]]+segmented_configuration[[:space:]]+)(true|false)/\\1${DESIRED_VALUE}/" \
        "${TARGET_FILE}"

    echo "INFO: updated segmented_configuration to '${DESIRED_VALUE}' in:"
    echo "        ${TARGET_FILE}"
    exit 0
fi

sed -i "${INSERT_AT_LINE}i\\
${COMMENT_LINE}\\
set_property segmented_configuration ${DESIRED_VALUE} [current_project]" "${TARGET_FILE}"
