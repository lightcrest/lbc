_OLD_PATH=$PATH

PATH=$LBCMDDIR:.

for cmd in help cd pushd popd dirs pwd ; do enable -n $cmd ; done

LBCMD="PATH=$_OLD_PATH $LBCMDDIR/lbcmd"

alias help="$LBCMD help"
alias status="$LBCMD status"
alias push="$LBCMD push"
alias init-host="$LBCMD init-host"

PS1="lbcmd> "
