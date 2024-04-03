#!/usr/bin/awk -f
#===============================================================================
#   Description: parze user configuraion from Makefile
#        Author:
#  Organization:  intel
#       Version:  1.0
#       Created:  07/25/23 17:13:40
#      Revision:  1.0
#       License:  Copyright (c) 2023
#===============================================================================

function get_help_str(strin, nameorval) {
    s = substr(strin, 2);
    # strip spaces
    gsub(/^\s*/, "", s);
    gsub(/\s*$/, "", s);

    if (nameorval == "name") {
        str_out = sprintf("%-4s%s", " ", s);
    } else if (nameorval == "val") {
        str_out = sprintf("%-8s%s", " ", s);
    }

    return str_out;
}

BEGIN{
    is_block_start = 0;
    is_new_var = 0;

    help_str = "";
    config_str = "";

    HELP_FILE = help_file;     # external variable
    CONFIG_FILE = config_file;
} {

# demo config block
# <-
#   HPS_EMIF_EN :
#       - 0: enable hps emif [default]
#       - 1: disable hps emif module
#   HPS_EMIF_ECC_EN :
#       - 0: enable hps emif ecc [default]
#       - 1: disable hps emif module
#   HPS_HBME_EN :
#       - 0: enable hps emif [default]
#       - 1: disable hps emif module
# ->

    if ($0 ~/^#\s+<-.*$/) {
        is_block_start = 1;
        next;
    }

    if ($0 ~/^#\s+->.*$/) {
        is_block_start = 0;
        exit;
    }

    if (is_block_start == 1) {
        if (match($0, /^#\s+(.+)\s*:\s*$/, var_name)) {
            str = get_help_str($0, "name");
            help_str = help_str ""str"\n";

            config_str = config_str "" sprintf("%-30s=", var_name[1]);

        } else if (match($0, /^#\s+-\s*([a-zA-Z0-9\._-]+)\s*:\s*.+$/, var_val)) {
            str = get_help_str($0, "val");
            help_str = help_str ""str"\n";

            if (match(str, /default/)) {
                config_str = config_str "" sprintf("%5s%s\n", "", var_val[1]);
            }
        }
    }

} END{

    print help_str > HELP_FILE
    print config_str > CONFIG_FILE

}
