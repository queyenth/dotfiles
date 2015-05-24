#! /bin/sh

NORMIFS=$IFS
FIELDIFS=':'
NAMEPAD=$PAD

source $(dirname $0)/config

while read -r line ; do
    case $line in
        S*)
            sys_infos="${line#?}"
            ;;
        T*)
            title=$(echo ${line#?} | sed 's^\(.\{40\}\).*^\1...^')
            title="%{F$TITLE_FG} ${title} ${RPAD} %{F-}"
            ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=$FIELDIFS
            set -- ${line#?}
            while [ $# -gt 0 ] ; do
                item=$1
                case $item in
                    [OoFfUu]*)
                        # desktops
                        name=${item#?}
                        case $item in
                            O*)
                                # focused occupied desktop
                                FG=$F_O_FG
                                BG=$F_O_BG
                                ;;
                            F*)
                                # focused free desktop
                                FG=$F_F_FG
                                BG=$F_F_BG
                                ;;
                            U*)
                                # focused urgent desktop
                                FG=$F_U_FG
                                BG=$F_U_BG
                                ;;
                            o*)
                                # occupied desktop
                                FG=$O_FG
                                BG=$O_BG
                                ;;
                            f*)
                                # free desktop
                                FG=$F_FG
                                BG=$F_BG
                                ;;
                            u*)
                                # urgent desktop
                                FG=$U_FG
                                BG=$U_BG
                                ;;
                        esac
                        wm_infos="${wm_infos}%{F$FG B$BG A:bspc desktop -f ${name}:}${PAD}${name}${PAD}%{A B- F-}"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}$wm_infos %{r}$sys_infos"
done
