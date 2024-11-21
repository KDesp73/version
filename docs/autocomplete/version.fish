function _version
    set COMP_LINE (commandline --cut-at-cursor)

    set COMP_WORDS
    echo $COMP_LINE | read --tokenize --array COMP_WORDS
    if string match --quiet --regex '.*\s$' $COMP_LINE
        set COMP_CWORD (math (count $COMP_WORDS) + 1)
    else
        set COMP_CWORD (count $COMP_WORDS)
    end

    set literals "--help" "autocomplete" "--version" "generate" "man" "ignored" "version" "-h" "update" "get" "--debug" "list" "init" "-v"

    set descriptions
    set descriptions[4] "Generate various files"
    set descriptions[8] "Prints the help message"
    set descriptions[9] "Update the project version"
    set descriptions[10] "Get various values"
    set descriptions[11] "Set DEBUG to true"
    set descriptions[12] "Lists the files that will possibly change"
    set descriptions[13] "Initializes the version config file"
    set descriptions[14] "Prints the script's version"

    set literal_transitions
    set literal_transitions[1] "set inputs 1 3 4 8 11 9 10 12 13 14; set tos 2 2 3 2 2 2 4 2 2 2"
    set literal_transitions[3] "set inputs 2 5; set tos 2 2"
    set literal_transitions[4] "set inputs 6 7; set tos 2 2"

    set match_anything_transitions_from 
    set match_anything_transitions_to 

    set state 1
    set word_index 2
    while test $word_index -lt $COMP_CWORD
        set -- word $COMP_WORDS[$word_index]

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --erase inputs
            set --erase tos
            eval $literal_transitions[$state]

            if contains -- $word $literals
                set literal_matched 0
                for literal_id in (seq 1 (count $literals))
                    if test $literals[$literal_id] = $word
                        set index (contains --index -- $literal_id $inputs)
                        set state $tos[$index]
                        set word_index (math $word_index + 1)
                        set literal_matched 1
                        break
                    end
                end
                if test $literal_matched -ne 0
                    continue
                end
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set word_index (math $word_index + 1)
            continue
        end

        return 1
    end

    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --erase inputs
        set --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            if test -n $descriptions[$literal_id]
                printf '%s\t%s\n' $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s\n' $literals[$literal_id]
            end
        end
    end


    return 0
end

complete --command version --no-files --arguments "(_version)"
