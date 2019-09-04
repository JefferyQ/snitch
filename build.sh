#! /bin/ksh
#! @brief Build black/white lists
#! @revision 2019-09-04 (Wed) 14:38:48

typeset jq='jq .'; whence -q jq || jq=cat

function build_blacklist {

    (   print_header 'ISLE Blacklist' 'Disabled Internet resources for any process (and any user).'
        print_disabled
        print_footer
    )   | $jq > blacklist.lsrules
}

function build_whitelist {

    (   print_header 'ISLE Whitelist' 'Allowed HTTP(S) targets for any process (and any user).'
        print_allowed
        print_footer
    )   | $jq > whitelist.lsrules
}

function print_allowed {

    typeset fmt='{ "action" : "allow", "ports" : "%s", "process" : "any", "protocol" : "tcp", "remote-%s" : "%s" }'
    #ypeset fmt='{ "action" : "allow", "ports" : [ "80", "443" ], "process" : "any", "protocol" : "tcp", "remote-%s" : "%s" }'
    integer count=0; typeset all=( addresses domains hosts )

    # Determine the number of entries that we will process
    typeset file; for file in ${all[@]}; do

        # Make sure the definition file exists
        file=whitelist.$file; [[ -f $file ]] || continue;

        # Count number of definition lines in file
        count+=$(grep -v '^#' $file | grep -v '^$' | wc -l)

    done

    # Make sure we have something to process
    (( count > 0 )) || return

    printf '"rules": [\n'

    # Process all possible definition files
    for file in ${all[@]}; do

        # Make sure the definition file exists
        typeset path=whitelist.$file; [[ -f $path ]] || continue

        # Read the definition file, line by line
        typeset line; cat $path | while read line; do

            # Ignore empty lines and comments
            [[ -z $line || ${line:0:1} == '#' ]] && continue

            # Determine if we should append a JSON comma
            typeset comma=','; (( -- count > 0 )) || comma=

            # Output the JSON line
            printf "$fmt,\n$fmt$comma\n" 80 $file $line 443 $file $line

        done

    done

    printf ']\n'

}

function print_disabled {

    typeset fmt='{ "action" : "allow", "ports" : [ "80", "443" ], "process" : "any", "protocol" : "tcp", "remote-%s" : "%s" }'
    typeset all=( addresses domains hosts )

    # Process all possible definition files
    for file in ${all[@]}; do

        # Make sure the definition file exists
        typeset path=blacklist.$file; [[ -f $path ]] || continue

        # Count number of definition lines in file
        count=$(grep -v '^#' $path | grep -v '^$' | wc -l)

        # Make sure we have something to process
        (( count > 0 )) || return

        printf '"denied-remote-%s": [' $file

        # Read the definition file, line by line
        typeset line; cat $path | while read line; do

            # Ignore empty lines and comments
            [[ -z $line || ${line:0:1} == '#' ]] && continue

            # Determine if we should append a JSON comma
            typeset comma=','; (( -- count > 0 )) || comma=

            # Output the JSON line
            printf '"%s"%s\n' "$line" "$comma"

        done

        printf '],\n'

    done

    # Print dummy field so we don't have to clear the last comma above
    printf '"owner": "me"\n'

}

function print_footer {

    printf '}\n'

}

function print_header {

    typeset name="$1" brief="$2"
    printf '{\n"name": "%s",\n"description": "%s",\n' "$name" "$brief"

}

enum boolean=( false true ); boolean show_usage=true

[[ -n $1 && $1 == @(all|blacklist) ]] && { show_usage=false; build_blacklist; }
[[ -n $1 && $1 == @(all|whitelist) ]] && { show_usage=false; build_whitelist; }

(( show_usage == false )) && exit 0.

print "usage: ${0##*/} [ blacklist | whitelist | all ]"
exit 2

# vim: nospell spelllang=en
